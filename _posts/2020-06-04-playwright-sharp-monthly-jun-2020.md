---
title: Playwright Sharp Monthly Report - June 2020 - PlaywrightSharp v0.10 is here!
tags: playwright-sharp csharp
permalink: /blog/playwright-sharp-monthly-jun-2020
---

As promised last month, We have PlaywrightSharp.Chromium v0.10!!!

![party](https://media.giphy.com/media/KYElw07kzDspaBOwf9/giphy.gif)

It's PlaywrightSharp.Chromium 0.10.3 to be accurate.  
Following the style of many .NET libraries, PlaywrightSharp will deliver four NuGet packages:

 * **PlaywrightSharp.Abstractions**: You will need this package if you want to make a browser-agnostic library. In other words, Playwright-Sharp extensions. We shipped v0.10.3 of this package.
 * **PlaywrightSharp.Chromium**: Chromium client. We shipped v0.10.3 of this package.
 * **PlaywrightSharp.Firefox**: Firefox client. I hope we can ship v0.10.3 this month.
 * **PlaywrightSharp.Webkit**: Webkit client. We are not going to ship a v0.10 of this package. You will get this on v1.


## What can I do with PlaywrightSharp.Chromium?

![a lot](https://media.giphy.com/media/xUVnVIzO42cGu8MHDM/source.gif)

You can do a lot with PlaywrightSharp.Chromium. I could even say that you can do everything you would do with his older brother PuppeteerSharp.  
This is how you can create a PDF in PlaywrightSharp **NOW**!

```cs 
Console.WriteLine("Downloading chromium");
var chromium = new ChromiumBrowserType();

await chromium.CreateBrowserFetcher().DownloadAsync();

Console.WriteLine("Navigating google");
await using var browser = await chromium.LaunchAsync(new LaunchOptions
{
  Headless = true
});
var page = await browser.DefaultContext.NewPageAsync();
await page.GoToAsync("http://www.google.com");

Console.WriteLine("Generating PDF");
await page.GetPdfAsync(Path.Combine(Directory.GetCurrentDirectory(), "google.pdf"));

Console.WriteLine("Export completed");
```

## Challenge Hardkoded!

Is there anything you want to see how it looks in PlaywrightSharp? Leave a comment!  
I also challenge you! Try out PlaywrightSharp, send me a gist or GitHub link, and I will create a post with that :)

## Should I go with PuppeteerSharp or PlaywrightSharp?

That's a good question, Thank you invisible developer!

PuppeteerSharp has a stable API, but, as my time is limited, my effort in fixing bugs and responding to questions will be on PlaywrightSharp.

If you go with PlaywrightSharp, the API is going to change, guaranteed, but you will jump into a project that will have way more support and new features. PlaywrightSharp will also give you Firefox and Webkit in the near future.

# Progress

 * Playwright's tests: 1182
 * Playwright Sharp's tests coded: 828
   * Passing on Chromium: 828
   * Passing on Webkit: 0
   * Passing on Firefox: 629
  
# Activity

 * Repository Stars: 94 (prev 62) +51%
 * Repository Forks: 7 (prev 5) +40%
 * Nuget downloads: 0
 * Contributors: 3

# Contributors

* [Meir Blachman](https://twitter.com/MeirBlachman) is doing most of the job on the Firefox project. So if you get to use Playwright-Sharp with Firefox, thanks Meir!
 
# Final words

Now that we shipped our first version, I'm looking forward to getting more feedback. The issues tab in GitHub is open for all of you to share your ideas and thoughts.  
Don't forget to follow me on Twitter [@hardkoded](https://twitter.com/hardkoded) to get more updates.

Don't stop coding!

#### Previous Reports
 * [May 2020](https://www.hardkoded.com/blogs/playwright-sharp-monthly-may-2020)
 * [April 2020](https://www.hardkoded.com/blogs/playwright-sharp-monthly-apr-2020)
 * [March 2020](https://www.hardkoded.com/blogs/playwright-sharp-monthly-march-2020)