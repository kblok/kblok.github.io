---
title: "Talking to GPT from a WinForms app"
tags: dotnet csharp ai vercel opensource
permalink: /blog/talking-to-gpt-from-winforms
hero: /img/talking-to-gpt-from-winforms/hero.png
hero_dark: /img/talking-to-gpt-from-winforms/hero-dark.png
image: /img/talking-to-gpt-from-winforms/hero.png
---

I put one button on a WinForms window and had a real conversation with GPT, out loud, from a .NET app.

[Vercel put GPT-Live 1.1 on the AI Gateway](https://vercel.com/changelog/gpt-live-1-1-now-available-on-ai-gateway) yesterday. It's a full-duplex voice model, so it can listen while it's still talking, the transcription is better than the last one, and the voice keeps a more consistent accent when you change language. They bill the session by the second, so a short test doesn't get rounded up to a full minute. I already had [Vercel AI for .NET](/blog/vercel-ai-for-dotnet-devs) running, with the same Gateway key, so I pointed it at `openai/gpt-live-1.1`.

The UI is a little silly on purpose. The window title is "GPT-Live 1.1 voice". There's just one button that says "Start talking" and turns into "Stop", and a text box under it, no settings and no voice picker. I wanted the boring desktop app I have been writing forever to just talk.

<video controls muted playsinline loop width="506" height="410" style="max-width: 100%; height: auto;" src="/img/talking-to-gpt-from-winforms/demo.mp4"></video>

The log says "Connected. Start talking." I said "Hey, hello GPT", and it came back with "Hey! How's it going?" in about half a second. The text box fills in as it speaks, a fragment at a time, sometimes in the middle of a word. Then I told it that it was running inside a .NET app. It laughed. The transcript writes the laugh as `[chuckle]`, and it writes .NET as "dot net". I'm keeping both.

## The part I had to get right

The sample I merged is [examples/GptLiveWinForms](https://github.com/hardkoded/vercel-ai-sdk-dotnet/tree/main/examples/GptLiveWinForms). It targets `net10.0-windows` and uses NAudio 2.2.1 for the mic and the speakers. The OpenAI provider is aimed at the Gateway, and the realtime model has to opt into the live API.

```csharp
_provider ??= OpenAIProvider.Create(
    new OpenAIOptions { ApiKey = apiKey, BaseUrl = "https://ai-gateway.vercel.sh/v1" }
);
var model = (OpenAIRealtimeModelLive)
    _provider.RealtimeModel(ModelId, new OpenAIRealtimeOptions { Api = "live" });
```

`ModelId` is `"openai/gpt-live-1.1"`, and `apiKey` comes from `AI_GATEWAY_API_KEY`. After `ConnectAsync` I send `session-start` with PCM at 24 kHz, and then I wait. The Gateway rejects audio that shows up before `session-started`. I didn't enjoy finding that out.

```csharp
await SendAsync(
    new RealtimeModelV4ClientEvent("session-start")
    {
        Config = new RealtimeModelV4SessionConfig
        {
            InputAudioFormatType = "audio/pcm",
            InputAudioFormatRate = SampleRate,
        },
    }
);
```

`SampleRate` is 24000. The microphone is a `WaveInEvent` with 20 ms buffers, and each buffer goes out as `input-audio-append`. A WebSocket only wants one send at a time, so if the previous chunk is still on the way I drop the new one instead of building a queue of late audio.

```csharp
// Drop a chunk when the previous send is still running, so audio never queues up.
await SendAsync(
    new RealtimeModelV4ClientEvent("input-audio-append")
    {
        Audio = Convert.ToBase64String(e.Buffer, 0, e.BytesRecorded),
    },
    dropIfBusy: true
);
```

Coming back, I `await foreach` over `session.Events` and let `model.ParseServerEvent` turn each message into something I can switch on. An `audio-chunk` is base64 PCM, and it lands in a `BufferedWaveProvider` that can hold 60 seconds, because the model will happily talk faster than the speakers can play. A `transcript-fragment` is the text box, "You:" or "AI:", and it stays on the same line until the other side starts. `error` goes to the log, `session-closed` ends the read, and the Stop button sends `session-close` so the Gateway gets to finish instead of me yanking the cable.

## Final words

WinForms isn't the demo people expect anymore, and that's the fun part. There's just one button and a text box, with a live model on the other side. If you want the rest of the SDK, text, tools, streaming, agents, I wrote that up in [Vercel AI for .NET devs](/blog/vercel-ai-for-dotnet-devs). The docs are at [hardkoded.com/vercel-ai-sdk-dotnet](https://www.hardkoded.com/vercel-ai-sdk-dotnet/), and the example is in the repo if you want to run it.

Screen recording on Windows is terrible, by the way. You can tell.

Don't stop coding!
