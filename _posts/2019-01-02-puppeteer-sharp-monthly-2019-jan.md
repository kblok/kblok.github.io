---
title: Puppeteer Sharp Monthly Report - January 2019
tags: puppeteer-sharp csharp
permalink: /blog/puppeteer-sharp-monthly-jan-2019
---
 
Happy new year Puppeteerers! (Is that even a word?)

We launched [v1.11](https://github.com/kblok/puppeteer-sharp/releases/tag/v1.11) during December.  The most important feature on v1.11 was _drum rolls_ LINUX SUPPORT!

![yeah](https://media0.giphy.com/media/l0COGE9TXQ5Z1Syis/giphy.gif?cid=3640f6095c2a03e9656a344c6babc230)

I want to thank [Dominic Böttger](https://twitter.com/dboettger) who setup our Linux CI and made some tweaks to make Puppeteer-Sharp work in Linux.

We also worked a lot on stability. Out CI builds were failing many times before getting green. So we evaluated every fail and made some improvements. Our builds are working way better than before. That also means that Puppeteer-Sharp is more stable and reliable.

# What's next

I bet Puppeteer v1.12 is around the corner so we will be working on that.
We have more housekeeping to do. I would love to start testing Puppeteer-Sharp on the cloud (e.g. Azure Functions) and also build some Docker images.

# Activity 

* Repository Stars:  383 (prev. 340) +12%
* Repository Forks: 67 (prev. 61) +9%
* Nuget downloads:  32278 (prev. 26856) +20%

# Contributors

[Bilal Durrani](https://github.com/bdurrani) pushed a How to reusing a Chrome instance document.

[Stuart Blackler](https://github.com/Im5tu) pushed 2 PRs. Improving even leaks and allocations.

[Meir Blachman](https://www.twitter.com/MeirBlachman) added support to `WaitUntil`  in `Page.SetContentAsync`.

As I mentioned before, [Dominic Böttger](https://twitter.com/dboettger) did a great job adding Linux support.

# Final Words

I’m looking forward to getting more feedback. Having real-world feedback helps us a lot. The issues tab in GitHub is open for all of you to share your ideas and thoughts. You can also follow me on Twitter [@hardkoded](https://twitter.com/hardkoded).

Don't stop coding!

#### Previous Reports
 * [December 2018](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-dec-2018)
 * [November 2018](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-nov-2018)
 * [October 2018](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-oct-2018)
 * [September 2018](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-sep-2018)
 * [July 2018](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-jul-2018)
 * [June 2018](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-jun-2018)
 * [May 2018](http://www.hardkoded.com/blogs/puppeteer-sharp-monthly-may-2018)
 * [April 2018](http://www.hardkoded.com/blogs/puppeteer-sharp-monthly-april-2018)
 * [March 2018](http://www.hardkoded.com/blogs/puppeteer-sharp-monthly-march-2018)