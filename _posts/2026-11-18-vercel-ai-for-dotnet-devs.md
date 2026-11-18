---
title: "Vercel AI for .NET devs!"
tags: dotnet csharp ai vercel opensource
permalink: /blog/vercel-ai-for-dotnet-devs
hero: /img/vercel-ai-for-dotnet-devs/hero.png
hero_dark: /img/vercel-ai-for-dotnet-devs/hero-dark.png
image: /img/vercel-ai-for-dotnet-devs/hero.png
---

I know, I know. Vercel is not the go-to cloud for a .NET developer.

Vercel grew up around Next.js and TypeScript on Node. I'm pretty sure [Guillermo Rauch](https://x.com/rauchg) knows about this. And in the web world, let's be honest, .NET devs are a small village.

But let me tell you a story.

## How did I end up here?

When JEV, the [TypeSafe AI](https://typesafe.ai) model, came out, I wanted to use it from .NET. I looked for a .NET client and I couldn't find any. So I made one: [typesafe-sdk-dotnet](https://github.com/hardkoded/typesafe-sdk-dotnet).

During that search I found the [Vercel AI SDK](https://ai-sdk.dev). And I said:

> "oooh man, this is so so so so good!"

I knew a .NET port of this library wasn't going to be mega popular. The village, remember? But I decided to burn some tokens anyway and I built [vercel-ai-sdk-dotnet](https://github.com/hardkoded/vercel-ai-sdk-dotnet).

And honestly, **this is sooo good!**

It's an unofficial community port. It's not a Vercel product and it's not endorsed by Vercel. The parity target is AI SDK 7, the Language Model specification V4.

## Let's see some code

First, install it. Every provider ships in one package, and it targets `net10.0` and `netstandard2.0`.

```bash
dotnet add package Vercel.AI
```

If a coding agent is going to write this for you, the repo has a skill for that.

```bash
npx skills add hardkoded/vercel-ai-sdk-dotnet
```

### One API, any model

By default, a model id string goes to the [Vercel AI Gateway](https://vercel.com/docs/ai-gateway). Do you want to switch from OpenAI to Anthropic? Change a string.

```csharp
var client = new AiClient(GatewayProvider.Create());

var result = await client.GenerateTextAsync(
    new GenerateTextOptions
    {
        ModelId = "anthropic/claude-opus-5.5", // or "openai/gpt-6-astra", "google/gemini-3.8-flash", etc.
        Prompt = "Hello!",
    }
);

Console.WriteLine(result.Text);
```

You don't want the Gateway? No problem, you can call the provider directly. `Create()` reads the API key from the same env variable the JavaScript provider uses.

```csharp
var client = new AiClient(GatewayProvider.Create());
var anthropic = AnthropicProvider.Create(); // or OpenAIProvider.Create(), GoogleProvider.Create(), etc.

var result = await client.GenerateTextAsync(
    new GenerateTextOptions
    {
        Model = anthropic.LanguageModel("claude-opus-5-5"),
        Prompt = "Hello!",
    }
);

Console.WriteLine(result.Text);
```

### Streaming

The tokens come back as an `IAsyncEnumerable`, the way a .NET dev actually wants to read them.

```csharp
var client = new AiClient(GatewayProvider.Create());

var stream = client.StreamTextAsync(
    new StreamTextOptions
    {
        ModelId = "openai/gpt-6-astra",
        Prompt = "Draft a changelog entry.",
    }
);

await foreach (var delta in stream.TextStream())
{
    Console.Write(delta);
}
```

### Agents with tools

This is the one that made me smile.

```csharp
var weatherAgent = new Agent(
    new AgentOptions
    {
        ModelId = "openai/gpt-6-astra",
        Instructions = "You are an agent that answers questions about the weather.",
        Tools = new[]
        {
            Tool.Function(
                "weather",
                "Returns the weather in a city.",
                """{ "type": "object", "properties": { "city": { "type": "string" } }, "required": ["city"] }""",
                (arguments, cancellationToken) =>
                {
                    var city = arguments.GetProperty("city").GetString();
                    return Task.FromResult(
                        JsonSerializer.Serialize(
                            new
                            {
                                city,
                                forecast = "sunny",
                                temperature = 22,
                            }
                        )
                    );
                }
            ),
        },
    }
);

var result = await weatherAgent.GenerateAsync("What is the weather in Lisbon?");
Console.WriteLine(result.Text);
```

There is also structured output. `OutputSpec.Object` takes a JSON schema, and you get an object back that matches it. And there's a bonus: `ToUIMessageStreamResult` lets an ASP.NET Core endpoint stream to a JavaScript `useChat` client. That helper is `net10.0` only. **Your backend in .NET, your frontend with the Vercel AI UI.** Yes, the village can talk to the big city.

Every snippet comes from a project in the [examples folder](https://github.com/hardkoded/vercel-ai-sdk-dotnet/tree/main/examples), and CI builds all of them.

## Why using Vercel AI in your apps?

You might say, "Darío, why not just use the OpenAI client?" Fair question.

It's not a niche thing. The [`ai` package](https://www.npmjs.com/package/ai) on npm is past 47 million weekly downloads, and the [vercel/ai repo](https://github.com/vercel/ai) has more than 28,000 stars and almost 800 contributors. A lot of JavaScript devs already learned this API. Now you can use the same mental model in C#.

You are not married to a provider. One API for OpenAI, Anthropic, Google, and [more](https://ai-sdk.dev/providers/ai-sdk-providers). Models keep changing. Your code shouldn't.

Then there is the Gateway. With the [AI Gateway](https://vercel.com/docs/ai-gateway), one key and a model id string reach the major providers, and new models keep showing up there. There is also a [monthly free credit](https://vercel.com/docs/ai-gateway/pricing) for a subset of models, so you can play before you pay anything. In .NET you just change the string.

Streaming, tools, structured output, and agents are already there. Those are the things you actually need to build an AI feature, not something you glue together later.

And if your team has a Next.js frontend and a .NET backend, now everybody speaks the same AI SDK language.

## Final words

I know this is not going to be the most downloaded package on NuGet. And that's OK. I built it because I loved the API and I wanted it in my language.

If you are a .NET dev building anything with LLMs, give it a try:

```bash
dotnet add package Vercel.AI
```

Play with the [examples](https://github.com/hardkoded/vercel-ai-sdk-dotnet/tree/main/examples), read the [docs](https://www.hardkoded.com/vercel-ai-sdk-dotnet/), and if something is broken, [open an issue](https://github.com/hardkoded/vercel-ai-sdk-dotnet/issues). I wrote about the new docs site in [Meet the new Hardkoded docs](/blog/meet-the-new-hardkoded-docs). And a ⭐️ on the repo helps the village a lot 😉

Don't stop coding!
