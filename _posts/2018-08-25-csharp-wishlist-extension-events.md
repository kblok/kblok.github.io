---
title: C# wishlist - Extension methods for events
tags: csharp dotnet 
permalink: /blog/csharp-wishlist-extension-for-events
---

Node.js has a pretty ~~cool~~ useful feature which is the ability to listen to an event only [once](https://nodejs.org/api/events.html#events_handling_events_only_once).

>Using the `eventEmitter.once()` method, it is possible to register a listener that is called at most once for a particular event. Once the event is emitted, the listener is unregistered and then called.

```js
const myEmitter = new MyEmitter();
let m = 0;
myEmitter.once('event', () => {
  console.log(++m);
});
myEmitter.emit('event');
// Prints: 1
myEmitter.emit('event');
// Ignored
```

In order to implement  `Once` on [puppeteer-sharp](https://github.com/hardkoded/puppeteer-sharp), we are implementing this boilerplate over and over:

```cs
void EventHandler(object sender, ConsoleEventArgs e)
{
    message = e.Message;
    Page.Console -= EventHandler;
}

Page.Console += EventHandler;
```

So, this morning a had this ~~brillant~~ idea about creating an extension method called `Once`. The implementation was pretty simple:

```cs
public static void Once<Z>(this EventHandler<Z> e, Action<object, Z> action) where Z : EventArgs
{
    void eventListener(object sender, Z args)
    {
        action(sender, args);
        e -= eventListener;
    };

    e += eventListener;
}
```

But, when I wanted to use it, for instance, here:

```cs 
_networkManager.Response.Once((object sender, ResponseCreatedEventArgs e) => responses[e.Response.Url] = e.Response);
```

I got a:

>Error CS0070: The event 'NetworkManager.Response' can only appear on the left hand side of += or -= (except when used from within the type 'NetworkManager') (CS0070)

Basically, you can't add extension methods to an event.

I found a few ideas on [StackOverflow](https://stackoverflow.com/questions/27766873/one-time-generic-event-call) but they are not the ideal solution. I think it would be great if we could have more flexibility with Events in C#.

What are your thoughts?

Don't stop coding!