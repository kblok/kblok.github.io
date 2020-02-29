---
title: Puppeteer Sharp Monthly Report - June 2018
tags: puppeteer-sharp csharp
permalink: /blog/puppeteer-sharp-monthly-jun-2018
---
 
And here we are in June, halfway through the year. And I'm so excited to announce that, in this past 30 days, we released not only [v0.7](https://github.com/kblok/puppeteer-sharp/releases/tag/v0.7) and [v0.8](https://github.com/kblok/puppeteer-sharp/releases/tag/v0.8) but also [V1](https://github.com/kblok/puppeteer-sharp/releases/tag/v1.0)!

It's impressive all we accomplished in only one month.

On [v0.7](https://www.hardkoded.com/blogs/puppeteer-sharp-v07-released) we completed the Page class implementing many selector methods.

Then, on [v0.8](https://github.com/kblok/puppeteer-sharp/releases/tag/v0.8), we implemented the same functionality but at the ElementHandle level.

Finally [V1](https://github.com/kblok/puppeteer-sharp/releases/tag/v0.8). The primary goals there were implementing CSS and JS coverage and completing missing tests we had left behind. We also finished all the documentation.

I’m also excited about two things that happened in May.
The project got to 100 stars on [GitHub](https://github.com/kblok/puppeteer-sharp). I’m thrilled about the support this project is getting.
Also, [Andrey Lushnikov](https://twitter.com/aslushnikov) created the Slack channel [#puppeteer-sharp](https://join.slack.com/t/puppeteer/shared_invite/enQtMzU4MjIyMDA5NTM4LTM1OTdkNDhlM2Y4ZGUzZDdjYjM5ZWZlZGFiZjc4MTkyYTVlYzIzYjU5NDIyNzgyMmFiNDFjN2UzNWU0N2ZhZDc) on their Puppeteer workspace. Come by and say hi!

## What do we mean with V1?

In these days where you have applications in an eternal 0.x version, and browsers reaching v30 after a few months, I think it’s important to bring back the meaning of version numbers on Puppeteer Sharp.

For Puppeteer Sharp, the version number means compatibility with her mother project [Pupppeteer](https://github.com/GoogleChrome/puppeteer), nothing more, nothing else.

So Puppeteer Sharp V1 means that it implements all (or most) the functionally, and tests, of Puppeteer. 

For the versions to come, the meaning will remain the same. Some features will come in a C# flavor, while others will add more functionality. Only a few of them, I hope we can count them with one hand, won’t be implemented due to differences in the language/framework.

>But, does it mean that it is fully functional and can be used in production?

YES, the library is fully functional, tested and ready to use.

## What's next

Puppeteer is now on v1.4, which means that we are 4 releases behind. So, the next step would be implementing and shipping v1.1 and we already have [a project]( https://github.com/kblok/puppeteer-sharp/projects/14) for that.

# Progress

* Google Puppeteer’s test: 441
* Puppeteer Sharp’s tests: 342 (prev. 121)

# Activity 

* Repository Stars: 105 (prev. 65) +61%
* Repository Forks: 17 (prev. 10) +70%
* Nuget downloads: 2293 (prev. 833) +75%
* Contributors: 2

# Contributors

[Meir Blachman](https://www.twitter.com/MeirBlachman) pushed 26 PRs out of 54 and reviewed all my PRs.

By the end of the month, and having this post almost finished :p, [kenny-evitt](https://github.com/kenny-evitt) found an issue in our AppVeyor badges and fixed. I'm glad when guys, like him, take the time to fork the project, make a change and create a Pull Request.

# Final Words

Now that we got to V1, let me get a little emotional and share a few thoughts. 

Coding is not for lone wolves. Yes, you can code alone and create incredible pieces of software, but software is a team sport.
It wouldn't be possible to get to V1 in June with this quality, if it wasn't for [Meir Blachman](https://www.twitter.com/MeirBlachman). He not only implemented new features, but also raised the bar and helped me to improve my coding.

It's also the perfect opportunity to thank Adrian Gonzalez and Facundo Giuliani. If you didn't notice that I write like a monkey, it's because they took the time to review and edit my posts. My writing skills improved (I think) a lot thanks to these guys.

And of course, I’m looking forward to getting more feedback. The issues tab in GitHub is open for all of you to share your ideas and thoughts. You can also follow me on Twitter [@hardkoded](https://twitter.com/hardkoded).

Don't stop coding!

#### Previous Reports
 * [May 2018](https://www.hardkoded.com/blogs/puppeteer-sharp-monthly-may-2018)
 * [April 2018](https://www.hardkoded.com/blogs/puppeteer-sharp-monthly-april-2018)
 * [March 2018](https://www.hardkoded.com/blogs/puppeteer-sharp-monthly-march-2018)


