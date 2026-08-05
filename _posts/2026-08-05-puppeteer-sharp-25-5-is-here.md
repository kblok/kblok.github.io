---
title: Puppeteer-Sharp 25.5 is here
tags: puppeteer-sharp csharp
permalink: /blog/puppeteer-sharp-25-5-is-here
---

I'm super excited to share that Puppeteer-Sharp 25.5.0 just landed, and this one has some punches I really want to tell you about.  
Let's go through what's new.

## The PWA that returned an empty page

Have you ever waited for a page and gotten... nothing? An empty URL, just staring back at you?

That's exactly what was happening to `LaunchPWAAsync` on Windows. Every single CI run, the test would launch an installed PWA and come back with `page.Url` empty instead of the app's start URL. Linux was fine. Windows was not.

Turns out we were waiting for the launched page's *target* to show up in the right spot of the hierarchy, but never checking whether that target had actually **finished initializing**. On Windows, the child target apparently shows up in the target dictionary before its URL gets populated, so `WaitForTargetAsync` would resolve on the very first match, and we'd build a `Page` out of a target that was still blank.

The fix was two lines: await `target.InitializedTask` before creating the page, same as we already do everywhere else a target gets created. Small diff, annoying bug, gone.

## Can two connections agree a dialog was handled?

.

.

.

.

Now they can.

We ported upstream's dialog status tracking so that when a JavaScript dialog gets handled, every connection watching that page knows about it — CDP updates its state when the `javascriptDialogClosed` event comes in, and BiDi updates when the underlying user prompt gets handled. If you've ever had two pieces of code racing to accept/dismiss the same `alert()`, this one's for you.

## Locking down PWAs a bit more

We also fixed a case where a PWA launch could bypass network restrictions you had explicitly configured. **If you set network restrictions, they now apply to PWAs too** — no more quiet exceptions.

## Chrome 151, Firefox 153, and a popup nobody asked for

We rolled to Chrome 151.0.7922.71 and Firefox 153.0.1, keeping both browsers current. And in the "who approved this" category: newer Chrome versions ship a `WebUIOmniboxPopup` / `WebUIOmniboxAimPopup` (yes, an AI popup in the address bar), and we now disable both by default in our launch args — same as upstream. Automation and a chatty omnibox don't mix.

## Headers, all the way through

If you connect using `browserURL`, your `ConnectOptions.Headers` are now forwarded both to the `/json/version` discovery request *and* to the WebSocket handshake that follows. Before this fix, your headers would get dropped somewhere along the way — now they travel the whole trip.

# Final words

None of this happens without the people who file the upstream issues, review the ports, and keep pushing Puppeteer-Sharp forward. It's not my project, it's ours, and I'm grateful for everyone who opens an issue, tests a fix, or just keeps using it.

If you want the full list, check the [25.5.0 release notes](https://github.com/hardkoded/puppeteer-sharp/releases/tag/v25.5.0).

Don't stop coding!
