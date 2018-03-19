---
title: Killing boilerplates in ASP.NET - Volume 1
tags: csharp aspnet
permalink: /blogs/killing-boilerplates-in-aspnet-volume-1
---

We all hate boilerplates, right? That bunch of code that you copy over and over again. Boilerplates are not a complex piece of code but code so simple that we don't take time to think about it.
 
In this post, I will cover how to reduce some boilerplates we use for:
* Getting values from QueryString or AppSettings.
* Keep ViewState or Session data in sync.
 
# QueryString and AppSettings boilerplates
 
These two boilerplates are similar and quite simple. You need to grab some value from QueryString or AppSettings, convert it into a valid data type, and set it to one of your variables. Your code might look like this:
 
```cs
public partial class Default : System.Web.UI.Page
{
   int _userId;
   bool _someFeatureToggle;
   protected void Page_Load(object sender, EventArgs e)
   {
       _userId = SomeMethodToSafelyParseAString<int>(Request.QueryString["userId"]);
       _someFeatureToggle = SomeMethodToSafelyParseAString<bool>(ConfigurationManager.AppSettings["SomeFeatureToggle"]);
   }
   public void SomeMethod()
   {
       var data = new Service().GetData(_userId, _minValidDate);
   }
}
```
Yeah, not a big deal but, at the end, it's a boilerplate.
 
# Sync Data stored in ViewState or Session
 
So, let's say you have a DataSet and you need to keep it in sync while the user performs different actions on a page. I bet your code is doing something like this:
 
* Init data if it's not a postback.
* Restore it if it's a postback.
* Some actions changing that data.
* Persist data in an storage.
 
```cs
public partial class Default : System.Web.UI.Page
{
   int _userId;
   bool _someFeatureToggle;
   DataSet _data;
 
   protected void Page_Load(object sender, EventArgs e)
   {
       _userId = SomeMethodToSafelyParseAString<int>(Request.QueryString["userId"]);
       _someFeatureToggle = SomeMethodToSafelyParseAString<bool>(ConfigurationManager.AppSettings["SomeFeatureToggle"]);
       if (!IsPostBack)
       {
           _data = new Service().GetData(_useID, _someFeatureToggle);
       }
       else
       {
           _data = (DataSet)PageSession["data"];
       }
   }
   protected void Grid_ItemCommand(object sender, RowCommandEventArgs args)
   {
       if (args.CommandName == "DeleteFirstRow")
       {
           _data.Tables[0].Rows[0].Delete();
       }
   }
   protected void Page_PreRender(object sender, EventArgs e)
   {
       PageSession["data"] = _data;
   }
}
```
 
This is a boilerplate we would want to avoid!
 
# Attributes to the rescue
 
Wouldn't it be great if we could implement all these boilerplates using attributes?

Our code would look like this:
 
```cs
public partial class Default : System.Web.UI.Page
{
   [QueryString]
   int _userId;
   [AppSettings]
   bool _someFeatureToggle;
   [KeepInSession]
   DataSet _data;
 
   protected void Page_Load(object sender, EventArgs e)
   {
   }

   protected void Grid_ItemCommand(object sender, RowCommandEventArgs args)
   {
       if (args.CommandName == "DeleteFirstRow")
       {
           _data.Tables[0].Rows[0].Delete();
       }
   }
   protected void Page_PreRender(object sender, EventArgs e)
   {
   }
}
```
 
# Implementing attributes
 
In order to implement this solution, we'll need 2 things: The attributes to mark our fields, and some piece of code that processes those attributes and performs the tasks we need.
 
Coding an attribute is quite easy. We don't need much code there because they are used just to mark our variables.
 
```cs
[AttributeUsage(AttributeTargets.Field)]
public sealed class QueryStringAttribute : Attribute
{
    public string QueryStringKey { get; set; }

    public QueryStringAttribute()
    {
    }
    public QueryStringAttribute(string queryStringKey)
    {
        QueryStringKey = queryStringKey;
    }
}
```
 
# Let's set some variables
 
As I mentioned in my previous post [Implementing PageSession](http://www.hardkoded.com/blogs/implementing-pagesession-aspnet-project), The [PreLoad](https://msdn.microsoft.com/en-us/library/system.web.ui.page.preload(v=vs.110).aspx) event is perfect for this, because we need those variables to be ready to be used as soon as possible.
 
Another thing it’d be cool to do is to support these attributes on our Master pages. We can start by doing something like this:
 
```cs
void BasePage_PreLoad(object sender, EventArgs e)
{
   EvalFieldsOnPreLoad(this);
   var master = Master;
   while (master != null)
   {
       EvalFieldsOnPreLoad(master);
       master = master.Master;
   }
}
```
 
I won't put here the entire code because you can check this out on its [GitHub repo](https://github.com/kblok/AspNetExamples/tree/master/PageAttributesDemo). But the `EvalFieldsOnPreLoad` looks something like this:
 
```cs
private void EvalFieldsOnPreLoad(object instance)
{
   var type = instance.GetType();
   while (type.Equals(typeof(Page)) || type.Equals(typeof(UserControl)))
   {
       foreach (var field in type.GetFields(
           BindingFlags.NonPublic | BindingFlags.Public | 
           BindingFlags.Instance | BindingFlags.DeclaredOnly))
       {
           var queryStringAttribute = GetAttributeFromField<QueryStringAttribute>(field);
           if (queryStringAttribute != null)
           {
                if (string.IsNullOrEmpty(queryStringAttribute.QueryStringKey))
                {
                    field.SetValue(instance, 
                        Convert.ChangeType(
                            Request.QueryString[field.Name], 
                            field.FieldType));
                }
                else if(!string.IsNullOrEmpty(Request.QueryString[queryStringAttribute.QueryStringKey]))
                {
                    field.SetValue(instance, 
                        Convert.ChangeType(
                            Request.QueryString[queryStringAttribute.QueryStringKey], 
                            field.FieldType));
                }
           }
       type = type.BaseType;
   }
```
 
We are half-way there. Our QueryStringAttribute and AppSettingsAttribute will work with this code. Now we need to finish the data sync for the KeepInSession and KeepInViewState attributes.
 
As the `PreLoad` event is the best place to load data as early as possible, the [PreRenderComplete](https://www.google.com.ar/search?q=PreRenderComplete&oq=PreRenderComplete&aqs=chrome..69i57j0l5.318j0j1&sourceid=chrome&ie=UTF-8) event is the best place to store data, because it's being called after our code is executed (commonly Page_Load, Events and Page_PreRender). So we can do something like this:
 
```cs
void BasePage_PreRenderComplete(object sender, EventArgs e)
{
   EvalFieldsOnPreRenderComplete(this);
   var pageMaster = Master;
   while (pageMaster != null)
   {
       EvalFieldsOnPreRenderComplete(pageMaster);
       pageMaster = pageMaster.Master;
   }
}
```
 
And the EvalFieldsOnPreRenderComplete would be something like this:
 
```cs
private void EvalFieldsOnPreRenderComplete (object instance)
{
   Type type = instance.GetType();
   while (type.Equals(typeof(Page)) || type.Equals(typeof(UserControl)))
   {
       foreach (var field in type.GetFields(
           BindingFlags.NonPublic | BindingFlags.Public | 
           BindingFlags.Instance | BindingFlags.DeclaredOnly))
       {
           var keepInSessionAttribute = GetAttributeFromField<KeepInSessionAttribute>(field);
           if (keepInSessionAttribute != null)
           {
               Session[field.Name + "AutoSave"] = field.GetValue(instance);
           }
       }
       type = type.BaseType;
   }
}
```
 
# Final Words
 
I love this solution. If you implement this your code will be clear and more declarative. Feel free to fork it from [GitHub](https://github.com/kblok/AspNetExamples/tree/master/PageAttributesDemo).
 
Don't stop coding!


