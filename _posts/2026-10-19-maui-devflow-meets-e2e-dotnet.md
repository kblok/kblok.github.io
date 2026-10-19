---
title: "Agentic testing for MAUI apps using DevFlow"
tags: dotnet maui e2e testing ai opensource
permalink: /blog/maui-devflow-meets-e2e-dotnet
hero: /img/maui-devflow-meets-e2e-dotnet/hero.png
image: /img/maui-devflow-meets-e2e-dotnet/hero.png
---

What if your MAUI tests could just say "get the app to greet Grace" and let an agent figure out the taps?

If you read [.NET developers also deserve E2E!](/blog/dotnet-developers-also-deserve-e2e), you know [e2e-dotnet](https://github.com/hardkoded/e2e-dotnet) can drive mobile apps. Now it can also talk to your MAUI app from the inside, using the MAUI DevFlow agent.

> **Heads up: this is a spike.** The DevFlow path hasn't run against a real device yet. The unit tests use a fake agent. So take this post as a preview, and expect rough edges.

## What is DevFlow?

[MAUI DevFlow](https://github.com/dotnet/maui-labs/tree/main/src/DevFlow) is an HTTP server that lives inside your MAUI app, only in Debug builds. It can read the app's visual tree and drive the controls.

Why do I care? Two reasons:

- **The MAUI visual tree.** Your tests see your MAUI controls, not the OS accessibility tree.
- **Your `AutomationId`s.** Every control reports its `AutomationId`, and `GetByTestId` finds it.

The glue is a new package, `E2E.Mobile.DevFlow`. It finds the agent and hands it to the same `MobileEngine` the other mobile paths use. **Your tests don't change. Only the way they reach the app changes.**

## Let's add the agent to the app

One package reference, Debug only. This is the line from the sample's `MobileApp.csproj`:

```xml
<PackageReference Include="Microsoft.Maui.DevFlow.Agent"
                  Version="0.1.0-preview.13.26512.5"
                  Condition="'$(Configuration)' == 'Debug'" />
```

And one line in `MauiProgram.cs`:

```csharp
#if DEBUG
        builder.Logging.AddDebug();
        // Starts the DevFlow agent with the app, so E2E.Mobile.DevFlow can read
        // the visual tree and drive the controls.
        builder.AddMauiDevFlowAgent();
#endif
```

Thanks to the `#if DEBUG`, your Release build has no agent and no open port.

Then give your controls an `AutomationId`. The sample is a greeting form plus a counter, with `name`, `greet`, `error`, `greeting`, `counter`, and `increment`. Pick ids that say what the control *is*, not how it looks. They are your test contract.

## Let's set up the test project

This part used to hurt. Before, you needed around 200 lines of your own base class and a `[SetUpFixture]` before writing the first mobile test. Not anymore. With e2e-dotnet 0.6 you install `E2E.Mobile.NUnit` (or `E2E.Mobile.XUnit.V3` if you are an xUnit person) and declare your app in `e2e.config.json`:

```json
{
  "targets": [
    {
      "name": "mobileapp",
      "platform": "ios",
      "app": {
        "bundleId": "dev.hardkoded.e2e.mobileapp",
        "appPath": "../MobileApp/bin/Debug/net10.0-ios/iossimulator-arm64/MobileApp.app"
      }
    }
  ]
}
```

Then your test class derives from `MobileAppTest`:

```csharp
using E2E.Mobile.NUnit;

public class GreetingTests : MobileAppTest
{
    // your tests go here
}
```

That's it. The base class builds the engine, installs the build once per run, launches the app fresh before each test, and gives the agent the mobile tools. If you run on a hosted device (Limrun or DevFlow), it shares one device for the whole run and releases it when the process ends. Environment variables like `E2E_MOBILE_PLATFORM` or `E2E_MOBILE_APP_PATH` still win over the config, so the same project can run on iOS and Android.

## Let's write some tests

A locator-only test. No model, fast, stable:

```csharp
[Test]
public async Task Greets_the_name_you_type()
{
    await Screen.GetByTestId("name").FillAsync("Ada");
    await Screen.GetByTestId("greet").TapAsync();

    await Expect.That(Screen.GetByTestId("greeting")).ToHaveTextAsync("Hello, Ada!");
}
```

And now the fun one. You don't want to spell out every step? Ask the agent:

```csharp
[Test]
public async Task The_agent_gets_a_greeting()
{
    // The agent works out which field and button to use.
    await Agent.ActAsync("get the app to greet {name}", new ActOptions
    {
        Params = new Dictionary<string, object?> { ["name"] = "Grace" },
    });

    // Trust, but verify 😉
    await Expect.That(Screen.GetByTestId("greeting")).ToHaveTextAsync("Hello, Grace!");
}
```

See the last line? **Every `ActAsync` is paired with an `Expect` that doesn't call the model.** The model tells you what it did. The locator check proves it. If the agent got it wrong, the test fails.

## Let's run it

Launch the Debug build yourself, then run the tests with the DevFlow provider:

```bash
dotnet build samples/MobileApp -f net10.0-ios -r iossimulator-arm64 -t:Run
E2E_MOBILE_PROVIDER=devflow E2E_DEVFLOW_APP=MobileApp dotnet test samples/MobileApp.E2ETests
```

The tests find the agent through the DevFlow broker (`maui devflow list`) when one is running, else on port 9223, or on `E2E_DEVFLOW_PORT` if you set it. `E2E_DEVFLOW_APP` is the app name the broker lists, so it picks the right agent if you have more than one app running. They wait up to a minute for it and hold the agent's mutation lease for the run, so other DevFlow tools know e2e is driving the app. On Android, forward the port first with `adb forward tcp:<port> tcp:<port>`.

Something doesn't work? Set `E2E_DEVFLOW_TRACE=1` and you get every call to the agent (method, URL, status) on stderr.

## Wait, what's the catch?

There is one. **The tests attach to a running app.** DevFlow lives inside the app, so it can't install it, close it, or relaunch it. Nothing resets the app between tests. Each test starts where the previous one left.

So you have to write your tests with that in mind. The counter test reads the count first instead of assuming zero:

```csharp
var before = int.Parse((await Screen.GetByTestId("counter").TextContentAsync())!.Split(':')[1]);

await Agent.ActAsync("press Add one three times");

await Expect.That(Screen.GetByTestId("counter")).ToHaveTextAsync($"Count: {before + 3}");
```

Tests that need a relaunch or to send the app to the background just opt out with `Assume.That` and the `AttachesToRunningApp` flag from `MobileAppTest`, so they show up as inconclusive, not failed:

```csharp
Assume.That(!AttachesToRunningApp,
    "The DevFlow agent runs inside the app and cannot relaunch it yet.");
```

Same suite, two worlds. On a local device the relaunch test runs. On DevFlow it's skipped.

And of course, Debug builds only. No agent in Release.

## Final words

If you already run your MAUI app in a simulator, the cost is tiny: one package, one line in `MauiProgram.cs`, some `AutomationId`s, a `targets` entry, and a base class. And you get E2E tests, even AI-driven ones.

But let's be honest, this is a spike. Use it to explore, and keep the agent-device path for tests that need a clean launch. If you try it and something breaks, run with `E2E_DEVFLOW_TRACE=1` and [open an issue](https://github.com/hardkoded/e2e-dotnet/issues) with the output. That would help a lot.

The full sample is in [`samples/MobileApp`](https://github.com/hardkoded/e2e-dotnet/tree/main/samples/MobileApp) and [`samples/MobileApp.E2ETests`](https://github.com/hardkoded/e2e-dotnet/tree/main/samples/MobileApp.E2ETests).

Don't stop coding!
