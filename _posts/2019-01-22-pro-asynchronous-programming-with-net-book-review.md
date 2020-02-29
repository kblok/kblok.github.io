---
title: Pro Asynchronous Programming with .NET - Book Review
tags: csharp books
permalink: /blog/pro-asynchronous-programming-with-net-book-review
---

[Pro Asynchronous Programming with .NET by Richard Blewett and  Andrew Clymer](https://www.amazon.com/Asynchronous-Programming-NET-Richard-Blewett/dp/1430259205/ref=sr_1_2?ie=UTF8&qid=1547464429&sr=8-2&keywords=pro+asynchronous+programming+with+.net) was the third book [on my list](https://www.hardkoded.com/blog/going-deeper-async).

# About the book

This book has some great explanations about the async internals in .NET. The problem I’ve found is that, maybe because it's a book from 2013, it puts lots of effort explaining how async worked before async/await. Which is nice if you like to read some history, but I wanted to go just to the main course.

# What can we learn from this book?

## Workers and I/O Threads

They have some good explanations about threads and I/O threads in chapter 2. It explains how most of the async task end up waiting for an I/O completion and how the OS solves that with completion ports.

>“Worker threads are targeted at work that is generally CPU based. If you perform I/O on these threads, it is really a waste of resources, as the thread will sit idle while the I/O is performed. A more efficient model would be to kick off the I/O (which is basically a hardware operation) and commit a thread only when the I/O is complete. This is the concept of I/O completion ports, and this is how the I/O threads in the thread pool work.”

## SynchronizationContext

Chapter 2 also give us some great explanations about the Synchronization Context. What is interesting about this section is that it explains how you should use a SynchronizationContext if you (are crazy and) want to use it manually by yourself. In other words, it’s explaining what the async/await is doing for you under the hood.

## Tasks

Chapter 3 is about Tasks. I didn't find there anything different from what [I read on the previous books](https://www.hardkoded.com/blog/going-deeper-async)

## Thread Safety

I loved this from Chapter 4:

>“Data is at the heart of every asynchrony bug”

## Concurrent data structures

Chapter 5 is about Concurrent data structures. This chapter is essential for you to read, because...

>“Data is at the heart of every asynchrony bug”

## Asynchronous UI

Chapter 6 is mind-blowing. It explains how background workers and synchronization contexts work together. Coding desktop apps maybe it's not so popular nowadays, but this chapter is important to understand how async works. Most of the complexity we find in the async architecture is due to UI applications.

## async and await

Chapter 7 is a must read. In this chapter, you will see what async and await actually do. You will learn that async and awaits are just syntax sugar to help the compiler build a state machine to solve all the Task chains we make when we write many awaits in the same method.

After reading this chapter, we'll understand why `await` works not only with `Task` but also with any awaitable class. As the compiler ends up writing a new method, it just needs some `Awaitable` class responding to an interface. Dixin has a [great post about async/await compilation](https://weblogs.asp.net/dixin/understanding-c-sharp-async-await-1-compilation), go check that out!

# Final words

I'll leave you homework. The following chapters are excellent. In chapter 9 you will learn what you should or shouldn't do while doing server-side async. You will also find exciting chapter 12, which talks about Task scheduling.

As I mentioned in my first post, doing await/async is easy, super simple. But it doesn't mean that the implementation of asyncs is a piece of cake. I encourage you to learn more not only about asynchronous programming but all the tools you use as a black box today.

Don't stop coding!