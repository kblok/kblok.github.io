---
title: Async in C# 5.0 book review
tags: csharp books
permalink: /blog/async-csharp-5-book-review
---

[Async in C# 5.0 by Alex Davies](https://www.amazon.com/Async-5-0-Unleash-Power/dp/1449337163) was the second book [in the list](https://www.hardkoded.com/blog/going-deeper-async). It was a recommended reading on the [Concurrency in C# Cookbook](https://www.hardkoded.com/blog/concurrency-cookbook-review), so I knew it was going to be a good one.

Now that I read both books, I would recommend Async in C# 5.0 as the first book in your list, not because it's better, but because it covers the foundations of async programming so then you can go to the cookbook.

# What can we learn from this book?

>Asynchronous code is contagious.

This statement is so simple, but I love it. Asynchronous code is contagious. It's simple, but it's essential. When you use an async method, don't try to make it synchronous, don't try to `Wait` it, don't try to just `.Result` it. You have to let that method spread the async through all your code.

There are no excuses not to make your code async. Controllers can return a Task<IActionResult> in ASP.NET MVC. You can enable [async](https://bit.ly/2v3FHrz) in ASP.NET Full Framework pages.  Even in console apps, You can make your main method async with [C# 7.1](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-7-1#async-main).


## Await under the hood

This book has a great explanation of what the compiler does when it sees an await.

>The interesting bit is the await keyword. When the compiler sees this, it chops the method up.

And

>The only effect that the async keyword has is on the compilation of the method to which it is applied.

## SyncronizationContext

We get another important concept in Chapter 8

>This is one of the most common misconceptions about async. Async never schedules your method to run on a background thread. The only way to do that is using something like Task.Run, which is explicitly for that purpose.

I recommend you to read chapter 8.

>When you await a Task, the current SynchronizationContext is stored as part of pausing the method. Then, when it’s time for the method to be resumed, the await keyword’s infrastructure uses Post to resume the method on the captured SynchronizationContext.

![Mind blown](https://media2.giphy.com/media/3o8dFn5CXJlCV9ZEsg/giphy.gif?cid=790b76115caf296f7466586a77225c66)

And it finally has a great explanation of why, and when, we need to use `ConfigureAwait`

>When the SynchronizationContext is different, however, an expensive Post is needed. In performance-critical code, or in library code where you don’t care which thread you use, you might choose not to pay that performance penalty. That’s done by calling ConfigureAwait on the Task before awaiting it. If you do that, it won’t Post back to the original SynchronizationContext when resuming.

And

>ConfigureAwait doesn’t always do as you might expect, though. It’s designed to be a hint to .NET that you don’t mind which thread your method resumes on, rather than a strict instruction.

## What's wrong with async void?

Alex has an astonishing explanation of the `async void` problem:

>Async methods that return void can’t be awaited, so their behavior around exceptions must be different. We wouldn’t always want their exceptions to be unobserved. Instead, any exceptions that leave an async void method are rethrown in the calling thread: 
 * If there was a SynchronizationContext when the async method was called, the exception is Posted to it. 
 * If not, it is thrown on the thread pool.
**In most cases, both of these will end the process unless an unhandled exception handler is attached to the appropriate event**. That’s probably not what you want, which is one reason you should only write an async void method for the purpose of being called by external code, or when you can guarantee that it won’t throw exceptions.

*In most cases, both of these will end the process unless an unhandled exception handler is attached to the appropriate event*

## Async in ASP.NET Framework

I learned a lot from chapter 12.

>ASP.NET uses a special SynchronizationContext that keeps track of asynchronous operations and only moves on when they are all completed. Take care when running asynchronous code in the ASP.NET SynchronizationContext, because it is single-threaded.


## Writing async methods

I find this super important:

>An async method isn’t automatically asynchronous. Async methods just make it easier to consume other asynchronous methods. They start running synchronously, until they call an asynchronous method and await it. When they do so, they necessarily become asynchronous themselves. Sometimes, an async method never awaits anything, in which case it runs synchronously.

I wrote a [tiny app](https://github.com/kblok/async-programming-talk) to prove this:

```cs
public static async Task Main(string[] args)
{

    var positiveTask = GetPositiveNumbersAsync();
    var negativeTask = GetNegativeNumbersAsync();

    await Task.WhenAll(positiveTask, negativeTask);

    Console.ReadKey();
}

private static async Task GetPositiveNumbersAsync()
{
    for (var i = 1; i <= 21; i++)
    {
        Console.WriteLine(i);
        if (i % 3 == 0)
        {
            await Console.Out.WriteLineAsync($"Waiting for {i}");
        }
    }
}

private static async Task GetNegativeNumbersAsync()
{
    for (var i = -1; i >= -21; i--)
    {
        Console.WriteLine(i);
        if (i % 3 == 0)
        {
            await Console.Out.WriteLineAsync($"Waiting for {i}");
        }
    }
}
```

You might think you would get just a bunch of mixed positive and negative numbers. But instead, we get this:

```
1
2
3
Waiting for 3
4
5
6
Waiting for 6
7
8
9
Waiting for 9
10
11
12
Waiting for 12
13
14
15
Waiting for 15
16
17
18
Waiting for 18
19
20
21
Waiting for 21
-1
-2
-3
Waiting for -3
-4
-5
-6
Waiting for -6
-7
-8
-9
Waiting for -9
-10
-11
-12
Waiting for -12
-13
-14
-15
Waiting for -15
-16
-17
-18
Waiting for -18
-19
-20
-21
Waiting for -21
```

### Why is that?

It turns out that `Console.Out.WriteLineAsync` returns a completed Task, so all this code will run synchronously, interesting right?

What if we change `Console.Out.WriteLineAsync` for a method that returns an incomplete Task. Let's say something like this:

```cs
private static async Task LongAsync(int number)
{
    await Task.Delay(100);
    await Console.Out.WriteLineAsync($"Waiting for {number}");
}
```

Now we get something like this:

```
1
2
3
-1
-2
-3
Waiting for -3
-4
-5
-6
Waiting for 3
4
5
6
Waiting for -6
-7
-8
-9
Waiting for 6
7
8
9
Waiting for -9
-10
-11
-12
Waiting for 9
10
11
12
Waiting for -12
-13
-14
-15
Waiting for 12
13
14
15
Waiting for -15
-16
-17
-18
Waiting for 15
16
17
18
Waiting for -18
-19
-20
-21
Waiting for 18
19
20
21
Waiting for -21
Waiting for 21
```

What is important is that `GetPositiveNumbersAsync` will run synchronously until it gets to the first incomplete Task.

# Final words

I think this book is a must read if you are writing modern C# apps.
See you on the next book and:

Don't stop coding!