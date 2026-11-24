---
title: "Life is flaky"
tags: testing ai
permalink: /blog/life-is-flaky
hero: /img/life-is-flaky/hero.png
hero_dark: /img/life-is-flaky/hero-dark.png
image: /img/life-is-flaky/hero.png
---

[Joe Colantonio](https://www.linkedin.com/in/joecolantonio/) [asked me](https://www.linkedin.com/feed/update/urn:li:activity:7531039061004857344/) how I'd stop the noise from flaky tests without ignoring the real failures.

First, I'll try to remove the mabl tape and answer that from a developer's approach, but I was also working hard on this at mabl, so I'll be biased. You already know flaky tests are THE topic in software automation, and it would be naive to pretend I solved it in one post, so this is just what I've learned so far.

## Life is flaky

Notice that flaky tests got filed as pretty much an automation problem, and I'm not so sure that's the whole story.

[Andrey Lushnikov](https://www.linkedin.com/in/aslushnikov/) once told me the internet is flaky, and I would say life is flaky. The network is flaky, your computer is flaky under load, third-party services are flaky, and test automation is just the place where you are forced to look at that, over and over, in red.

## I tried to eradicate them

At the beginning of 2026 I had the idealistic goal of eradicating flaky tests (remember I said idealistic). You know what I learned? IT'S EXPENSIVE!

You can chase every race condition, every slow network call, every animation that ends a few milliseconds late, and you can win plenty of those battles, but there is no solution to eradicate flaky tests at scale. A fully agentic runtime won't scale yet either. Letting an agent drive every step and reason its way around every hiccup sounds great, but it doesn't scale today in cost or in speed, and I'm telling you this while I'm porting [e2e to .NET](https://www.hardkoded.com/e2e-dotnet/), so I'm not against agents at all, I just know where they are right now.

If I can't eradicate flakiness, the question from that post is the real one. How do you tell the noise from the failures that are real, and keep trusting the suite on the day it actually matters?

## Don't let the agent grade its own homework

More and more code is written by agents, and more and more tests too. If you create, edit, and execute the tests with the same agent that writes the code, you get a self-reinforcing problem, because the agent will try to make its life happy and it will end up writing stupid tests that just make the agent happy.

When a test fails, the easy path to green is a longer wait, one more retry, a weaker assertion, or a test that checks what the code does instead of what it should do. That hides the timing issue instead of fixing it, and the noise comes back later.

A flaky red teaches people to ignore failures, and a green the agent gave itself teaches people to trust passes they shouldn't, so either way nobody believes the suite. You already know the fix from code review: the author doesn't approve their own PR, and tests need the same thing, an independent agent, because having an unbiased agent is key.

## The app is not the spec

If you create an E2E test from the app the coding agent just built, even with an external agent, it will tend to assume the website is right, and whatever the app does today becomes the expected behavior. If a bug shipped with the feature, congratulations, the bug is now part of your test.

You need an external source of truth, knowledge of how the app should behave that doesn't come from the code and doesn't come from the test. Requirements, acceptance criteria, product knowledge, whatever form that takes, as long as it lives outside the thing being tested.

## Is it a bug or is it flakiness?

And why does that matter for the noise? Because if you have some kind of agentic fixing, auto-healing, auto-repair, whatever you call it, it needs to know what's true. The button moved, the label changed, the page got slower, and you want the agent to fix the test and move on, but it has to know what's a bug and what's flakiness, so it can heal the real noise and escalate the real bugs instead of healing both. A real bug quietly patched into a passing test is worse than a flaky red, because at least the red was telling you something.

So the answer to how you stop the noise without ignoring the failures that are real starts here. You can't separate them if nothing defines what correct means.

## Run less, see clearer

One more thing I really, really like is executing only the tests impacted by a change. At mabl we have [test impact analysis](https://help.mabl.com/hc/en-us/articles/53552823585044-How-test-impact-analysis-works) (I didn't build it, I wish I would). It doesn't make a test less flaky, but fewer irrelevant runs means fewer chances for noise, and a failure that does show up is more likely to be about the change you just made.

## Where I think this is going

This part is my personal opinion, not mabl's.

I can see a future where the deterministic red/green flag goes away, and an agent looks at a failure and says "yeah, this test failed, I saw the error, but we're good to go."

That sounds scary, and it should, if the agent is grading its own homework or has no idea how the app should behave. With an independent agent and an external source of truth, that judgment starts to look a lot like what a good tester does every day when they triage a red build.

## Final words

There is no silver bullet, and if someone tells you they have the final solution to flaky tests, don't believe them, me included.

If I had to say it in a few words, external agents and external knowledge will help humans and agents separate the noise from the bugs. That's how you stop paying the flaky-test tax without losing trust in the suite.

Don't stop coding!
