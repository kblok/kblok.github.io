---
title: Playwright Sharp Monthly Report - July 2020
tags: playwright-sharp csharp
permalink: /blog/playwright-sharp-monthly-jul-2020
---

As promised last month, We shipped PlaywrightSharp.Firefox v0.10! You can read more about this version on [my previous post](https://www.hardkoded.com/blog/playwright-sharp-firefox-010).

## Playwright-Sharp as a Playwright client?

We are working with the Playwright team on a Playwright RPC Server.

![what?](https://media3.giphy.com/media/tu54GM19sqJOw/giphy.gif?cid=ecf05e474bb123a4008217cce4e23050f901bff9caa27a8e&rid=giphy.gif)

This Playwright server would package a (Node.JS) playwright instance, exposing its functionality through pipes. [Remember I talked about pipes?](https://www.hardkoded.com/blog/interprocess-communication) 

If we land with this idea (this is still a proof of concept), we will be able to speed up  Playwright-Sharp development, allowing us to work on [many other things I have dreamed for this library](https://github.com/hardkoded/playwright-sharp/projects/4). I want Playwright-Sharp to be not only a cool library, but the best automation suite for .NET developers. 

I'm sharing with you this internals because that's the purpose of these reports. But Playwright-Sharp wouldn't feel like just a client. It will be a first-class citizen, and you will be able to use it in the same way you'd use playwright.

So maybe, and this a huge maybe, we would be able to ship a V1 in the next 40 days.

# Activity

 * Repository Stars: 117 (prev 94) +24%
 * Repository Forks: 8 (prev 7) +14%
 * Nuget downloads: 274
 * Contributors: 1

# Contributors

* [Meir Blachman](https://twitter.com/MeirBlachman) is doing most of the job on the Firefox project, so if you get to use Playwright-Sharp with Firefox, thanks Meir!
 
# Final words

Now that we shipped our first versions, I'm looking forward to getting more feedback. The issues tab in GitHub is open for all of you to share your ideas and thoughts.  
Don't forget to follow me on Twitter [@hardkoded](https://twitter.com/hardkoded) to get more updates.

Don't stop coding!

#### Previous Reports
 * [Jun 2020](https://www.hardkoded.com/blog/playwright-sharp-monthly-jun-2020)
 * [May 2020](https://www.hardkoded.com/blog/playwright-sharp-monthly-may-2020)
 * [April 2020](https://www.hardkoded.com/blog/playwright-sharp-monthly-apr-2020)
 * [March 2020](https://www.hardkoded.com/blog/playwright-sharp-monthly-march-2020)
