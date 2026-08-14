---
title: The state of unit testing in the AI era
tags: general ai
permalink: /blog/the-state-of-unit-testing-in-the-ai-era
---

The title of this post looks like deep research of unit testing and AI, but it's more a set of random thoughts.

Unit testing used to be an important part of our code review. That was the first thing I would look at on a PR. Tests were supposed to show the reviewer how the code works, and then you would go to the implementation.

Remember TDD?

We also fought for test coverage. "Hey, this line doesn't have coverage?"

Now we take unit tests and test coverage for granted. The AI will make sure there is a unit test for every single line of code.

And the main problem is that those tests are what I call self-reinforcement tests. The AI validates what the AI did, not what the AI was supposed to do.

And it creates lots of tests. LOTS.

I was talking with a colleague about this a few days ago and I found something pretty sad. We ended up just marking the test files as "viewed" in GitHub.

What used to be the entry point for reviewing is now noise.

I created some skills and rules to fight that. The one that stuck: split the tests.

Spec tests describe what a feature does. A handful per file. They read like documentation. Those are the ones you open first on a PR.

Unit tests pin down individual functions and edge cases. As many as you need. They can live in a different file so they don't bury the story.

Same runner, same CI. The split is for humans.

It helps. A bit. You can find the tests that still mean something.

But it looks like we need to make an effort to go back and give unit tests the place they deserve.

Or is it that we don't need them anymore?

But there are two things I will never skip. E2E tests for the UI. And it might sound old-fashioned, but I will ALWAYS do a manual test on user-facing features.

# Final words

I don't have a clean answer. I know I don't want to mark 40 test files as viewed and call it a review. If the tests don't tell me what the code is supposed to do, they're just the AI talking to itself.

Don't stop coding!
