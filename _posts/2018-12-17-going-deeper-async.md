---
title: Going deeper with async programming
tags: csharp books
permalink: /blog/going-deeper-async
---

When you start coding async apps in C# it looks super simple, almost magical. You put some asyncs here some awaits there, and you are done! 

![bob loves async](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/deeper-async/bob-loves-async.jpg)

But then, you start using asyncs more and more, and problems arise. As you don't know how this new technology works, you start adopting a set of rules, rules that you don't understand but you follow. You get this rules from StackOverflow (hopefully from the answers, not the questions!) or from blog posts. So you start building your version of the ten commandments:

![commandments](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/deeper-async/ten-commandments.jpg)

 * You shall use ConfigureAwait(false).
 * You shall not use "async void".
 * You shall not use .Result.
 * Use "GetAwaiter().Result" instead of "Result".
 * Return Task.
 * etc.


There nothing bad about having commandments to follow. But I got fed up with them. I wanted to have an explanation for each of those. Because if you want to master a technology you have to go deeper. So I decided to start reading more about async programming. Trying to get answers to questions like _"What the heck is that false on the ConfigureAwait call"_ or _"Why do I need to call GetAwaiter()?"_ Or even, _"What the heck is an awaiter?"_, _"SynchronizationContext truth or myth?"_, _"If a Task fails in the forest and no one is there, does it still make a sound?"_... well maybe not that one.

So I added three books to my To-Read list:
 * [Concurrency in C# Cookbook, Stephen Cleary](https://www.amazon.com/gp/product/B00KCY2CB4). [Go to the review](https://www.hardkoded.com/blog/concurrency-cookbook-review)
 * [Async in C# 5.0, Alex Davies](https://www.amazon.com/gp/product/B0099BJ4DU)
 * [Pro Asynchronous Programming with .NET](https://www.amazon.com/gp/product/B00I01FWGS)

I hope I can post one review and lessons learned from each book in the weeks to come. That being said, join me in this asynchronous journey.

Don’t stop coding!
