---
title: Puppeteer Sharp Monthly Report - April 2019
tags: puppeteer-sharp csharp
permalink: /blog/puppeteer-sharp-monthly-apr-2019
---

We shipped [v1.13](https://github.com/kblok/puppeteer-sharp/releases/tag/v1.13) in March. I must confess it wasn't the funniest thing to work on. It was mostly about getting many tests ready for Firefox.

# Firefox is coming.

As I mentioned in a [previous post](https://www.hardkoded.com/blog/getting-ready-for-puppeteer-sharp-firefox), we are going to start working on Firefox sooner or later. That would depend on how long it takes me to keep up with Puppeteer every month and how many extra hands I can get on the project to help me out. 

# What's next

I just created the [project for v1.14](https://github.com/kblok/puppeteer-sharp/projects/31). It seems it's a small one. So it would help me catch up with some open issues.

I wasn't able to work on this during March, and I feel terrible, well not that terrible. However, it's something I really want to work on, but v1.13 took me the entire month.
>I wasn't able to work on  this during February:
>Another issue that is driving me crazy is [UnobservedTaskExceptions](https://github.com/kblok/puppeteer-sharp/issues/891). Brian Feucht found out that tons of UnobservedTaskExceptions are being logged. Though there are not many user tracking that I think that's something we do need to work on.

## How about Firefox?  
I would love to work on the Firefox implementation, but that's my third priority.

1. Keep pace with Puppeteer.
2. Work on open issues.
3. Firefox

So we are working on new features before fixing bugs? [What would Joel say?](https://www.joelonsoftware.com/2000/08/09/the-joel-test-12-steps-to-better-code/)

Yes and No. I try to answer every issue as soon as possible. However, as this project is a carrot and stick, if we don't keep pace with Puppeteer, this can become a snowball. So we need to keep a balance there.

It also means that, if you find a bug, I encourage you to help me out as much as you can, and if you are not able to fix your bug, help me with another issue, so you will give me some extra time to work in yours.

# Activity 

* Repository Stars:  573 (prev. 470) +21% 
* Repository Forks:  90 (prev. 79) +20%  
* Nuget downloads: 62,703  (prev. 49,710) +26%

**20% UP!**

![BOOM](https://media1.giphy.com/media/dpnfPvaCIHBrW/giphy.gif?cid=790b76115ca1fefd35595131773a96ad)

# Contributors

* [Gerke Geurts](https://github.com/ggeurts) worked on some significant improvements on [ASP.NET Full Framework](https://github.com/kblok/puppeteer-sharp/commit/2e7961ccbfac0735120f796e06674d21166e5a2c), [Task Management](https://github.com/kblok/puppeteer-sharp/commit/44956cc88dc6e6c356e6fcc7b8c4dda071ae02b2), [target destruction reliability](https://github.com/kblok/puppeteer-sharp/commit/644c8e08b8bc0fb0ece0b986ec89e1fdd3563190) and [WebSockets](https://github.com/kblok/puppeteer-sharp/commit/8e61e2cdeb70b4911007ba021a9f0356521e75ad).

* [kkempster94](https://github.com/kkempster94) cought [one bad default we had in our timeout settins](https://github.com/kblok/puppeteer-sharp/commit/82640f6cac7e0f213de4291a6f4181221c87028e).

* [Meir Blachman](https://www.twitter.com/MeirBlachman) added [page.accessibility.snapshot tests](https://github.com/kblok/puppeteer-sharp/commit/23a64347ff936abd4b2388dfcaf64daac4242ca3).

* [Ismael Martin Alabarce](http://ismaeld.com/) found an [issue on our readme and fixed it](https://github.com/kblok/puppeteer-sharp/commit/8c071a04222ddd0abf90c112f1511b5623514c50).

* [Simon Le Bourdais-Cabana](https://github.com/scabana) did a great job [removing Mono dependency](https://github.com/kblok/puppeteer-sharp/commit/9a82a81f600f1e8f3b9431a4be4988ee9e840590). I hope this can help Linux users. 

# Final Words

I was super happy in [February](https://www.hardkoded.com/blog/puppeteer-sharp-monthly-mar-2019) when I found that we've got 6 contributors. So in March, we've got 5 contributors! that's awesome!
As I mentioned before, the more hands we have in this project, the easier for us to help you out with issues and improvements.

I’m looking forward to getting more feedback. Having real-world feedback helps us a lot. The issues tab in GitHub is open for all of you to share your ideas and thoughts. You can also follow me on Twitter [@hardkoded](https://twitter.com/hardkoded).

Don't stop coding!

#### Previous Reports
 * [March 2019](https://www.hardkoded.com/blog/puppeteer-sharp-monthly-mar-2019)
 * [February 2019](https://www.hardkoded.com/blog/puppeteer-sharp-monthly-feb-2019)
 * [January 2019](https://www.hardkoded.com/blog/puppeteer-sharp-monthly-jan-2019)
 * [December 2018](https://www.hardkoded.com/blog/puppeteer-sharp-monthly-dec-2018)
 * [November 2018](https://www.hardkoded.com/blog/puppeteer-sharp-monthly-nov-2018)
 * [October 2018](https://www.hardkoded.com/blog/puppeteer-sharp-monthly-oct-2018)
 * [September 2018](https://www.hardkoded.com/blog/puppeteer-sharp-monthly-sep-2018)
 * [July 2018](https://www.hardkoded.com/blog/puppeteer-sharp-monthly-jul-2018)
 * [June 2018](https://www.hardkoded.com/blog/puppeteer-sharp-monthly-jun-2018)
 * [May 2018](https://www.hardkoded.com/blogs/puppeteer-sharp-monthly-may-2018)
 * [April 2018](https://www.hardkoded.com/blogs/puppeteer-sharp-monthly-april-2018)
 * [March 2018](https://www.hardkoded.com/blogs/puppeteer-sharp-monthly-march-2018)