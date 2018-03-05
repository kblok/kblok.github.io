---
title: Puppeteer Sharp Monthly Report - March 2018
tags: puppeteer-sharp csharp
permalink: /blogs/puppeteer-sharp-monthly-march-2018
---
 
# Puppeteer Sharp v0.1 released!
I'm super excited to announce that the first **usable** version of Puppeteer Sharp is ready to download from [Nuget](https://www.nuget.org/packages/PuppeteerSharp/). The first milestone on the [roadmap](http://www.hardkoded.com/blogs/puppeteer-sharp-monthly-february-2018) is completed.

# What can you do so far?

## PDF support

You can export any page to PDF file.

{% highlight CS %}
var browser = await PuppeteerSharp.Puppeteer.LaunchAsync(options, chromiumRevision);
var page = await browser.NewPageAsync();
await page.GoToAsync("https://www.google.com");
await page.PdfAsync(outputFile);
{% endhighlight %}

You can also get a PDF file in a stream.

{% highlight CS %}
var browser = await PuppeteerSharp.Puppeteer.LaunchAsync(options, chromiumRevision);
var page = await browser.NewPageAsync();
await page.GoToAsync("https://www.google.com");
var stream = await page.PdfStreamAsync();
await UploadToAzure(stream);
{% endhighlight %}

`PdfAsync` supports the following options:
 * Scale `<decimal>` Scale of the webpage rendering. Defaults to 1.
 * DisplayHeaderFooter `<bool>` Display header and footer. Defaults to false.
 * HeaderTemplate `<string>` HTML template for the print header. 
 * FooterTemplate `<string>` HTML template for the print footer. Should use the same format as the HeaderTemplate.
 * PrintBackground `<bool>` Print background graphics. Defaults to false.
 * Landscape `<boolean>` Paper orientation. Defaults to false.
 * PageRanges `<string>` Paper ranges to print, e.g., '1-5, 8, 11-13'. 
 Defaults to an empty string, which means print all pages.
 * Format `<string>` Paper format. If set, takes priority over width or height options. Defaults to 'Letter'.
 * Width `<string>` Paper width, accepts values labeled with units.
 * Height `<string>` Paper height, accepts values labeled with units.
 * Margin `<MarginOptions>` Paper margins, defaults to none.
 * Top `<string>` Top margin, accepts values labeled with units.
 * Right `<string>` Right margin, accepts values labeled with units.
 * Bottom `<string>` Bottom margin accepts values labeled with units.
 * Left `<string>` Left margin, accepts values labeled with units.

*Documentation adapted from the [original Puppeteer repo](https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md#pagescreenshotoptions)*

## Screenshot support

You can take a screenshot of a page (the visible part based on the viewport), a full page, or a part of it.

{% highlight CS %}
var browser = await PuppeteerSharp.Puppeteer.LaunchAsync(options, chromiumRevision);
var page = await browser.NewPageAsync();

await page.SetViewport(new ViewPortOptions
    {
        Width = 500,
        Height = 500
    });

await page.GoToAsync("https://www.google.com");
await page.ScreenshotAsync(outputFile);
{% endhighlight %}

You can also use `ScreenshotStreamAsync` to get a stream instead of a file.

The `ScreenshotAsync` method supports the following options:

 * Type `<string>` Specify screenshot type This can be either jpeg or png. Defaults to 'png'.
 * Quality `<decimal?>` The quality of the image, between 0-100. Not applicable to png images.
 * FullPage `<bool>` When true, takes a screenshot of the full scrollable page. Defaults to false.
 * Clip `<Clip>` An object which specifies clipping region of the page. Should have the following fields:
    * X `<int>` x-coordinate of top-left corner of clip area.
    * Y `<int>` y-coordinate of top-left corner of clip area.
    * Width `<int>` width of clipping area.
    * Height `<number>` height of clipping area.
 * OmitBackground `<bool>` Hides default white background and allows capturing screenshots with transparency. Defaults to false.

*Documentation adapted from the [original Puppeteer repo](https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md#pagescreenshotoptions)*

# Progress

* Tests on Google's Puppeteer: 548 (prev. 523)
* Tests on Puppeteer Sharp: 19 (prev. 1)
* Passing tests: 19 (prev. 1)

# Activity 

* Repository Stars: 34 (prev. 13) +161%
* Repository Forks: 5 (prev. 2) +150%
* Nuget downloads: 223 (prev. 114) +95%
* Contributors: 1

# New Contributors

I want to thank [Meir Blachman](https://twitter.com/MeirBlachman), the first contributor, for jumping in. He implemented the LaunchOptions class. I hope this is the first of many contributions and contributors!

# What's Next

March will be about: First, Complete all tasks for (pseudo) version [0.2](https://github.com/kblok/puppeteer-sharp/projects/9). Basically, setting up AppVeyor and creating all the community docs we need. Then, start with version [0.3](https://github.com/kblok/puppeteer-sharp/projects/8) which is about implementing Puppeteer.launch tests.

# Final words

I hope you guys start testing the library. I’m looking forward to getting feedback from you. The issues tab in github is open for all of you to share your ideas and thoughts. You can also follow me on Twitter [@hardkoded](https://twitter.com/hardkoded).

Don't stop coding!
