---
title: Puppeteer Sharp Monthly Report - November 2018
tags: puppeteer-sharp csharp
permalink: /blog/puppeteer-sharp-monthly-nov-2018
---
 
>Now that we (almost) catch Puppeteer, I wonder whether this monthly report will still be useful or not in the future. However, I think it’s an excellent place to thank the contributors who stepped in and also the users who join this community.

This is how I closed the [report](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-oct-2018) last month. It was a pleasant surprise to get this comment (I don't get many comments on my blog) a few days after I published th post.

![Tweet Comment](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/nov-2018-report/MarkComment.png)

So here we are, welcome to the November report. We shipped [v1.8](https://github.com/kblok/puppeteer-sharp/releases/tag/v1.8) and [v1.9](https://github.com/kblok/puppeteer-sharp/releases/tag/v1.9) during October. We shared the same version with [our mother project Puppeteer](https://github.com/googleChrome/puppeteer) for over a week. However, this morning (November 2nd), they released [v1.10](https://github.com/GoogleChrome/puppeteer/releases/tag/v1.10.0) with an awesome feature: [Accessibility](https://github.com/GoogleChrome/puppeteer/blob/v1.10.0/docs/api.md#class-accessibility). We have work to do!

One small milestone was introducing [burst mode screenshots](https://github.com/kblok/puppeteer-sharp/pull/705). I consider it a milestone because it's the first feature asked by the community and implemented in Puppeteer-Sharp before the mother project.

# What's next

[Bilal Durrani](https://github.com/bdurrani) stepped into the project during October. He suggested we needed more code examples. I said "Of course! Let's go for it.". So, during this month we are going to have, not only a samples project on our repo but also an examples section on the site. Did you know we have a [site](https://www.puppeteersharp.com/)?

![Tweet Comment](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/nov-2018-report/ExamplesSection.jpg)

We had a little debate there, whether we should have examples on the site, or in real runnable code. We are going to do both. I think Google will do a great job crawling our site and, at the same time, you will be able to download those samples from the repo and play with them. I'm super excited about this.

I hope we can also release v1.10. I have the feeling that Google's teams are releasing one version per month, so that's a good thing, because it give us some time for housekeeping.

We are also working hard with a few users on heavy usage scenarios. We will have some good improvements in performance and stability in the next release.

# Progress
This will be the last time I publish a tests comparison between these two projects. I will do a final review to see if we have some missing tests on our side. They have some Node related tests, and we have some .NET related tests, and it doesn't worth the effort to keep comparing these 2 numbers.

* Google Puppeteer’s test: 493
* Puppeteer Sharp’s tests: 499 (prev. 482)

# Activity 

* Repository Stars: 300 (prev. 255) +17%
* Repository Forks: 56 (prev. 45) +24%
* Nuget downloads: 20822 (prev. 15981) +30%

# Contributors

[Meir Blachman](https://www.twitter.com/MeirBlachman) pushed 3 PRs did a great job reviewing all our pull request and also giving support to our users.

[Bilal Durrani](https://github.com/bdurrani) pushed 4 PRs and, as mentioned before, he is starting to write code samples.

[Tommy Monk](https://github.com/tommymonk) did a great job [removing the use of dynamics](https://github.com/kblok/puppeteer-sharp/pull/652) and [improving concurrency](https://github.com/kblok/puppeteer-sharp/pull/715).

# Final Words

I’m looking forward to getting more feedback. The issues tab in GitHub is open for all of you to share your ideas and thoughts. You can also follow me on Twitter [@hardkoded](https://twitter.com/hardkoded).

Never stop coding!

#### Previous Reports
 * [October 2018](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-oct-2018)
 * [September 2018](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-sep-2018)
 * [July 2018](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-jul-2018)
 * [June 2018](http://www.hardkoded.com/blog/puppeteer-sharp-monthly-jun-2018)
 * [May 2018](http://www.hardkoded.com/blogs/puppeteer-sharp-monthly-may-2018)
 * [April 2018](http://www.hardkoded.com/blogs/puppeteer-sharp-monthly-april-2018)
 * [March 2018](http://www.hardkoded.com/blogs/puppeteer-sharp-monthly-march-2018)