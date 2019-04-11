---
title: Puppeteer Sharp Monthly Report - March 2019
tags: puppeteer-sharp csharp
permalink: /blog/puppeteer-sharp-monthly-mar-2019
---

We were able to ship [v1.12](https://github.com/kblok/puppeteer-sharp/releases/tag/v1.12) in February, ok it was in March, but let me count this as February :p

Puppeteer v1.12 included quite an interesting refactor, introducing [Worlds](https://chromium.googlesource.com/chromium/src.git/+/62.0.3178.1/third_party/WebKit/Source/bindings/core/v8/V8BindingDesign.md#world). This took us some time to adapt our code to that new implementation.

# What's next

I bet Puppeteer v1.13 is around the corner, as they ship as soon as I write these reports :p

I wasn't able to work on  this during February:
>Another issue that is driving me crazy is [UnobservedTaskExceptions](https://github.com/kblok/puppeteer-sharp/issues/891). Brian Feucht found out that tons of UnobservedTaskExceptions are being logged. Though there are not many user tracking that I think that's something we do need to work on.

I hope I can work on that this month.

# Activity 

* Repository Stars:  470 (prev. 440) +7%
* Repository Forks:  79 (prev. 75) +5%
* Nuget downloads:  49,710 (prev. 41,418) +20%

# Contributors

* [Meir Blachman](https://www.twitter.com/MeirBlachman) worked a lot on v1.12, pushing   8 PRs.

* [rgelb](https://github.com/rgelb) improved [defaults in screenshots](https://github.com/kblok/puppeteer-sharp/commit/9b1a597d57ff1c20d2ccb850dc1451a8a23727b4).

 * [Stuart Blackler](https://github.com/Im5tu)  pushed 2 PRs, improving [ cancellation tokens](https://github.com/kblok/puppeteer-sharp/commit/7a1de994ccd6325122020c7af95d1898b71e359d) and fixing some [concurrency issues](https://github.com/kblok/puppeteer-sharp/commit/3e082897697dcf4e97f05d4c51e1c218c7f59cb4). 

 * [Vitalii Maklai](https://github.com/HarinezumiSama) implemented [mouse wheel support](https://github.com/kblok/puppeteer-sharp/commit/db2753d0c9875b764e040a04827a67bd58c84dec).

 * [Gerke Geurts](https://github.com/ggeurts) fixed a[ race condition in our WebSocket transport](https://github.com/kblok/puppeteer-sharp/commit/69798e443c97b0fd4041db73260fff4b35a14390)

# Final Words

We've got 6 contributors in February! I can't believe that. You are welcome to step in the project or continue working on it ;). There are many ideas I want to work on. This project needs more hands.

I’m looking forward to getting more feedback. Having real-world feedback helps us a lot. The issues tab in GitHub is open for all of you to share your ideas and thoughts. You can also follow me on Twitter [@hardkoded](https://twitter.com/hardkoded).

Don't stop coding!

#### Previous Reports
 * [February 2019](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-feb-2019)
 * [January 2019](https://www.hardkoded.com/blog/puppeteer-sharp-monthly-jan-2019)
 * [December 2018](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-dec-2018)
 * [November 2018](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-nov-2018)
 * [October 2018](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-oct-2018)
 * [September 2018](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-sep-2018)
 * [July 2018](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-jul-2018)
 * [June 2018](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-jun-2018)
 * [May 2018](http://www.hardkoded.com/blogs/puppeteer-sharp-monthly-may-2018)
 * [April 2018](http://www.hardkoded.com/blogs/puppeteer-sharp-monthly-april-2018)
 * [March 2018](http://www.hardkoded.com/blogs/puppeteer-sharp-monthly-march-2018)