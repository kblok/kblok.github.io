---
title: Concurrency in C# Cookbook Book Review 
tags: csharp books
permalink: /blog/concurrency-cookbook-review
cross-site-link: https://www.hardkoded.com/es/blog/concurrency-cookbook-review
---

[Concurrency in C# Cookbook](https://www.amazon.com/gp/product/B00KCY2CB4) by [Steve Cleary](https://twitter.com/aSteveCleary) is the first of a series of books [I planned to read to improve my async programming skills](https://www.hardkoded.com/blog/going-deeper-async).


In case you don’t know Steve Cleary, he’s an async rock star. His blog has great [async posts](https://blog.stephencleary.com/2012/02/async-and-await.html), and his [reputation on StackOverflow](https://stackoverflow.com/users/263693/stephen-cleary) is impressive. If you’ve ever asked, or looked for, an async question on StackOverflow, chances are that you read one of his answers.

With such a reputation, I knew that [Concurrency in C# Cookbook](https://www.amazon.com/gp/product/B00KCY2CB4) was going to be my first book.  
The book is a typical tech cookbook, where each chapter introduces one concept and it’s followed by a list of recipes.

The book covers three main topics: 
 * Async/Parallel programming
 * DataFlows
 * Rx (System.Reactive)

Although I was interested only in the Async programming section, learning about DataFlows and Rx was pretty cool.

# Async programming vs Parallel processing

I loved how in the first chapter, he talks about simple, yet important concepts. He explains what Multithreading, Parallel Processing, Async Programming, and Reactive programming are. This is important because one trap developers fall into (I was there), is thinking that we are doing parallel processing when we are doing async programming. That's because .NET uses the same object, The `Task` to represent both.

>One common error is thinking that we are doing parallel processing when we are doing async programming.

He reminds us that:

>Asynchronous Programming is a form of concurrency that uses Futures or Callbacks to avoid unnecessary threads.

Another interesting concept in chapter one is that async programming is not about speed but responsiveness and scalability.

>Async programming is not about speed but responsiveness and scalability.

# Introduction to Async programming

There are many concepts I kept from this chapter. The first, and most important one, is that methods are not async, the `Task` is. It's not the fact that the method has the async modifier that makes it async. It's the fact that it returns a Task (a promise) which makes it async.

>Methods are not async, the `Task` class is.

Another cool concept is that an Async call will run synchronously until it gets to the first await of a non-complete Task. I was able to prove this [on this little project](https://github.com/kblok/async-programming-talk/blob/master/AwaitDemo/Program.cs). So if you use `await Task.WhenAny`, you might think that all the tasks you pass to `WhenAny` will run in parallel. Well, they will not.

>Async call will run synchronously until it gets to the first await of a non-complete Task.

# Synchronization Context

Reading about synchronization context was one of my goals. Because that's something you don't see, but it's there. Your libraries might behave differently in different contexts if you are not aware of synchronization contexts.

>Your libraries might behave differently in different contexts if you are not aware of synchronization contexts.

I got a more in-depth explanation about synchronization contexts from another book (we’ll get there), so stay tuned. But Steve gives us a great tip:

>It’s good practice to always call ConfigureAwait in your core “library” methods, and only resume the context when you need it; in your outer “user interface” methods.

[One of the commandments](https://www.hardkoded.com/blog/going-deeper-async) was about using `GetAwaiter().GetResult()`. But, what is an awaiter? 
It turns out that the `await` keyword can await not only a task but any awaitable that follows a certain pattern. I found a cool explanation about the `await` keyword in another book (TODO: Dario insert link to new post).

There are many things we take for granted when using the async/await keywords. One of those is error handling.

>When an async method throws or propagates an exception,​ the exception is placed on its returned Task, and the Task is completed. When that Task is awaited, the await operator will retrieve that exception and (re)throw it in a way such that its original stack trace is preserved.


We will talk about how `await` works under-the-hood in the next post.

# Async Basics

I liked this section because it gave me some tips and things to consider when using the `System.Threading.Tasks` library.

About `Task.WhenAll`:

>If multiple tasks throw an exception, then all of those exceptions are placed on the Task returned by Task.WhenAll. However, when that task is awaited, only one of them will be thrown.

About `Task.WhenAny`:

>The task returned by Task.WhenAny never completes in a faulted or canceled state. It always results in the first Task to complete; if that task completed with an exception, then the exception is not propagated to the task returned by Task.WhenAny. For this reason, **you should usually await the task after it has completed**.

This is also a cool tip:

>When the first task completes, consider whether to cancel the remaining tasks.

# Homework

Then the book dives deep into DataFlow, Reactive waters. But I'll leave that for you to read.
So, perfect! I think we got some concepts about async programming. In the next post, we'll see what lessons we can learn from [Async in C# 5.0](https://www.amazon.com/Async-5-0-Unleash-Power/dp/1449337163).

Don't stop coding!