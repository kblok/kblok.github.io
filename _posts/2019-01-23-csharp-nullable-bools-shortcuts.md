---
title: C# wishlist - Nullable nulls shortcuts
tags: csharp dotnet 
permalink: /blog/csharp-nullable-bools-shortcuts
---

I must admit that I love the way that Javascript evaluates [truthy](https://developer.mozilla.org/en-US/docs/Glossary/Truthy) and [falsy](https://developer.mozilla.org/en-US/docs/Glossary/Falsy) expressions. 

```js
if (true)
if ({})
if ([])
if (42)
if ("foo")
if (new Date())
if (-42)
if (3.14)
if (-3.14)
if (Infinity)
if (-Infinity)
```

When you come from C# you tend to add `> 0` or `!= ''`. Although is could be quite tricky, once you get the idea it becomes super simple to express conditions.

C# applies the same shortcuts but only for booleans, which is good. You can do:

```cs
var truthy = true;
var falsy = false;

if (truthy || falsy)
```

But the C# team is [very strong](https://github.com/dotnet/csharplang/issues/134), [very strong](https://github.com/dotnet/csharplang/issues/871), not supporting that for `Nullable<bool>` a.k.a. `bool?` (am I the only one how reads nullables as questions?). So you can't do

```cs
bool? falsy = false;

if(falsy)
```

Instead, you need to do:

```cs
bool? falsy = false;

if(falsy == false)
```

I know it has an explanation. I know that `null` is not equal to `false` in C#, but writing `== false` or `== true` in if conditions looks super odd to me. Maybe instead of change that rule we could have some syntax sugar so the compiler adds a `== true` or `== false` for us.

What do you think?
