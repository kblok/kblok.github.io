---
title: Getting ready for Puppeteer-Sharp Firefox
tags: puppeteer-sharp csharp
permalink: /blog/getting-ready-for-puppeteer-sharp-firefox
---

You might not know, but Puppeteer's team is making [good progress](https://aslushnikov.github.io/ispuppeteerfirefoxready/) on a Puppeteer version for Firefox. That's a big deal. If we have trouble sometimes trying to get a site look the same in all browsers, imagine trying to use the same debugging protocol. They even had to [fork Firefox's debugging protocol](https://github.com/puppeteer/juggler) to make it "Puppeteer friendly".

# Implementation on Puppeteer

Architecturally wise, Firefox implementation in Puppeteer is quite simple (as it's supposed to be):
* They created an `experimental/puppeteer-firefox` folder.
* Replicated there all the classes they have in the main `lib` folder.
* Load the puppeteer library dynamically using `const puppeteer = require(puppeteerPath);`

And voilá! Duck typing does the rest.

# Implementation on Puppeteer-Sharp

Things won't be so easy in Puppeteer-Sharp. I'm not saying that it will be hard. But the challenge is how to include a layer of abstraction without breaking our users.

## Introducing Puppeteer-Sharp Abstractions

Puppeteer-Sharp Abstractions will be a set of interfaces, such as IBrowser, IPage, etc., as a layer of abstraction. So you can use the same code to run against Chromium and Firefox.

We might have some common classes here, but the final goal is having a set of interfaces.

## Abstractions in Puppeteer-Sharp

The idea is implementing in Puppeteer-Sharp all the interfaces we created in the Abstractions project. To avoid breaking the users' code, we'll do two things:

### 1. Implement explicit interfaces

We are going to [implement explicit interfaces](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/interfaces/explicit-interface-implementation?WT.mc_id=DT-MVP-5003814). This means that, for instance, the [Browser class](https://www.puppeteersharp.com/api/PuppeteerSharp.Browser.html) will have methods expecting and returning concrete classes, and methods expecting and returning interfaces.

So if you have an instance of a Browser class you will see a:

```cs
public async Task<Page[]> PagesAsync()
``` 

And if you have an instance of an IBrowser interface you will see a:

```cs
public async Task<IPage[]> PagesAsync()
``` 

### 2. Mark concrete methods as obsolete

Methods like `Task<Page[]> PagesAsync()` will be marked as obsolete. We will be keeping those methods for two versions, giving users some time to replace their concrete declarations with interfaces.

## Puppeteer-Sharp Firefox

I'm not saying that we are going to start with Firefox right now. I want to wait for Puppeteer's code to get more stable so we can begin moving their code to C#.
But implementing these interfaces now will lay the groundwork to start working on this great new package.

Don't stop coding!
