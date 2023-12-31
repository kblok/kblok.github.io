---
title: Puppeteer-Sharp 2023 Recap
tags: puppeteer-sharp csharp
permalink: /blog/puppeteer-sharp-2023-recap
---

It has been a while since I wrote those [Puppeteer-Sharp blog posts](https://www.hardkoded.com/blog/whats-new-puppeteer-sharp-april-2022) (maybe it's time to do it again?). However, I thought it would be nice to recap all the progress made in 2023.

It can be quite challenging to keep Puppeteer-Sharp up-to-date. On one side I was implementing great features at [mabl](https://www.mabl.com/), that took most of my time. Additionally, I love using [playwright](https://playwright.dev/)! In my opinion, mabl is the leading low-code testing platform in the market, while playwright is the best end-to-end testing library.

So, how about Puppeteer-Sharp? 

I hope that Puppeteer-Sharp can become the best multi-purpose browser automation library, the most complete [CDP](https://chromedevtools.github.io/devtools-protocol/) API in .net, and maybe, why not? the best/first [Webdriver BiDi](https://developer.chrome.com/docs/web-platform/best-practices/webdriver-bidi) library for .net?

In 2023, Puppeteer-Sharp achieved over 9 million downloads and received sponsorship from the [.NET on AWS Open Source Software Fund](https://github.com/aws/dotnet-foss?tab=readme-ov-file). These two acknowledgments were fuel for me.

My main goal in 2023 was to close the gap with [puppeteer](https://github.com/puppeteer/puppeteer). I was able to launch 19 versions! I didn't expect that number to be that big!  
These are a few features I would like to highlight.

## Query handlers

You can query elements by text:

```cs
await Page.SetContentAsync("<section>test</section>");
var testEl - await Page.QuerySelectorAsync("text/test");
```

Or even by Aria roles:

```cs
await Page.WaitForSelectorAsync("aria/[role=\"button\"]");
```

Event XPaths are also implemented using a query handler:

```cs
var els = await Page.QuerySelectorAllAsync("xpath///img");
```

## Chrome for testing

How we download browsers also had a significant change. You can now download [Chrome for testing](https://developer.chrome.com/blog/chrome-for-testing) instead of chromium. Keeping the browser up-to-date became a high-priority task.

You can look at many other new features on the [release page](https://github.com/hardkoded/puppeteer-sharp/releases?page=1).

# About 2024.

Closing the feature gap will still be my top priority. **But**, the rumors about puppeteer moving to [WebDriver Bidi](https://developer.chrome.com/blog/puppeteer-webdriver-bidi-2023) sounds... exciting. Making Puppeteer-Sharp a great WebDriver BiDi API sounds promising.  
On the personal side, I think this website need some refresh :)

# Final words

What are you expecting from Puppeteer-Sharp in 2024? Should I write more? Should I share more examples? Let me know.

And remember, Puppeteer-Sharp is a library BY the community FOR the community. We build this library together. The issues tab in GitHub is open for all of you to share your ideas and thoughts. You can also [sponsor the project](https://github.com/sponsors/hardkoded). Even a single dollar would help me know you care about this project.

Remember to follow me on X [@hardkoded](https://twitter.com/hardkoded) for more updates.

Don't stop coding!


