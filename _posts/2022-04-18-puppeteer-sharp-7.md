---
title: What's new in Puppeteer-Sharp - April 2022
tags: puppeteer-sharp csharp
permalink: /blog/whats-new-puppeteer-sharp-april-2022
---

I know, I know, I should be writing these posts more frequently, but I'm having so much fun at [my new gig](https://www.mabl.com/join-the-team), and it's not easy to keep up the pace.  
It's hard to believe it's been a year! since my last blog post, but here we are in Puppeteer-Sharp 7!  
Let me walk you through all the new features released since my [last blog post](http://www.hardkoded.com/blog/puppeteer-sharp-3-is-here).


## Chromium 100

The good news is that we now support Chrome/Chromium 100! But maybe not that good news is that Chromium 100 is now the minimum requirement due to many changes in how Chromium sends requests and responses data.

## Keeping the fox alive

We've been doing some work so you can use most puppeteer features with the latest Firefox version.

## Page.WaitForNetworkIdleAsync

You now can wait for the network idle at any time using [Page.WaitForNetworkIdleAsync](https://www.puppeteersharp.com/api/PuppeteerSharp.Page.html#PuppeteerSharp_Page_WaitForNetworkIdleAsync_PuppeteerSharp_WaitForNetworkIdleOptions_).

## Page.EmulateIdleStateAsync

You can not only wait for network idle but emulate this state!
For instance: 
```
await page.EmulateIdleStateAsync(new EmulateIdleOverrides() {IsUserActive = true, IsScreenUnlocked = false});
```

## Drag and Drop support

Emulating drag and drop was quite hard to accomplish in the past. Now you have an API for that!

```
await Page.SetDragInterceptionAsync(true);
var draggable = await Page.QuerySelectorAsync("#drag");
var dropzone = await Page.QuerySelectorAsync("#drop");
await draggable.DragAndDropAsync(dropzone);
```

## Page.EmulateVisionDeficiencyAsync

Now you can emulate different vision deficiencies using [Page.EmulateVisionDeficiencyAsync](https://www.puppeteersharp.com/api/PuppeteerSharp.Page.html#PuppeteerSharp_Page_EmulateVisionDeficiencyAsync_PuppeteerSharp_VisionDeficiency_).

## Page.EmulateCPUThrottlingAsync

You can also emulate CPU throttling with [Page.EmulateCPUThrottlingAsync](https://www.puppeteersharp.com/api/PuppeteerSharp.Page.html#PuppeteerSharp_Page_EmulateCPUThrottlingAsync_System_Nullable_System_Decimal__)! 

```
await Page.EmulateCPUThrottlingAsync(100);
```

# It's our Puppeteer-Sharp!

Just a friendly reminder. Puppeteer-Sharp is an independent community project. It's not being backed nor supported but any big (or small) corp. It depends on your support and contributions!  
I want to thank [Alex Maitland](https://github.com/amaitland), [Fernando Bracamonte](https://github.com/jorbraken), [MantasVa](https://github.com/MantasVa), [thomaschanneladvisor](https://github.com/thomaschanneladvisor), [Venkatesh Prasad](https://github.com/venky8951), [Matěj Štágl](https://github.com/lofcz), [jpeirson](https://github.com/jpeirson), [Eric Mutta](https://github.com/ericmutta), [Chris-Dev-GH](https://github.com/Chris-Dev-GH), [Kabue Charles](https://github.com/McKabue), [Kevin Lee Garner](https://github.com/kgar), [Pierre Irrmann](https://github.com/pirrmann), [Arnaud Maichac](https://github.com/arnaudmaichac) and [brnbs](https://github.com/brnbs) for contributing to the project during this past year.

I hope you can get more of my posts soon :)

Don't stop coding!