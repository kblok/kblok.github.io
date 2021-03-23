---
title: Puppeteer-Sharp 3 is here!
tags: puppeteer-sharp csharp
permalink: /blog/puppeteer-sharp-3-is-here
---

I'm so excited to announce that, after eight months, Puppeteer-Sharp 3 is here!  
![party](https://media.giphy.com/media/1yJEEsgy4q2bu/giphy.gif)

Getting Puppeteer-Sharp 3 out was quite a challenge. **The lack of [sponsors](https://github.com/sponsors/hardkoded) on Puppeteer-Sharp** and the [strong support of Microsoft on Playwright-Sharp](https://www.hardkoded.com/blog/playwright-sharp-joins-microsoft) made me put all my efforts on Playwright-Sharp.

But while a was writing the [UI Testing with Puppeteer](https://www.uitestingwithpuppeteer.com/) book, Puppeteer-Sharp got to 1 Million downloads (1 million downloads and only three sponsors), I said to myself: "Hey, let's do something to celebrate!" So I decided to wrap up **Experimental Firefox Support**. And that took us to v3!

# What's new

PuppeteerSharp 3 is the first version that doesn't fully map the same version (Puppeteer 3) upstream. It's quite a Frankenstein, version-wise, but for good!  
The first neat feature is that it's shipping Chromium 90.0.4403.0, which is the version that Puppeteer v8 is using.  
The second new feature is `EmulateNetworkConditionsAsync`, which is also a feature introduced in Puppeteer v8.  
And last, but not least, is experimental Firefox support.

# The state of the Fox

Using PuppeteerSharp with Firefox is as easy as passing `Product.Firefox` to both the `BrowserFetcher` constructor, and the `LaunchAsync` method:

```cs
await new BrowserFetcher(Product.Firefox).DownloadAsync();
using var browser = await Puppeteer.LaunchAsync(new LaunchOptions 
{ 
    Headless = false, 
    Product = Product.Firefox 
});
using var page = await browser.NewPageAsync();
await page.GoToAsync("https://www.google.com");
await page.ScreenshotAsync("./google.png");
```

But remember, this is still experimental. Only 340 tests of the 681 are running on Firefox. It's not a lot, but it's something.  
I also had to turn off the tests on Windows because of many zombie processes that remained open. I found this also happens on the node version.

I want to thank [Robin Richtsfeld](https://github.com/Androbin) who implemented the emulate network conditions feature, among many other things, and [Simon Cropp](https://github.com/SimonCropp) who takes every project he touches to the next level.

# What's next

I created the [V9 Project](https://github.com/hardkoded/puppeteer-sharp/projects/43), so we can take PuppeteerSharp to what I guess will be the next Puppeteer version.

But it will be hard to accomplish it without help. I hope I can get more support from contributors on this next project. 

> If you are reading this post and making money with Puppeteer-Sharp, **I encourage you to [sponsor this project](https://github.com/sponsors/hardkoded)**.

I hope we can catch Puppeteer soon and keep this project moving.  

Don't stop coding!
 
