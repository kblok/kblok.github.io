---
title: Implementing PageSession in ASP.NET Webforms
tags: csharp aspnet
permalink: /blogs/implementing-pagesession-aspnet-project
---

Maintaining the state of a large page can be quite a challenge. Let's say you were asked to implement a page with four tabs, each with two GridViews. Each Gridview would be editable and you would have one save button which would execute all database actions.

The most common solutions would be:
 * Keep the state in ViewState. The user pays the cost, getting a larger page.
 * Keep the state on the server. The server pays the cost, keeping that data in memory.

Although the use of Sessions isn't recommended for public websites (because the number of concurrent users is unknown), it can be a good solution for intranet sites with a relatively low number of users.

But, if you opt for Sessions, you'll have problems if the user opens the same page on different tabs. This is when PageSessions come into play.

>Wouldn't it be great to have a Session collection by page instead of by... Session?

The recipe is simple. We will need:
 * An unique identifier per page call.
 * Use the unique identifier as a prefix for all the Session keys created on that page.
 * A way to clear the Session for a certain page.
 * An easy way to use all these elements as if it were a normal Session.

## Prerequisites

As I mentioned in my [previous post](https://www.hardkoded.com/blogs/implementing-base-page-aspnet-project), Having a `BasePage` is a great place to build these kinds of solutions.

## Step 1: Create your unique identifier

A unique page identifier will help us identify elements corresponding to that specific page instance in the global Session collection. One easy way to implement this is by using a GUID.

I find the [PreLoad](https://msdn.microsoft.com/en-us/library/system.web.ui.page.preload(v=vs.110).aspx) event a great place to initialize this GUID, because we can be sure that the PageSession will be ready when the developer needs it (which would be most likely on Page_Load, Control Events and Page_PreRender)

```cs
public class BasePage : Page
{
    public string PageKey
    {
        get => ViewState["PageInstanceUID"]?.ToString();
        internal set => ViewState["PageInstanceUID"] = value;
    }

    public BasePage()
    {
        PreLoad += BasePage_PreLoad;
    }

    private void BasePage_PreLoad(object sender, EventArgs e)
    {
        if (!IsPostBack && string.IsNullOrEmpty(PageKey))
        {
            PageKey = Guid.NewGuid().ToString();
        }
        else
        {
            PageKey = (string)(ViewState["PageInstanceUID"]);
        }
    }
}
```

## Step 2: PageSession class 

Now it's time to implement the real PageSession class. As I mentioned before, the key is to use the normal Session with the `PageKey` property created before as a preffix.

We also want to create a list of all the keys we created, so that we can remove those items from the Session.

```cs
public class PageSession
{
    private readonly BasePage _page;

    public PageSession(BasePage page)
    {
        _page = page;
    }

    public object this[string name]
    {
        get => _page.Session[GetFullKey(name)];
        set
        {
            //We create the PageSession list
            if (_page.Session[_page.PageKey + "_SessionList"] == null)
            {
                _page.Session[_page.PageKey + "_SessionList"] = new List<string>();
            }

            //We add the item to the list
            if (!((List<string>)_page.Session[_page.PageKey + "_SessionList"]).Contains(GetFullKey(name)))
            {
                ((List<string>)_page.Session[_page.PageKey + "_SessionList"]).Add(GetFullKey(name));
            }

            //We add the item to the Session collection using the preffix
            _page.Session[GetFullKey(name)] = value;
        }
    }

    public void Clear()
    {
        Clear(_page.PageKey);
    }

    public void Clear(string pageKey)
    {
        if (HttpContext.Current.Session[pageKey + "_SessionList"] != null)
        {
            foreach (string item in HttpContext.Current.Session[pageKey + "_SessionList"] as List<string>)
                
            {
                if (HttpContext.Current.Session[item] != null)
                {
                    if (HttpContext.Current.Session[item] is IDisposable)
                    {
                        ((IDisposable)HttpContext.Current.Session[item]).Dispose();
                    }
                    HttpContext.Current.Session[item] = null;
                    HttpContext.Current.Session.Remove(item);
                }
            }

            HttpContext.Current.Session[pageKey + "_SessionList"] = null;
            HttpContext.Current.Session.Remove(pageKey + "_SessionList");
        }
    }

    public string GetFullKey(string name) => _page.PageKey + name;
}
```

Then we create a PageSession on our BagePage and expose it as a property.

```cs
public class BasePage : Page
{
    public string PageKey
    {
        get => ViewState["PageInstanceUID"]?.ToString();
        internal set => ViewState["PageInstanceUID"] = value;
    }

    public PageSession PageSession { get; internal set; }

    public BasePage()
    {
        PreLoad += BasePage_PreLoad;
    }

    private void BasePage_PreLoad(object sender, EventArgs e)
    {
        if (!IsTruePostBack && string.IsNullOrEmpty(PageKey))
        {
            PageKey = Guid.NewGuid().ToString();
        }
        else
        {
            PageKey = (string)(ViewState["PageInstanceUID"]);
        }

        PageSession = new PageSession(this);
    }
}
```

## Step 3: PageSession expiration

This is where things become a little bit messy. The idea behind the PageSession expiration is trying to identify when the user leaves the page. So we're are going to play with the javascript [unload event](https://developer.mozilla.org/en-US/docs/Web/Events/unload).

First, we need to create a [WebMethod](https://msdn.microsoft.com/en-us/library/system.web.services.webmethodattribute(v=vs.110).aspx) so we can clear the PageSession from javascript.

```cs
[WebMethod(true)]
public static void CleanUpPageSession(string pageKey)
{
   new PageSession(null).Clear(pageKey);
}
```

Then, we need to distinguish between a postback and a real Javascript unload.

```cs
ClientScript.RegisterHiddenField("IsBasePagePostBack", "");
ClientScript.RegisterHiddenField("BasePagePageKey", PageKey);
```

Now we set IsBasePagePostBack to "1" when we are sure that the page is doing a PostBack.

```cs
ClientScript.RegisterStartupScript(
    GetType(), 
    "OnUnloadMethods",
    "addEvent(window, 'unload', pageSessionCleanUp); function setBasePagePostBack(){{document.getElementById('IsBasePagePostBack').value = '1'; return true;}};", true);

ClientScript.RegisterOnSubmitStatement(
    GetType(), 
    "SafeUnload", 
    "setBasePagePostBack();");
```

And last but not least, we need a cleanUp function in javascript, so we can call our cleanup method doing an ajax call.

```js
function pageSessionCleanUp() {
    if (document.getElementById('IsBasPagePostBack').value !== '1') {
        PageMethods.CleanUpPageSession(document.getElementById('BasePagePageKey').value);
    }
}
```

# Final Words

You can find the source code [here](https://github.com/kblok/AspNetExamples), feel free to fork it and play with it.

Don't stop coding!



