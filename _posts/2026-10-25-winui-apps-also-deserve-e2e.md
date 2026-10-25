---
title: "WinUI apps also deserve E2E!"
tags: dotnet winui e2e testing ai opensource windows
permalink: /blog/winui-apps-also-deserve-e2e
hero: /img/winui-apps-also-deserve-e2e/hero.png
image: /img/winui-apps-also-deserve-e2e/hero.png
---

WinUI apps also deserve E2E.

If you read [.NET developers also deserve E2E!](/blog/dotnet-developers-also-deserve-e2e), you know [e2e-dotnet](https://github.com/hardkoded/e2e-dotnet) can drive a browser, and a phone. Last week it learned to talk to a [MAUI app through DevFlow](/blog/maui-devflow-meets-e2e-dotnet). Now the same API can drive a Windows window.

**Same locators. Same `Agent.ActAsync`. A desktop app this time.**

## What landed

[`E2E.WinApp`](https://www.nuget.org/packages/E2E.WinApp) is on NuGet, in [0.7.0](https://www.nuget.org/packages/E2E.WinApp/0.7.0). The engine drives the app through Windows UI Automation, with the library behind the `winapp ui` command (`Microsoft.Windows.SDK.BuildTools.WinApp.UIAutomation` 0.7.1). The package brings that library. `dotnet add package` is the whole install. No `winapp.exe`.

WinUI 3, WPF, WinForms, and Win32 all speak UI Automation, so the engine talks to all of them. It runs on Windows only.

The test fixtures are two more packages: [`E2E.WinApp.NUnit`](https://www.nuget.org/packages/E2E.WinApp.NUnit) and [`E2E.WinApp.XUnit.V3`](https://www.nuget.org/packages/E2E.WinApp.XUnit.V3). Both are 0.7.0, and both give you a `WinAppTest` base class. `e2e explore` and `e2e mcp` also grew a `windows` target, so an agent can poke the app from the CLI.

## What is Reactor?

The app the engine is tested against is [`apps/WinAppBenchmark`](https://github.com/hardkoded/e2e-dotnet/tree/main/apps/WinAppBenchmark). I wrote it with [Microsoft.UI.Reactor](https://github.com/microsoft/microsoft-ui-reactor) 0.1.0-preview.16, so the whole UI is C#. Reactor is an experimental C#-first MVU framework for WinUI. No XAML files, no code-behind. Alexandre Zollinger Chohfi wrote the longer tour on the [Windows Dev Blog](https://devblogs.microsoft.com/ifdef-windows/microsoft-ui-reactor-a-c-first-way-to-build-winui-apps/). It renders real WinUI controls. And it is experimental: no support policy, no API guarantees. He says that up front, and he's right.

The app starts in one line:

```csharp
ReactorApp.Run<BenchmarkApp>("e2e Benchmark", width: 480, height: 900);
```

A control gets its test id in code. This is the email field from the Login Form:

```csharp
TextBox(email, setEmail, placeholderText: "Email").AutomationName("Email").AutomationId("email-input"),
```

`GetByTestId("email-input")` finds that. In XAML the same id is `AutomationProperties.AutomationId`. The engine reads the UI Automation tree, so either one works.

The benchmark is unpackaged (`WindowsPackageType` set to `None`), so the engine can start `WinAppBenchmark.exe` itself.

## Let's set up the test project

Install the fixture. It pulls `E2E.WinApp` in with it:

```bash
dotnet add package E2E.WinApp.NUnit
```

xUnit v3 folks want `E2E.WinApp.XUnit.V3`.

One catch on restore. The UI Automation library ships Windows assets only. A test project on plain `net10.0` needs these two lines, or restore fails with `NU1202`:

```xml
<AssetTargetFallback>$(AssetTargetFallback);net10.0-windows7.0</AssetTargetFallback>
<NoWarn>$(NoWarn);NU1701</NoWarn>
```

Targeting `net10.0-windows` also works. The sample uses the fallback. The details are in the [windows skill doc](https://github.com/hardkoded/e2e-dotnet/blob/main/skills/e2e-dotnet/references/windows.md).

Then `e2e.config.json`. This is the benchmark's target, the path the x64 Debug build writes:

```json
{
  "targets": [
    {
      "name": "benchmark",
      "platform": "windows",
      "app": {
        "appPath": "../WinAppBenchmark/bin/x64/Debug/net10.0-windows10.0.22621.0/WinAppBenchmark.exe",
        "bundleId": "WinAppBenchmark"
      }
    }
  ]
}
```

`appPath` is the executable, relative to the folder of `e2e.config.json`. `bundleId` is the process name. With both, each test launches that exe fresh, and the agent's `open_app` tool knows the app as `WinAppBenchmark`. A target with `bundleId` alone attaches to the running app and leaves it running. A `windows` target takes no `app.url`.

Your test class:

```csharp
using E2E.WinApp.NUnit;

public class LoginTests : WinAppTest
{
}
```

That's it. `WinAppTest` builds a `WinAppEngine`, launches the app before each test, ends it after, hands the agent `WinAppTools`, and sets the step timeout to 90 seconds. `E2E_WINAPP_APP_PATH` still wins over the config, so one project can point at a build that lives somewhere else.

## Let's write some tests

The benchmark's login tests extend `WinAppTest` (through `BenchmarkTest`). The `[SetUp]` loads the account and opens the Login Form scenario. The test itself is locators. No model:

```csharp
[Test]
public async Task Signs_in_and_logs_out()
{
    await Screen.GetByTestId("email-input").FillAsync(_account.Username);
    await Screen.GetByTestId("password-input").FillAsync(_account.Password);
    await Screen.GetByTestId("login-button").TapAsync();
    await Expect.That(Screen.GetByTestId("success-message")).ToHaveTextAsync("Logged in successfully");

    await Screen.GetByTestId("logout-button").TapAsync();
    await Expect.That(Screen.GetByTestId("login-button")).ToBeVisibleAsync();
}
```

`_account` is `Credentials.User("benchmark")`. The scenario's account is `tester@tester.army` / `benchmark123`, unless `E2E_USER_BENCHMARK_USERNAME` and `E2E_USER_BENCHMARK_PASSWORD` say otherwise.

Now the fun one. The scenario suite asks the agent to log in, then checks the same message without another model call:

```csharp
await OpenScenarioAsync("Login Form");
var account = Credentials.User("benchmark");

await Agent.ActAsync(
    "Complete this scenario as the screen instructs: log in with the given username and password",
    new ActOptions
    {
        Params = new Dictionary<string, object?>
        {
            ["username"] = account.Username,
            ["password"] = account.Password,
        },
    });

// Trust, but verify 😉
await Expect.That(Screen.GetByTestId("success-message")).ToHaveTextAsync("Logged in successfully");
```

**The model does the clicking. The `Expect` does not call a model, so a wrong login still fails the test.**

`OpenScenarioAsync` is a helper on the benchmark. It taps the home-list row named `"Login Form. "`. Your app starts on its own window, so you skip that and go straight to `ActAsync`.

A few scenarios hide the tree on purpose (Broken Accessibility, Vision Only, the flattened forms). Those have no `success-message` id to read. They call `Agent.AssertAsync` with `VisionMode.Only` and judge a screenshot. The test file says why.

## Let's run it

The benchmark project needs `Platform` set. Build it for x64, then test. The config already points at that exe:

```bash
dotnet build apps/WinAppBenchmark -p:Platform=x64
dotnet test apps/WinAppBenchmark.E2ETests --filter "FullyQualifiedName!~Scenarios"
```

That filter skips the agent tests. Those need a model login once:

```bash
dotnet run --project src/E2E.Cli -- login github-copilot
dotnet test apps/WinAppBenchmark.E2ETests
```

You need an unlocked, interactive Windows desktop. Pattern actions (invoke, set value, toggle, select) work with the window anywhere. Keys, clicks, drags, and the wheel go through `SendInput`, and that reaches the window in the foreground only. A locked screen, a disconnected remote desktop, or a CI runner with no desktop session fails those with `NOT_ACTIONABLE`.

Built the exe somewhere else? `E2E_WINAPP_APP_PATH` names it over the config.

`e2e explore` and `e2e mcp` read the same target. Run them on Windows, from the folder of `e2e.config.json`:

```bash
e2e explore "open the login form and sign in"
e2e mcp
```

## Final words

If you have a WinUI, WPF, or WinForms exe, the setup is small. One package, two lines so restore can see the Windows assets, a `windows` target, some `AutomationId`s, and a class that extends `WinAppTest`. Then you get E2E tests on the same API as the browser and the phone, agent steps included.

It wants a real Windows desktop in front of it. If you try it and something breaks, [open an issue](https://github.com/hardkoded/e2e-dotnet/issues) with what the window was doing. That would help a lot.

The app is [`apps/WinAppBenchmark`](https://github.com/hardkoded/e2e-dotnet/tree/main/apps/WinAppBenchmark). The tests are [`apps/WinAppBenchmark.E2ETests`](https://github.com/hardkoded/e2e-dotnet/tree/main/apps/WinAppBenchmark.E2ETests).

Don't stop coding!
