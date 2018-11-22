---
title: A fairy tale about async voids, events and error handling
tags: puppeteer-sharp csharp
permalink: /blog/async-void-fairy-tale
---
 
Let me tell you a story about async voids, SynchronizationContext, and async programming. A few days ago we got [an issue on Puppeteer-Sharp](https://github.com/kblok/puppeteer-sharp/issues/717) describing two problems:
 * Puppeteer-Sharp crashes with exceptions which cannot be caught.
 * KeyNotFoundException trying to get a [Frame](https://github.com/kblok/puppeteer-sharp/blob/master/lib/PuppeteerSharp/Frame.cs)
The code was pretty simple:

```cs
var launchOptions = new LaunchOptions() { Headless = true };
var sites = new List<string>()
{
    "somesites.com",
}
// Act
try
{
    await new BrowserFetcher().DownloadAsync(BrowserFetcher.DefaultRevision);
    using (var browser = await Puppeteer.LaunchAsync(launchOptions))
    {
        var page = await browser.NewPageAsync();

        foreach (var site in sites)
        {
            try
            {
                await page.GoToAsync($"http://{site}");
                Console.WriteLine(await page.GetTitleAsync());
                await page.ScreenshotAsync($"D:\\bin\\screenshots\\{site}.png");
            }
            catch (Exception exception)
            {
                // Catches most exceptions such as timeouts but does not catch others, see below.
                Console.WriteLine($"Unable to take screenshot of: {site}. Exception: {exception.Message}");
            }
        }
    }
}
catch (Exception exception)
{
    // Never enters the catch.
    Console.WriteLine($"Unable to proceed: {exception.Message}");
}
```

## How is it possible that a try-catch block can't catch an Exception?

Seriously, that's impossible. That's what try-catch blocks are for, right?
Well, [Ben Adams](https://twitter.com/ben_a_adams) gave me a hint [here](https://github.com/dotnet/roslyn/issues/13897#issuecomment-248098377)

![benadamscomment.png](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/async-void-fairy-tale/benadamscomment.png)

I think most of us have read this rule at least once:

>Avoid async void! It is possible to have an async method return void, but you should only do this if you’re writing an async event handler. A regular async method without a return value should return Task, not void.

_[Cleary, Stephen. Concurrency in C# Cookbook](https://www.amazon.com/dp/B00KCY2CB4)_

But many times I got in a situation where I needed to code an async void event. It looked like a perfect excuse: "I know that async void is bad. But I need to code an async Event handler, so I have to use async voids. I’m following the rules, everything will be ok".

Well… No.

>When an async void method propagates an exception, that exception is raised on ​​the SynchronizationContext that was active at the time the async void method started executing. If your execution environment provides a SynchronizationContext, then it usually has a way to handle these top-level exceptions at a global scope. For example, WPF has Application.DispatcherUnhandledException, WinRT has Application.UnhandledException and ASP.NET has Application_Error.

_[Cleary, Stephen. Concurrency in C# Cookbook](https://www.amazon.com/dp/B00KCY2CB4)_

But, as Ben said, in a console app, the exception will be propagated to the ThreadPool without being caught, taking down the entire process.

## Where are those async voids?
You might be thinking: "Ok, but why are you talking about async voids? that piece of code has no async void?"
Well, async voids event handlers are being used internally by Puppeteer. So, from `Puppeteer.LaunchAsync` to the `Dispose` being called by the using block, many events will be triggered internally.
When a new message comes from Chromium, an [IConnectionTransport](https://github.com/kblok/puppeteer-sharp/blob/master/lib/PuppeteerSharp/Transport/IConnectionTransport.cs) would parse and then broadcast it using the [MessageReceived event](https://github.com/kblok/puppeteer-sharp/blob/master/lib/PuppeteerSharp/Transport/IConnectionTransport.cs#L33).
Many classes, like the [Page](https://github.com/kblok/puppeteer-sharp/blob/master/lib/PuppeteerSharp/Page.cs#L1774) class, would listen to events coming from the connection and perform **asynchronous** tasks.
And here we have our **async voids**.

End of story.

No just kidding we didn't even find the bug yet.  

## Is async void the problem?

This past week I was obsessed with this async void issue. I considered replacing those events calls with other tools, such us [DataFlows](https://docs.microsoft.com/en-us/dotnet/standard/parallel-programming/dataflow-task-parallel-library) or [System.Reactive](https://github.com/dotnet/reactive), but I wasn't able to find a clean and (most important) right solution.

As I finished the [Concurrency C# cookbook](http://shop.oreilly.com/product/0636920030171.do) a few weeks I ago, I decided to take my chances and contact [Steve Cleary](https://twitter.com/aSteveCleary) on Twitter. He was super friendly and replied my tweet. To my surprise, in the middle of the conversation, he said:

![benadamscomment.png](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/async-void-fairy-tale/stevetweet.png)

And I was like

![What](https://media.giphy.com/media/91fEJqgdsnu4E/giphy.gif)

How is it possible that the man who knows most about asynchronous programming tells me that? Isn’t `async void` the root of all evil?

But that weird question helped me to understand that I wasn't getting what my problem was. Let’s take a look at what happens under the hood when we have a simple piece of code like this one:

```cs
try
{
    using (var browser = await Puppeteer.LaunchAsync(options))
    using (var page = await browser.NewPageAsync())
    {
            await Page.ClickAsync("body");
    }
}
catch(Exception ex)
{
    Console.WriteLine(ex.Message);
}
```

A simplified sequence diagram will look like this.

![diagram](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/async-void-fairy-tale/puppeteerworkflow.png)

So let's say that we fail to process `Target.targetCreated`. What line on the user code will fail? Easy, `browser.NewPageAsync`
But what if we fail to process `Target.targetInfoChanged`? There is no way we can send that exception to the user because the user didn't trigger that action.

This was a really ugly problem on Puppeteer-Sharp, **not being able to communicate internal errors to the user**.

>If your library consumes events from another source you need to be extremely careful with your exception handling and design your API, so you are able to communicate those exceptions.

## How did I solve this?

Puppeteer-Sharp has two types of connections. The `Connection` itself, one per process. And a Session connection, one per target. 
So, we added a `try-catch` block on every `MessageReceived` event we have in the library. If we get any error, we close the connection, and we add that exception as a `close reason`.

```cs
private async void Client_MessageReceived(object sender, MessageEventArgs e)
{
    try
    {
        //Message Processing
    }
    catch (Exception ex)
    {
        var message = $"NetworkManager failed to process {e.MessageID}. {ex.Message}. {ex.StackTrace}";
        _logger.LogError(ex, message);
        _client.Close(message);
    }
} 
```

Next issue.

## KeyNotFoundException trying to get a [Frame](https://github.com/kblok/puppeteer-sharp/blob/master/lib/PuppeteerSharp/Frame.cs) … What?

If you take a look at the sequence diagram again, you will see that the first message we get from Chromium is “Target.targetCreated”. How is it possible that we are getting a KeyNotFoundException exception?

I'll give you a hint, it begins with `async` and ends with `void`. 

An [IConnectionTransport](https://github.com/kblok/puppeteer-sharp/blob/master/lib/PuppeteerSharp/Transport/IConnectionTransport.cs) will start receiving a stream of messages from Chromium, parse them and trigger a `MessageReceived` event.

The problem here is that `MessageReceived?.Invoke` will trigger and forget an `async void` event handler. *Of Course!* there is not `await` involved! This **will** be a fire and forget.

Now it makes more sense when you read this on the [Using Asynchronous Methods in ASP.NET 4.5 post](https://docs.microsoft.com/en-us/aspnet/web-forms/overview/performance-and-caching/using-asynchronous-methods-in-aspnet-45)

>The downside to async void events is that developers no longer have full control over when events execute. For example, if both an .aspx and a .Master define Page_Load events, and one or both of them are asynchronous, the order of execution can't be guaranteed. The same indeterminate order for non event handlers (such as async void Button_Click ) applies.

Of course, the order of execution can't be guaranteed, because **the `Invoke` method won't await your `async` event handlers.

## Wait for frames to be created.

The Frames issue was easy to solve, though quite messy to implement. Basically. It was a matter of replacing all the:

```cs
Frames[someFrame];
```

With

```cs
await _frameManager.GetFrameAsync(someFrame);
```

# Final words

Although this might sound too Puppeteer-Sharp specific, I think it gives us, some interesting things to consider when designing a library that consumes events for another source.

Don't stop coding!