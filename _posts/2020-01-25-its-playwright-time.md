---
title: It's Playwright time!
tags: playwright
permalink: /blog/its-playwright-time
---

If you are a puppeteer/puppeteer-sharp user, I bet you might be as excited as I am with the new [Playwright](https://github.com/microsoft/playwright) project. Playwright will take browser automation to the next level.

> Playwright is focused on enabling cross-browser web automation platform that is ever-green, capable, reliable and fast. Our primary goal with Playwright is to improve automated UI testing by eliminating flakiness, improving the speed of execution and offering insights into the browser operation.

They have a [great team](https://github.com/microsoft/playwright/graphs/contributors) (if there is a greater word than great, then that word), and I'm looking forward to seeing what they are going to build.

Now, let's go to the important part of the post. Are we going to have a `PlaywrightSharp` version of this project?

![yes](https://media2.giphy.com/media/10Jpr9KSaXLchW/giphy.gif?cid=790b7611f42ab6c5c6cf35c80cf2a14aff294637a1a6ef38&rid=giphy.gif)

Yes, we are going to build a .NET port of Playwright (I just added this sentence for SEO purposes).

We already have the most important things:

 * A repo [https://github.com/kblok/playwright-sharp](https://github.com/kblok/playwright-sharp)
 * A NuGet package [https://www.nuget.org/packages/PlaywrightSharp/](https://github.com/kblok/playwright-sharp). Although we are going to have many packages (an abstraction package, and one package per browser).
 * A domain [http://www.playwrightsharp.com/](http://www.playwrightsharp.com/) (don't even bother to click on the link yet)
 * And a project! [https://github.com/kblok/playwright-sharp/projects/1](https://github.com/kblok/playwright-sharp/projects/1)

# Core Guidelines

As we did with Puppeteer-Sharp, the primary goal is to create an API as close as possible to Playwright. A developer should be able to switch easily to Playwright Sharp and vice-versa.

Keeping in mind that primary goal, Playwright Sharp should have a .NET/C# flavor. A developer should be able to inject its objects using dependency injection, getter functions should be expressed as properties, Async suffix should be honored, etc.

We won't (technically speaking) respect [semver](https://semver.org/). We will always try to match Playwright's versions, so you will know that e.g., PlaywrightSharp 1.5, will have the same features as Playwright 1.5.

# The architecture

Although this is not defined yet, Playwright sharp will look something like this:

 * **PlaywrightSharp.Abstractions**, with interfaces and base classes.
 * **PlaywrightSharp._#BrowserEngine#_**. We will have browser-specific packages, e.g., PlaywrightSharp.Chromium

# The plan

Chasing an active project is quite a challenge. You are always one step behind. But, as we were able to catch Puppeteer, we will be able to catch Playwright.

We have our [first project](https://github.com/kblok/playwright-sharp/projects/1). 157 issues that will take us to the [first-snapshot](https://github.com/kblok/playwright/tree/first-snapshot) I created today (Jan 24th).

As [I learned in the past](http://www.hardkoded.com/blogs/how-to-start-an-oss-project), tests will be our lighthouse. They will be the first thing we are going to code (second, technically), and they will guide our implementation process.

# Final Words

I always talk about "the power of the star". That star on GitHub doesn't mean much for many people, but for OSS developers it's a pat on the back. So if you are interested in this project, a star [in the repo](https://github.com/kblok/playwright-sharp) will make me smile :)

Don't stop coding!
