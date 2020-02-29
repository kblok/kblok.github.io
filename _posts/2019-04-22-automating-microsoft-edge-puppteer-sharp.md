---
title: Automating Microsoft Edge with Puppeteer-Sharp
tags: puppeteer-sharp csharp
permalink: /blog/automating-microsoft-edge-puppteer-sharp
cross-site-link: https://www.hardkoded.com/es/blog/automatizando-edge-con-puppeteer
---

As you may have heard, Microsoft made available to the public its [Chromium-powered Edge browser](https://www.microsoftedgeinsider.com/en-us/).  Maybe this question won't qualify as technical interview question but:

>If Puppeteer-Sharp automates Chromium, and Microsoft Edge (insider) is powered by chromium, that would mean that...

![Idea](https://media.giphy.com/media/B5AVgxf0OzlyE/giphy.gif)

When you call `Puppeteer.LaunchAsync`, one of the values you can set in the `LaunchOptions` is the [ExecutablePath](https://www.puppeteersharp.com/api/PuppeteerSharp.LaunchOptions.html#PuppeteerSharp_LaunchOptions_ExecutablePath).

So, what would happen if we launch Puppeteer passing our Microsoft Edge browser path?

```cs
var browser = await Puppeteer.LaunchAsync(new LaunchOptions
{
    Headless = true,
    ExecutablePath = "C:\\Program Files (x86)\\Microsoft\\Edge Dev\\Application\\msedge.exe"
});
```

Let's write a super simple example:

```cs
var browserOptions = new LaunchOptions
{
    Headless = false,
    ExecutablePath = "C:\\Program Files (x86)\\Microsoft\\Edge Dev\\Application\\msedge.exe"
};

var browser = await Puppeteer.LaunchAsync(browserOptions);
var page = await browser.NewPageAsync();

await page.SetContentAsync("<div>Testing</div>");
```

Voilà!

![demo running](https://github.com/kblok/kblok.github.io/raw/master/img/microsoft-edge-puppeteer/demo-running.png)

And after a [few tweaks](https://github.com/kblok/puppeteer-sharp/pull/1074) in puppeteer-sharp, and [one similar change](https://github.com/GoogleChrome/puppeteer/pull/4314) in puppeteer, we managed to get all tests running using Microsoft Edge!

![tests running](https://github.com/kblok/kblok.github.io/raw/master/img/microsoft-edge-puppeteer/tests-running.png)

So we can say that Puppeteer-Sharp v1.14 is fully compatible with Microsoft Edge Insider version 75.0.131.0.

![Yeah](https://media1.giphy.com/media/TdfyKrN7HGTIY/giphy.gif?cid=790b76115cbda5016531733341f0d371)

Don't stop coding!
