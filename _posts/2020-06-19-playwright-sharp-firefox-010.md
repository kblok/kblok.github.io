---
title: PlaywrightSharp v0.10 for Firefox is here!
tags: playwright-sharp csharp
permalink: /blog/playwright-sharp-firefox-010
---

![firefox](https://media.giphy.com/media/xsE65jaPsUKUo/giphy.gif)  
Firefox joined to the PlaywrightSharp familiy!


## What can I do with PlaywrightSharp.Firefox?

You can do lots of things.  
![a lot](https://media.giphy.com/media/qkdTy6tTmF7Xy/giphy.gif)

Seriously!

![seriously](https://media.giphy.com/media/Ful8UzCFYAjlu/giphy.gif)


You should be able to do almost everything you would do with his older brother PuppeteerSharp or his younger brother PlaywrightSharp.Chromium.  
This is how you can take an screenshot in PlaywrightSharp **NOW**!

```cs 
var options = new LaunchOptions
{
    Headless = true
};

Console.WriteLine("Downloading Firefox");
var firefox = new FirefoxBrowserType();

await firefox.CreateBrowserFetcher().DownloadAsync();

Console.WriteLine("Navigating google");
await using var browser = await firefox.LaunchAsync(options);
var page = await browser.DefaultContext.NewPageAsync();
await page.GoToAsync("http://www.microsoft.com");

Console.WriteLine("Taking Screenshot");
File.WriteAllBytes(Path.Combine(Directory.GetCurrentDirectory(), "microsoft.png"), await page.ScreenshotAsync());

Console.WriteLine("Export completed");
```

## Is there anything I can't do?

There are only two features not implemented on PlaywrightSharp.Firefox: PDF generator and Tracing.

## Can I use this package in Production?

As [I mentioned when we launched Playwrightsharp.Chromium](https://www.hardkoded.com/blog/playwright-sharp-monthly-jun-2020), If you start using PlaywrightSharp now, the API is going to change, guaranteed, but you will jump into a project that will have way more support and new features.

PuppeteerSharp doesn't support Fireofox yet. So I believe PlaywrightSharp.Firefox, even in its 0.10 version is the best library to automate Firefox in .NET.

# Final words

Now that we shipped our first version, I'm looking forward to getting more feedback. The issues tab in GitHub is open for all of you to share your ideas and thoughts.  
Don't forget to follow me on Twitter [@hardkoded](https://twitter.com/hardkoded) to get more updates.

Don't stop coding!
