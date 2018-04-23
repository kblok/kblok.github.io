---
title: Puppeteer Sharp v0.4 is here, and it's huge!
tags: puppeteer-sharp csharp
permalink: /blogs/puppeteer-sharp-v04-is-here
---

I’m so excited to announce that [Puppetter Sharp v0.4](https://github.com/kblok/puppeteer-sharp) is ready to download from [Nuget](https://www.nuget.org/packages/PuppeteerSharp/). It includes more than 25 Page APIs such as:

* Full Page.GoToAsync/ReloadAsync support
* Emulate/EmulateMedia/SetViewport/SetUserAgent
* Get and Set cookies
* SetContent
* Evaluate javascript functions and expressions
* WaitFor expressions

```cs
await page.GoToAsync("http://www.mysite.com");

//Do you need to wait for your javascript framework to load content?
//You got it!
await page.WaitForSelectorAsync("div.main-content");

///Emulate media print? Sure!
await Page.EmulateMediaAsync(MediaType.Print);

//Or an iPhone?
await Page.EmulateAsync(iPhone);

///Inject a cookie
await page.SetCookieAsync(new CookieParam
{
    Name = "gridcookie",
    Value = "GRID",
    Path = "/grid.html"
});

//Or even HTML!
await page.SetContentAsync("<div>hello</div>");

//How about executing javascript functions?
await page.EvaluateFunctionAsync<int>("(a) => 5 + a", myValueForA);

```

## Extra goodies

We added support for remote browser connections. This will allow Puppeteer Sharp to be used in docker containers or Azure Functions.

```cs
var options = new ConnectOptions()
{
    BrowserWSEndpoint = $"wss://browserproviderwhomightwanttosponsortheproject.io"
};

var url = "https://www.google.com/";

using (var browser = await PuppeteerSharp.Puppeteer.ConnectAsync(options))
{
    using (var page = await browser.NewPageAsync())
    {
        await page.GoToAsync(url);
        await page.PdfAsync("wot.pdf");
    }
}
```

These are the new available APIs:

    - Page.GoToAsync
    - Page.ReloadAsync
    - Page.EmulateMediaAsync
    - Page.SetViewport
    - Page.EmulateAsync
    - Page.SetUserAgentAsync
    - Page.MetricsAsync
    - Page.Dialog
    - Page.Error
    - Page.RequestCreated
    - Page.GetCookiesAsync
    - Page.SetCookieAsync
    - Page.SetExtraHttpHeadersAsync
    - Page.AuthenticateAsync
    - Page.SetJavaScriptEnabledAsync
    - Page.SetContentAsync
    - Page.EvaluateFunctionAsync
    - Page.EvaluateExpressionAsync
    - Page.GetTitleAsync
    - Page.SetOfflineModeAsync
    - Page.CloseAsync
    - Page.Console
    - Page.WaitForTimeoutAsync
    - Page.WaitForFunctionAsync
    - Puppeteer.ConnectAsync
    - Browser.Disconnect();

Don't stop coding!

