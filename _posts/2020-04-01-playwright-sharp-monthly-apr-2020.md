---
title: Playwright Sharp Monthly Report - April 2020
tags: playwright-sharp csharp
permalink: /blog/playwright-sharp-monthly-apr-2020
---

We are making significant progress on the project. We coded all the tests we need to get to v0.10.0. **A total of 820 tests!**

![wow](https://media2.giphy.com/media/l1J9FiGxR61OcF2mI/giphy.gif?cid=ecf05e47a14e7a08b24ce4bfe106ca95472c1f524b93aa03&rid=giphy.gif)

So now, we are focused on Chromium and Firefox. These are our numbers:

# Cool new stuff

Puppeteer-Sharp has two sets of methods to execute javascript code: [EvaluateExpressionAsync](https://www.puppeteersharp.com/api/PuppeteerSharp.Page.html#PuppeteerSharp_Page_EvaluateExpressionAsync_System_String_) and [EvalauteFunctionAsync](https://www.puppeteersharp.com/api/PuppeteerSharp.Page.html#PuppeteerSharp_Page_EvaluateFunctionAsync__1_System_String_System_Object___). This caused some confussions and errors in users, passing a function to the expression function or vice-versa.  
Playwright-Sharp is going to use consolidate both calls into an `EvaluateAsync` method and it will use [esprima-dotnet](https://github.com/sebastienros/esprima-dotnet) to determine if the string being passed in is a function or an expression.  
Big thanks to [Sébastien Ros](https://twitter.com/sebastienros) for that awesome project!

![thank you](https://media0.giphy.com/media/26gsjCZpPolPr3sBy/giphy.gif?cid=ecf05e474c70965b31b38781ca6ad546d2618da6b2f396e1&rid=giphy.gif)

# Progress

 * Playwright's tests: 985
 * Playwright Sharp's tests coded: 820
   * Passing on Chromium: 133
   * Passing on Webkit: 0
   * Passing on Firefox: 21
  
# Activity

 * Repository Stars: 34 (prev 22) +54%
 * Repository Forks: 5 (prev 3) +66%
 * Nuget downloads: 0
 * Contributors: 2

# Contributors

* [Meir Blachman](https://twitter.com/MeirBlachman) is doing most of the job on the Firefox project. So if you get to use Playwright-Sharp with Firefox, thank Meir!

# I need you

Maybe we don't have the time to jump in and put some hours on this project. That's ok. But if you are interested in this project, there are two things you can do:

**Star** the project. That's free, and it will give me an idea of the interest in this project.

**Financial support**. I'm doing this for free because I love this project, and I want to give back to the community. But financial funding it's an excellent way to honor my work if my projects are making your business possible. So if you are willing to support my projects, you can visit my [sponsors page](https://github.com/sponsors/hardkoded).

# Final words

I hope I can ship some version in April so you can download it and play a little bit.
Don't forget to follow me on Twitter [@hardkoded](https://twitter.com/hardkoded) to get more updates.

Don't stop coding!

#### Previous Reports
 * [March 2020](https://www.hardkoded.com/blog/playwright-sharp-monthly-march-2020)