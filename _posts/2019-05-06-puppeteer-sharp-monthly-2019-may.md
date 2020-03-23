---
title: Puppeteer Sharp Monthly Report - May 2019
tags: puppeteer-sharp csharp
permalink: /blog/puppeteer-sharp-monthly-may-2019
---

We shipped [v1.14](https://github.com/hardkoded/puppeteer-sharp/releases/tag/v1.14) and a tiny [v1.14.1](https://github.com/hardkoded/puppeteer-sharp/releases/tag/v1.14.1) in the past month. As the main work in Puppeteer is around Firefox, there were no significant changes in these versions.  
**But**, Linux users will be glad to know that we drop Mono as a dependency. We used a Mono dll just to fix Chromium permissions, and now we are doing that using only `libc`.

# Firefox is coming.

[Meir Blachman](https://www.twitter.com/MeirBlachman) has made [some progress](https://github.com/hardkoded/puppeteer-sharp/pull/1073) on the abstraction layer we need to support Firefox. I hope we keep moving that way in May.

# What's next

We are almost done with [v1.15](https://github.com/hardkoded/puppeteer-sharp/projects/33). I hope we can publish it early this month.

I wasn't able to work on this during ~~March~~April. I hope I can work on that this month.
>I wasn't able to work on  this during February:
>Another issue that is driving me crazy is [UnobservedTaskExceptions](https://github.com/hardkoded/puppeteer-sharp/issues/891). Brian Feucht found out that tons of UnobservedTaskExceptions are being logged. Though there are not many user tracking that I think that's something we do need to work on.

# Activity 

* Repository Stars:  625 (prev. 573) +9% 
* Repository Forks:  99 (prev. 90) +10%  
* Nuget downloads: 80,176 (prev. 62,703) +28%

# Contributors

* [Aaron Adrian](https://github.com/aaroncadrian) refactored PaperFormat so you can create your own formats.

* [Aurimas Laureckis](https://github.com/Aurimas1) changed the Headers dictionary so is case sensitive now.

* [Meir Blachman](https://www.twitter.com/MeirBlachman) is working on the abstractions needed for Firefox and also implemented many features for v1.15.

# Final Words

As I mentioned before, the more hands we have in this project, the easier for us to help you out with issues and improvements.

I'm looking forward to getting more feedback. Having real-world feedback helps us a lot. The issues tab in GitHub is open for all of you to share your ideas and thoughts. You can also follow me on Twitter [@hardkoded](https://twitter.com/hardkoded).

Don't stop coding!

#### Previous Reports
 * [April 2019](https://www.hardkoded.com/blog/puppeteer-sharp-monthly-apr-2019)
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