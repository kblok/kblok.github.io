---
title: New .NET Library in Town. Let's Welcome ReactiveExtensions-Sharp
tags: puppeteer-sharp csharp dotnet ai
permalink: /blog/reactive-extensions-sharp
---

Puppeteer-Sharp has one simple goal: to be a port of Puppeteer, as close as possible.

Close in the API. Close in the .NET flavor, because a C# developer should feel at home. But also, and this is the part nobody sees, close in the internals. When the internals match, porting an upstream fix is a mechanical job instead of a research project.

And that's where things get interesting, because Puppeteer uses [rxjs](https://rxjs.dev/).

# The rxjs inside Puppeteer

Some of it is small and lovely. This is Puppeteer waiting for the fonts to be ready before printing a PDF:

```typescript
await firstValueFrom(
  from(
    this.mainFrame()
      .isolatedRealm()
      .evaluate(() => {
        return document.fonts.ready;
      }),
  ).pipe(raceWith(timeout(ms))),
);
```

Read it once more. "Take this promise, turn it into a stream, and race it against a timer." One expression. No token source, no `Task.WhenAny`, no cleanup.

And then there is stuff like this, which is how the BiDi implementation waits for a navigation:

```typescript
return await firstValueFrom(
  combineLatest([
    race(
      fromEmitterEvent(this.browsingContext, 'navigation'),
      fromEmitterEvent(this.browsingContext, 'historyUpdated').pipe(
        map(() => {
          return null;
        }),
      ),
    )
      .pipe(first())
      .pipe(
        switchMap(navigation => {
          if (navigation === null) {
            return of(null);
          }
          return this.#waitForLoad$(options).pipe(
            delayWhen(() => {
              if (frames.length === 0) {
                return of(undefined);
              }
              return combineLatest(frames);
            }),
            raceWith(
              fromEmitterEvent(navigation, 'fragment'),
              fromEmitterEvent(navigation, 'failed'),
              fromEmitterEvent(navigation, 'aborted'),
            ),
            switchMap(() => {
              if (navigation.request) {
                function requestFinished$(
                  request: Request,
                ): Observable<Navigation | null> {
                  if (navigation === null) {
                    return of(null);
                  }
                  if (request.response || request.error) {
                    return of(navigation);
                  }
                  if (request.redirect) {
                    return requestFinished$(request.redirect);
                  }
                  return fromEmitterEvent(request, 'success')
                    .pipe(
                      raceWith(fromEmitterEvent(request, 'error')),
                      raceWith(fromEmitterEvent(request, 'redirect')),
                    )
                    .pipe(
                      switchMap(() => {
                        return requestFinished$(request);
                      }),
                    );
                }
                return requestFinished$(navigation.request);
              }
              return of(navigation);
            }),
          );
        }),
      ),
    this.#waitForNetworkIdle$(options),
  ]).pipe(
    map(([navigation]) => {
      // ...
    }),
    raceWith(
      timeout(ms),
      fromAbortSignal(signal),
      this.#detached$().pipe(
        map(() => {
          throw new TargetCloseError('Frame detached.');
        }),
      ),
    ),
  ),
);
```

I won't pretend I understood that on the first read. Or the second. But once you do, **it says exactly what a navigation is**: race a navigation event against a history update, wait for the load, wait for the child frames, wait for the request chain to settle, and race the whole thing against a timeout, an abort signal, and the frame being detached.

Every "and also this can happen" is one more line, not one more branch.

# Doing that in plain C# is not impossible

It's just very hard to keep up with.

Puppeteer-Sharp's `Locator` retry loop is a `while (true)` with five catch clauses, one of them holding a `try` inside a `catch`, plus a comment explaining that `try` inside the `catch`, because otherwise nobody would believe it was on purpose. `WaitForNetworkIdleAsync` is the same story with different pieces: a `System.Timers.Timer`, four event handlers, a `Cleanup()` local function called from three different places, and a `TaskCompletionSource` to tie it all together.

That code works. I'm not ashamed of it. But it is bespoke, and that's the real cost. When upstream changes one line of an rxjs pipeline, I can't just port that line. I have to read the new semantics and figure out where they land inside my own imperative version. That's not porting. That's re-deriving, every single time.

# "But .NET already has Rx"

I know what you might be thinking, and it's true. .NET has [Rx.NET](https://github.com/dotnet/reactive). It's mature, it's first class, and it was there before rxjs.

But Rx.NET and rxjs are not the same library with different syntax. They are two implementations of the same idea that evolved separately for more than a decade. `map` is `Select`. `filter` is `Where`. `raceWith` is sort of `Amb`. "Retry with a delay between attempts" is not one call. And where the names do match, the defaults sometimes don't.

So porting an rxjs pipeline to Rx.NET is a translation, operator by operator, hoping every edge case lines up.

> I didn't want a translation. I wanted the same code.

# So now we have ReactiveExtensions-Sharp

[ReactiveExtensions-Sharp](https://github.com/hardkoded/ReactiveExtensions-Sharp) is a port of RxJS to .NET. Not "another Rx library". A port. Same operator names, same semantics, same edge cases, checked test by test against RxJS's own spec suite at tag `7.8.2`.

Which means `WaitForNetworkIdleAsync` now looks like this:

```csharp
var idleReached = _inFlightRequestCount.AsObservable()
    .Map(count => count <= concurrency)
    .DistinctUntilChanged()
    .SwitchMap(idle => idle ? Observable.Timer(TimeSpan.FromMilliseconds(idleTime)) : Observable.Never<long>())
    .Map(_ => Unit.Default);

await idleReached
    .RaceWith(CloseSignal<Unit>())
    .RaceWithSignalAndTimer(TimeSpan.FromMilliseconds(timeout), cancellationToken)
    .ConfigureAwait(false);
```

That's the whole method. The timer is gone. The four event handlers are gone. `Cleanup()` is gone, because unsubscribing *is* the cleanup.

And those five catch clauses in the locator become this:

```csharp
return await Observable
    .Defer(() => Observable.From(operation(linkedToken)))
    .RetryAndRaceWithSignalAndTimer(
        TimeSpan.FromMilliseconds(Timeout),
        causeFactory: null,
        retryDelay: TimeSpan.FromMilliseconds(RetryDelay),
        cancellationToken)
    .ConfigureAwait(false);
```

`RetryAndRaceWithSignalAndTimer` is not something I invented. It's the C# name for the combinator Puppeteer defines for itself in `locators.ts`: `pipe(retry({delay}), raceWith(fromAbortSignal(...), timeout(...)))`. Same three operators, same order, same behavior.

There is an [open PR](https://github.com/hardkoded/puppeteer-sharp/pull/3520) doing this across `Locator`, `WaitForNetworkIdle`, `WaitForRequest`, `WaitForResponse`, `WaitForFrame` and `WaitForTarget`. 232 lines added, 502 lines deleted.

## What's in the box

- 100+ operators and creation functions. The whole RxJS 7.8.2 surface, not a curated subset. `groupBy`, `expand`, `partition`, `using`, `bindCallback`, the full `window*`/`buffer*` families, `share`/`shareReplay` with the complete reset config.
- 800+ tests, ported from RxJS's own spec files. Not written from the docs. The same cases RxJS uses to check itself.
- A `VirtualTimeScheduler` and a marble-style `TestScheduler`, so you can assert that a debounce or a retry-with-backoff behaves correctly across virtual time, without waiting a single real millisecond.
- `netstandard2.0`, `net8.0` and `net10.0`.
- On [NuGet](https://www.nuget.org/packages/ReactiveExtensionsSharp/) as `ReactiveExtensionsSharp`, with [API docs](https://hardkoded.github.io/ReactiveExtensions-Sharp/).

# But now we have agents

This project sat on my "someday" list for years. Porting a full operator surface, test by test, is a lot of typing and not much thinking, and I'm one person with a day job.

And that turned out to be exactly the shape of work agents are good at. "Port this one operator, verify it against this one upstream spec file" is small, self-contained, and independently checkable. So most milestones ran as several agent sessions at the same time, each one in its own git worktree, each one landing its own branch.

Was it magic?
.
.
.
.
No.

The most interesting bug in this repo is about disposal. RxJS has a specific trick that makes "stop listening" cascade all the way up a chain of operators. The obvious C# translation works fine for async sources and silently fails for synchronous ones, because the whole emission loop finishes before `Subscribe()` even returns, so the "stop" signal arrives too late to attach anywhere.

That bug was found five separate times, by five sessions that knew nothing about each other, each one patching its own operator.

**Five independent rediscoveries is not five mistakes. It's a sign the problem is structural.** It only got fixed properly, once, at the architecture level, when somebody looked at all five reports together.

Later, an audit compared every ported test file against its real upstream spec. I expected it to find thin coverage. It found four genuine bugs, all of them while *writing* the missing tests: `concat` and `merge` had that same synchronous disposal bug in a corner nobody had checked, `combineLatest` completed too early when a source finished without ever emitting, `concatMap` could start the next inner observable before the previous cleanup had finished, and `takeUntil` had no error handler on its notifier at all, so an errored notifier took the whole process down.

Agents wrote most of the code. The bugs were found by reading, comparing and asking questions. That part is still ours.

# Final words

You probably noticed I keep saying "we". That's not a writing tic. Everything I do is community based. ReactiveExtensions-Sharp is not mine. It's ours.

It's at 0.3.0. It's young. The surface is complete, but the mileage is low, and low mileage is exactly what bug reports are for.

So bring new ideas, send PRs, fork it, break it! 😉

Don't stop coding!
