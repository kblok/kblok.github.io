---
title: How to start an OSS project
tags: general
permalink: /blogs/how-to-start-an-oss-project
---
An [OSS](https://opensource.com/resources/what-open-source) project is very different from a project you work on in your daily job. At first, It's like being in a fairy tale but, without discipline, your dream project can quickly become *[insert a boring movie reference here]*.

I started the [Puppeteer Sharp](https://github.com/hardkoded/puppeteer-sharp) project in October 2017, and although I'm still learning how to do this thing we call OSS, here’s what I’ve learned so far.

## Open up to the community

Sometimes our ego is our worst enemy. We don't want to look stupid. We don't want to show something half done, "What would people think?"

> "Sharing your idea with the community is the first step towards a successful OSS project."

I was surprised when I got the first "stars" on GitHub before having a single test running! Encouraged, I thought "There are some guys interested. Let's code up!". This exposure helps you keep moving. If you keep your project private and nobody knows about it, they won't know if you leave it incomplete. But, if you open it to the public, you might get a "Hey! I need this tool, when are you going to finish it?" and you will be pushed to move forward.

## Don't buy fake progress

I couldn't believe it when I found myself buying fake progress. "I've been working on projects my entire career!", I thought, How was that possible?

The problem is that it is easy to fall into the fake progress. Enterprise projects tend to begin with CRUD pages; Countries CRUD; Documents CRUD, etc. Things that distract us from the real, hard to solve problems, but seem like progress to the customer (and to ourselves).

The same happened to me. I started with small classes, such as Keyboard or Mouse. It felt good. I was pushing code! But after a month, I found I had over 50 classes implemented, but not a single green test. Pretty lame right?

So, I changed directions and put all my energy into getting my first test green.

> "You might have a thousand classes and a million lines of code, but if you don't have a green test, you are not shipping."

Do important things first. Don't buy fake progress.

## Clear roadmap

Roadmaps are mandatory for enterprise projects. Whether you use a roadmap, a project plan, milestones or something else, setting expectations is important. But when you start an OSS project, you do it (usually) for fun. You have one cool idea and want to carry it out. The last thing you want to do is project management!!

If you want to code for a few days and have some fun, go ahead, you don't need a plan. But, if you want to finish an OSS project, you will need a roadmap.

> "If you want to finish an OSS project, you will need a roadmap"

I'm sorry, I know it's boring, but you will need to spend a few [Pomodoros](https://en.wikipedia.org/wiki/Pomodoro_Technique) building a roadmap instead of writing code. The good thing, at least in my experience, is that you don't necessarily need to set dates. Although people would like to know when they will be able to use some feature, they also know you are doing it on your free time. Project followers shouldn't push you to implement a feature within a certain time (unless your project reaches the popularity of Newtonsoft JSON or ReactJS).

When I realized I needed a [Roadmap](https://www.hardkoded.com/blogs/puppeteer-sharp-monthly-february-2018) for Puppeteer Sharp, I put every feature I knew the library should have into different shippable versions. I didn't mention when I was going to implement those features, but instead, how I would prioritize them. And that not only helped the guys interested in the project, but also helped me to code in order.

## Your tests are your lighthouse

Unit tests are a fundamental tool in an OSS project. It helps you measure code quality and explain how your code works. But it's also a great way to see (and show) your progress.

When I found myself buying fake progress, it was because I didn't have any tests. Don't judge me. Having a single test running in Puppeteer Sharp required lots of lines of code. But, I didn't have a single test. I was lost. I didn't have a lighthouse.

**WARNING**
If you have hundreds of tests and none of them are testing an important feature, you might be buying fake progress.

I'm not saying that small unit tests are not important. But, it's important to have tests showing the features you included in your roadmap. It's only when you have green tests for features, that you are making progress.

## I know I will finish the project

How do I know I will finish this project?
Because I committed to giving this project at least one [Pomodoro](https://en.wikipedia.org/wiki/Pomodoro_Technique) a day. John Resig has a [great post](https://johnresig.com/blog/write-code-every-day/) on this topic.

> But, is 25 minutes a day enough?

Of course, it won't be as good as spending 8 hours a day, or 20 hours in a weekend. But, this steady, disciplined progress will help me carry out this project without overlooking my daily job, my family and my health.

Don't stop coding!

