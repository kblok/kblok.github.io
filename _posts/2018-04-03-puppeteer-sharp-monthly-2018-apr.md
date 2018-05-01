---
title: Puppeteer Sharp Monthly Report - April 2018
tags: puppeteer-sharp csharp
permalink: /blogs/puppeteer-sharp-monthly-april-2018
---
 
March was an exciting Month for Puppeteer Sharp. [CI Server](https://ci.appveyor.com/project/kblok/puppeteer-sharp) is up an running. [Version 0.3](https://github.com/kblok/puppeteer-sharp/releases/tag/v0.3) was released, implementing IDisposable, many `Puppeteer` features (such as `User dat dir` support) and also fixing many process leaks. We also released v.0.3.1, adding .NET Framework support.

We are now working on [v0.4](https://github.com/kblok/puppeteer-sharp/projects/7), which is mostly `Page` releated. We have implemented all these features:

* Page.SetJavascriptEnable
* Page.SetContent
* Page.EvaluateExpression and Page.EvaluateFunction
* Page.Title
* Page.Url
* Page.Browser

# What can you do so far?

`Page.SetContent`, `Page.EvaluateExpression` and `Page.EvaluateFunction` are super exciting features.

## Page.SetContent

`Page.SetContent` allows you to inject HTML into a Page. Just to give you an example, with SetContent you could implement a batch process to create receipts in HTML, print it to PDF, and send it to a customer.

```cs
using(var page = await Browser.NewPageAsync())
{
    await page.SetContentAsync("<div>My Receipt</div>");
    var result = await page.GetContentAsync();
    await page.PdfAsync(outputFile);
    SaveHtmlToDB(result);
}
```

Pretty cool huh?

## Evaluate functions and expressions

The ability to inject and execute javascript functions and expressions is important not only to the user but also important for Puppeteer Sharp itself. Many features are based on this feature.

In [Puppeteer](https://github.com/GoogleChrome/puppeteer) these 2 features are implemented using the `evaluate` function, where expressions are being passed as string and functions as javascript functions. This is easy to implement in NodeJS because you can `toString()` a function (it returns the javascript code as string) and send it to Chromium. Though we could implement a C# translation to Javascript  functionality, I think it doesn’t worth the effort now.

```cs
using (var page = await Browser.NewPageAsync())
{
    var seven = await page.EvaluateFunctionAsync<int>(“4 + 3”);
    var someObject = await page.EvaluateFunctionAsync<dynamic>("(value) => ({a: value})", 5);
    Console.WriteLine(someObject.a);
}
```

# Progress

* Tests on Google's Puppeteer: 554 (prev. 548)
* Tests on Puppeteer Sharp: 55 (prev. 19)
* Passing tests: 55 (prev. 19)

# Activity 

* Repository Stars: 50 (prev. 27) +85%
* Repository Forks: 7 (prev. 5) +40%
* Nuget downloads: 478 (prev. 195) +143%
* Contributors: 1

# Contributors

[Meir Blachman](https://www.twitter.com/MeirBlachman) pushed 6 PRs out of 17 and reviewed all my PRs. The project got an steady pace and code quality has improved since he jumped it.

# What's Next

I hope we can release [v0.4](https://github.com/kblok/puppeteer-sharp/projects/7) in April. 39% of the features are implemented but this version is important and many features are challenging.

# Final words

I started receiving feedback from the community, and this is great, it’s what we need. But on the other hand it also showed me that we need to make more progress in order to have Puppeteer Sharp ready for the real world.

I’m looking forward to getting more feedback. The issues tab in github is open for all of you to share your ideas and thoughts. You can also follow me on Twitter [@hardkoded](https://www.twitter.com/hardkoded).

Don't stop coding!

#### Previous Reports

 * [March 2018](http://www.hardkoded.com/blogs/puppeteer-sharp-monthly-march-2018)
 * [February 2018](http://www.hardkoded.com/blogs/puppeteer-sharp-monthly-february-2018)