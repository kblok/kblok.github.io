---
title: Playwright Sharp Monthly Report - Sep 2020
tags: playwright-sharp csharp
permalink: /blog/playwright-sharp-monthly-sep-2020
---

Two months passed since our [last monthly report back in July](https://www.hardkoded.com/blog/playwright-sharp-monthly-jul-2020). I'm so sorry about that. But, in the past two months, we were able to merge 161 pull requests!

![wow](https://64.media.tumblr.com/tumblr_ma0do9CrEh1qi2sux.gif)

Those 161 PRs took Playwright-Sharp to **v0.111.2**! You can download this version from Nugget.

## A massive change under the hood

Playwright-Sharp now uses a playwright driver to perform most of its operations. That will help Playwright-Sharp to keep Playwright pace, and it will also give Playwright users consistency across different bindings.
BTW, Do you need to run Playwright in Python? We now have [playwright-python](https://github.com/microsoft/playwright-python) :)

### Would I need to install Node.JS to use the new version of Puppeteer-Sharp?

No, the driver will have node.js embedded.

## About the version number

The version number might sound quite odd. Let's unwrap it.  
Although this version matches Playwright 1.1.1, I want to leave some room for this API to change. That's why it's not v1 yet.

Its minor version is 111 because it matches v1.1.1, and tts revision is 2 because... you know... things can fail.

I believe that the next version will be v1.4 with a stable API.

## Breaking changes

The first change you will notice is that we merged all the previous four packages we had (PlaywrightSharp.Abstractions, PlaywrightSharp.Chromium, PlaywrightSharp.Firefox, and PlaywrightSharp.Webkit) into one single PlaywrightSharp package.

There are not many breaking changes in the code. But the way we now install and launch a browser has changed.

Let's look at this example

```cs 
static async Task Main(string[] args)
{
    Console.WriteLine("Installing playwright");
    await Playwright.InstallAsync();
    using var playwright = await Playwright.CreateAsync();
    await using var browser = await playwright.Chromium.LaunchAsync(headless: true);

    var page = await browser.NewPageAsync();
    Console.WriteLine("Navigating google");
    await page.GoToAsync("http://www.google.com");

    Console.WriteLine("Generating PDF");
    await page.GetPdfAsync(Path.Combine(Directory.GetCurrentDirectory(), "google.pdf"));

    Console.WriteLine("Export completed");
}
```

`Playwright.InstallAsync` will install all the required browsers. It replaces the old `BrowserFetcher`.

```cs
await Playwright.InstallAsync();
```

As I mentioned before, PlaywrightSharp now relies on the Playwright driver. That's why we now need to call `Playwright.CreateAsync`. This method will create a new driver process that Playwright-Sharp will use to interact with the browser.

```cs
using var playwright = await Playwright.CreateAsync();
```

That playwright instance will give us tools to launch different browsers:

```cs
await using var browser = await playwright.Chromium.LaunchAsync(headless: true);
```


From there, everything would look like the code you had before.

# What's next?

I hope we can ship v1.4 during September. That would be our first v1 version. Wish me luck.

![Good luck](https://media0.giphy.com/media/3oeSAz6FqXCKuNFX6o/giphy.gif)

# Activity

 * Repository Stars: 140 (prev 117) +19%
 * Repository Forks: 10 (prev 8) +25%
 * Nuget downloads: 662

 
# Final words

Getting close to our first v1 version, I'm looking forward to getting more feedback. The issues tab in GitHub is open for all of you to share your ideas and thoughts.  
Don't forget to follow me on Twitter [@hardkoded](https://twitter.com/hardkoded) to get more updates.

Don't stop coding!

#### Previous Reports
 * [Jul 2020](https://www.hardkoded.com/blog/playwright-sharp-monthly-jul-2020)
 * [Jun 2020](https://www.hardkoded.com/blog/playwright-sharp-monthly-jun-2020)
 * [May 2020](https://www.hardkoded.com/blog/playwright-sharp-monthly-may-2020)
 * [April 2020](https://www.hardkoded.com/blog/playwright-sharp-monthly-apr-2020)
 * [March 2020](https://www.hardkoded.com/blog/playwright-sharp-monthly-march-2020)