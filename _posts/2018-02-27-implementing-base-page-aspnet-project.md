---
title: Implementing a BasePage in your ASP.NET Webforms Project
tags: csharp aspnet
permalink: /blogs/implementing-base-page-aspnet-project
---

I started to prepare two posts, one about Page Sessions and the other one about reducing QueryString, ViewState and Session boilerplate. But I realized that both solutions were implemented on a BasePage. So I felt that I first needed to write about the importance of implementing a BasePage in a project.

## What is a BasePage?

I bet you have noticed that all your pages inherit from [Page](https://msdn.microsoft.com/en-us/library/system.web.ui.page%28v=vs.110%29.aspx?WT.mc_id=DT-MVP-5003814). This implementation has three goals:

 * The ASP.NET Runtime knows how to instantiate a Page class and interact with it.
 * The Page class does all the hard work for us, Nothing less than turning our page into HTML.
 * It provides us with tools that make us more productive. For instance, it provides an easy way to persist data in ViewState or helps us determine if we are in a PostBack or not.

>What if we make our own Page class so we can add more tools to our toolbox?

## How can we do it?

The implementation is simple. We just need a class that inherits from Page.

```cs
public class BasePage : Page
{

}
```

Then we need to go page by page (ok, you can use replace all), changing all your pages, so they inherit from BasePage instead of Page.

So we turn this:

```cs
public class default: Page
```

Into this
```cs
public class default: BasePage
```

## What can we add to our toolbox?

There are many things you can do on this BasePage. As I mentioned before, I will write a few posts about some solutions, such as PageSessions and reducing QueryString boilerplate. But, for now, let me give you some ideas.

###  Make user data available across the board

Do you need the user full name on every page?
Move that boilerplate to your BasePage.

```cs
public class default: BasePage
{
    public string UserFullName
    {
        get
        {
            return Session[userfullname].ToString();
        }
        set
        {
            Session[userfullname] = value;
        }
    }
}
```

### Change the thread culture

If you want to serve users around the globe, you need to take their culture into consideration. According to [this Wikipedia article](https://en.wikipedia.org/wiki/Date_format_by_country), if you render the date 1/2/2018, around 600 million people will read "January second, 2018", whereas 3565 million people will read "February first, 2018".
If you know the user's culture you can set it in the current thread. Then, all `ToString` methods will use that culture to render dates and numbers properly.

```cs
Thread.CurrentThread.CurrentCulture = Thread.CurrentThread.CurrentUICulture = new CultureInfo(userCulture);
```

### Communication across the board between the browser

Let's say you have a cart application and need to change the style. This could be because the cart is filled, the user is logged in, or maybe the user is from another country. You can set classes in the form element and then use them in your CSS stylesheet.

```cs
Form.Attributes["class"] = 
    mainElement.Attributes["class"] + " " +
    (HasItemsInCart() ? "items-in-cart" : string.Empty);
```

And then in your CSS you can do this
```css
.items-in-cart .some-cart-div
{
    display: block;
}
```

You can also declare javascript variables you need across the board. Let's say you know the user culture and you want to take advantage of it; not only on the server side, but also on the client site. You could declare a javascript variable on all your pages.

```cs
ScriptManager.RegisterClientScriptBlock(
    this, 
    GetType(), 
    "currentCulture", 
    $"var currentCulture = '{userCulture}';", 
    true);
```

### Generic methods
I bet you’ve written a method called `FindControlInAllControls`, which tries to find a control in a Controls array using a recursive loop. A BasePage is a great place to implement this.

### Compress your ViewState

You could implement [this ViewState compression](https://www.codeproject.com/Tips/638653/Compress-the-viewstate-Information) in your base page. This was also [recommended by Scott Hanselman](https://www.hanselman.com/blog/ZippingCompressingViewStateInASPNET.aspx).

### PageSession

PageSessions? What's that?
I'm going to write a post about page sessions and you'll be able to implement it on your BasePage.

### Reduce QueryString/Session/Viewstate boilerplates

I hate the boilerplate used to sync and initialize variables from QueryString, session and ViewState. I'll post a few ideas to eliminate those boilerplates using.... yes, you guessed it!, Your BasePage.

## Final words

[Dependency Injection](https://en.wikipedia.org/wiki/Dependency_injection)  and extension methods may have become popular in modern development, but as we've seen in this Basepage exercise, inheritance still has a lot to offer.


