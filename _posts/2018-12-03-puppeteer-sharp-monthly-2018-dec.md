---
title: Puppeteer Sharp Monthly Report - December 2018
tags: puppeteer-sharp csharp
permalink: /blog/puppeteer-sharp-monthly-dec-2018
---
 
Last report of 2018! No, I won't get emotional. Let's go to the facts _(cries a little bit thinking about December)_.

We launched [v1.10](https://github.com/kblok/puppeteer-sharp/releases/tag/v1.10) during November. Every time I say "and we caught Puppeteer" they release a new version at the very next day, so I won't say that. But November wasn't only about v1.10.

## Examples Section

As I mentioned in our [previous report](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-nov-2018), [Bilal Durrani](https://github.com/bdurrani) stepped into the project and helped us build an [Examples section](http://www.puppeteersharp.com/examples/index.html).

![yeah](https://media.giphy.com/media/RrVzUOXldFe8M/giphy.gif)

This is the first step, but I hope this section to grow a lot in the future.

## Concurrency improvement


[PR 720](https://github.com/kblok/puppeteer-sharp/pull/720) was quite hard to pull off. However, we managed to improve a lot our code, and now we have better concurrency support and error handling.

## CamelCase the world

When you read [PR 769](https://github.com/kblok/puppeteer-sharp/pull/769), you might think: "Why didn't you do that the very first time?". You know the way projects grow, you have to prioritize and try to move on. Now the code is way cleaner without all those `JsonProperty` attributes.

## Better ASP.NET Full Framework support

We launched `PuppeteerSharp.AspNetFramework` . This library provides a new [IConnectionTransport](https://github.com/kblok/puppeteer-sharp/blob/master/lib/PuppeteerSharp/Transport/IConnectionTransport.cs) called [AspNetWebSocketTransport](https://github.com/kblok/puppeteer-sharp/blob/master/lib/PuppeteerSharp.AspNetFramework/AspNetWebSocketTransport.cs), which uses [HostingEnvironment.QueueBackgroundWorkItem](https://docs.microsoft.com/en-us/dotnet/api/system.web.hosting.hostingenvironment.queuebackgroundworkitem?view=netframework-4.7.2) instead of `Task.Run`, which is something [we shouldn't use in ASP.NET](https://blog.stephencleary.com/2013/11/taskrun-etiquette-examples-dont-use.html). If you are launching PuppeteerSharp on ASP.NET Full Framework you should pass this connection transport to PuppeteerSharp:

```cs
using (var browser = await Puppeteer.LaunchAsync(new LaunchOptions()
            {
                Headless = true,
                Transport = new AspNetWebSocketTransport()
            }).ConfigureAwait(false)) 
```

# What's next

Puppeteer v1.11 was released a few days ago. We made good progress there. I hope we can ship it next week.  
There are some code debt that it would be great if we can make some progress: [Review ContinueWith usage](https://github.com/kblok/puppeteer-sharp/issues/771),  [use cancellation tokens](https://github.com/kblok/puppeteer-sharp/issues/709), among many others.

# Activity 

* Repository Stars:  340 (prev. 300) +13%
* Repository Forks: 61 (prev. 56) +8%
* Nuget downloads: 26856  (prev. 20822) +29%

# Contributors

[Bilal Durrani](https://github.com/bdurrani) pushed 5 PRs. He did a great job implementing `Browser.WaitForTargetAsyc`.

# Final Words

I’m looking forward to getting more feedback. Having real-world feedback helps us a lot. The issues tab in GitHub is open for all of you to share your ideas and thoughts. You can also follow me on Twitter @hardkoded.

Never stop coding!

#### Previous Reports
 * [November 2018](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-nov-2018)
 * [October 2018](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-oct-2018)
 * [September 2018](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-sep-2018)
 * [July 2018](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-jul-2018)
 * [June 2018](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-jun-2018)
 * [May 2018](http://www.hardkoded.com/blogs/puppeteer-sharp-monthly-may-2018)
 * [April 2018](http://www.hardkoded.com/blogs/puppeteer-sharp-monthly-april-2018)
 * [March 2018](http://www.hardkoded.com/blogs/puppeteer-sharp-monthly-march-2018)