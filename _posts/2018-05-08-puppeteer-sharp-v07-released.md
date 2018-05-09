---
title: Puppeteer Sharp v0.7 a.k.a The dollar gate
tags: puppeteer-sharp csharp
permalink: /blogs/puppeteer-sharp-v07-released
---

We are shipping Puppeteer Sharp v0.7 with many cool new features: Element selectors and evaluation over elements. But our big challenge on v0.7 was [one of the hard things in computer science](https://twitter.com/codinghorror/status/506010907021828096?lang=en): Naming Things.

Puppeteer has these 5 cool functions:

 * `$(selector)`: It calls `document.querySelector` and returns an `ElementHandle`.
 * `$$(selector)`: It calls `document.querySelectorAll` and returns an `ElementHandle` array.
 * `$eval(selector, function)`: It calls `document.querySelector` and executes a function passing the element as an argument.
 * `$$eval(selector, function)`: It calls `document.querySelectorAll` and executes a function passing the element array as an argument.
 * `$x(xpathExpression)`: It calls `document.evaluate` and returns an `ElementHandle` array.

What do all these methods have in common? Hint: You can solve this using a `string.Substring()`.
Yes, you guessed it right! They all have that `$` symbol. And guess what? exactly, we can't name a method `$` in C#.

So, in order to give these functions a clear and "csharpy" name, we decided to call them in this way:

 * `page.$(selector)` => `page.QuerySelectorAsync(selector)`
 * `page.$$(selector)` => `page.QuerySelectorAllAsync(selector)`
 * `page.$eval(selector, function)` => `page.QuerySelectorAsync(selector).EvaluateFunctionAsync(function)`
 * `page.$$eval(selector, function)` => `page.QuerySelectorAllHandleAsync(selector).EvaluateFunctionAsync(function)`
 * `page.$(selector)` => `page.XPathAsync(selector)`

These methods may be more verbose, but this naming convention makes them clearer and hopefully, easier to learn.

This is the complete list of new APIs we implemented in this version: 
    - Page.XPathAsync
    - Page.QuerySelectorAsync
    - Page.QuerySelectorAllAsync
    - Page.QuerySelectorAllHandleAsync
    - Page.SelectAsync
    - Page.ExposeFunctionAsync
    - Page.EvaluateOnNewDocumentAsync
    - Page.AddScriptTagAsync
    - Page.AddStyleTagAsync
    - Page.PageError
    - JSHandle.EvaluateFunctionAsync
    - ElementHandle.EvaluateFunctionAsync

Don't stop coding!