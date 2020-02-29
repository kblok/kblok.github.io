---
title: Puppeteer Sharp Monthly Report - February 2019
tags: puppeteer-sharp csharp
permalink: /blog/puppeteer-sharp-monthly-feb-2019
---
 
We didn't get a (Google's) Puppeteer release last month, but that doesn't mean that we didn't make good progress on Puppeteer-Sharp.

We were working a lot on tech debt. We tried to make our builds more reliable. Many builds tend to fail due to timeouts or race conditions, so we worked in many of them.
We also went through many [async recommendations](https://github.com/davidfowl/AspNetCoreDiagnosticScenarios/blob/master/AsyncGuidance.md) made by [David Fowler](https://twitter.com/davidfowl). If you didn't read that post, go check that out!

So after all this cleanup, we were able to ship two small releases: [v1.11.1](https://github.com/kblok/puppeteer-sharp/releases/tag/v1.11.1) and [v1.11.2](https://github.com/kblok/puppeteer-sharp/releases/tag/v1.11.2)

# What's next

Google did release Puppeteer v1.12 a few days ago. So we are working on this version right now.

Another issue that is driving me crazy is [UnobservedTaskExceptions](https://github.com/kblok/puppeteer-sharp/issues/891). Brian Feucht found out that tons of UnobservedTaskExceptions are being logged. Though there are not many user tracking that I think that's something we do need to work on.

# Activity 

* Repository Stars:  440 (prev. 383) +15%
* Repository Forks: 75 (prev. 67) +12%
* Nuget downloads:  41,418 (prev. 32,278) +28%

# Contributors

[Henk Mollema](https://github.com/henkmollema) pushed two PRs, fixing documentation and [DevTools](https://github.com/kblok/puppeteer-sharp/pull/831) property.

# Final Words

I’m looking forward to getting more feedback. Having real-world feedback helps us a lot. The issues tab in GitHub is open for all of you to share your ideas and thoughts. You can also follow me on Twitter [@hardkoded](https://twitter.com/hardkoded).

Don't stop coding!

#### Previous Reports
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