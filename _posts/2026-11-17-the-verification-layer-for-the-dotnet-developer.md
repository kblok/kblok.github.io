---
title: "The verification layer for the agentic .NET developer"
tags: dotnet ai testing
permalink: /blog/the-verification-layer-for-the-agentic-dotnet-developer
hero: /img/the-verification-layer-for-the-dotnet-developer/hero.png
image: /img/the-verification-layer-for-the-dotnet-developer/hero.png
---

I watched Lauren Tan's talk [All Code Is Slop (Except Mine)](https://www.youtube.com/watch?v=O_zcc6Xl12g), and I keep coming back to what she says about verification.

This is a living post. Last updated November 17, 2026. I'll keep adding verification layers as I find ones that earn a place here.

Her point is simple, and a bit uncomfortable. With agents writing the code, we don't really read the code anymore. We read the verification.

<div style="position: relative; width: 100%; padding-bottom: 56.25%; height: 0; overflow: hidden; margin: 1.5rem 0;">
  <iframe style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: 0;" src="https://www.youtube.com/embed/O_zcc6Xl12g" title="All Code Is Slop (Except Mine), Lauren Tan" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
</div>

She says the review itself shrank:

> our code review process has now really shrunk into looking at verification artifacts instead. So things like videos, screenshots, diagrams, formal verification.

And when she corrects an agent, that correction becomes a check:

> every time we correct our agents, it turns into one of these deterministic checks or we think about how to categorically eliminate that problem in the code through better API design, through better architecture.

And the line I keep quoting back at myself:

> if your inner coding loop produces slop, then automating that loop just produces more slop

So what are good verification layers for a .NET dev environment? I'll walk through the ones I actually run on [Puppeteer-Sharp](https://github.com/hardkoded/puppeteer-sharp). It's the list I have today.

## dotnet build

The first one is boring, which is why it works. `dotnet build`. The compiler, and the type system.

A warning the agent can scroll past never stops it. In [Directory.Build.props](https://github.com/hardkoded/puppeteer-sharp/blob/master/Directory.Build.props) I set `TreatWarningsAsErrors`, so a warning fails the build, and a failed build is something the agent has to stop for.

```xml
<?xml version="1.0" encoding="utf-8"?>
<Project>
    <PropertyGroup>
        <LangVersion>9</LangVersion>
        <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
    </PropertyGroup>
</Project>
```


## dotnet format

Once it compiles, I want the style and the analyzer passes to fail the same way.

We run it in CI:

```bash
dotnet format style ./lib/PuppeteerSharp.sln --verify-no-changes
dotnet format analyzers ./lib/PuppeteerSharp.sln --verify-no-changes
```

`--verify-no-changes` is the whole trick. If the code isn't already in the shape those passes want, the job fails.


## Analyzers

Those format passes only catch what you plugged in, so the package list is the actual layer. These are the ones on the repo today.

[Microsoft.CodeAnalysis.NetAnalyzers](https://github.com/hardkoded/puppeteer-sharp/blob/master/lib/PuppeteerSharp/PuppeteerSharp.csproj), with `AnalysisLevel` set to `10.0-Recommended` in that same csproj. That's the Microsoft recommended set.

[StyleCop.Analyzers](https://github.com/hardkoded/puppeteer-sharp/blob/master/lib/PuppeteerSharp/PuppeteerSharp.csproj) comes with [lib/stylecop.json](https://github.com/hardkoded/puppeteer-sharp/blob/master/lib/stylecop.json) and [lib/.editorconfig](https://github.com/hardkoded/puppeteer-sharp/blob/master/lib/.editorconfig). StyleCop is the one that nags about docs, member order, and naming. The layout rules, the SA ones about spaces and braces, are set to `none` in that editorconfig, because CSharpier already decided how the file looks and those rules just disagree with it.

[Microsoft.CodeAnalysis.CSharp.CodeStyle](https://github.com/hardkoded/puppeteer-sharp/blob/master/lib/PuppeteerSharp/PuppeteerSharp.csproj) is the IDE-style package. There is a [root .editorconfig](https://github.com/hardkoded/puppeteer-sharp/blob/master/.editorconfig), and `lib/.editorconfig` is marked as its own root, so the library follows the file that sits next to the code. Both are full of `csharp_style_*` lines, and a bunch of them are errors. `var`, expression-bodied members, braces. The kind of thing two humans will argue about in review, and an agent will "fix" a different way every time, unless the build says no.

The test project adds [NUnit.Analyzers 4.3.0](https://github.com/hardkoded/puppeteer-sharp/blob/master/lib/PuppeteerSharp.Tests/PuppeteerSharp.Tests.csproj). Same idea, pointed at the tests.

## CSharpier

Whitespace is a different tool, on purpose.

[CSharpier](https://csharpier.com) is opinionated. You don't pick the brace style. The tool has one, and the argument is over.

On a repo that doesn't have it yet:

```bash
dotnet new tool-manifest
dotnet tool install csharpier
```

The check fails when something isn't formatted:

```bash
dotnet csharpier check .
```

Puppeteer-Sharp pins [CSharpier 1.4.0](https://github.com/hardkoded/puppeteer-sharp/blob/master/.config/dotnet-tools.json) as a local tool. CI has its own job that runs `dotnet csharpier check .`, and the [Husky pre-push hook](https://github.com/hardkoded/puppeteer-sharp/blob/master/.husky/task-runner.json) runs the same command, so my own pushes fail before CI even starts. If you'd rather hang it off the build, [CSharpier.MSBuild](https://www.nuget.org/packages/CSharpier.MSBuild) is a real package. I haven't added it. The local tool, the hook, and the CI job already fail the unformatted code.

## Unit tests

Then the part I still read with my eyes.

[PuppeteerSharp.Tests](https://github.com/hardkoded/puppeteer-sharp/blob/master/lib/PuppeteerSharp.Tests/PuppeteerSharp.Tests.csproj) is NUnit 4.1.0 and NSubstitute 5.1.0. A lot of these tests drive a real browser, so a red test is sometimes just a flake, and CI retries failed tests with [dotnet-retest](https://github.com/devlooped/dotnet-retest). The workflow runs `dotnet tool update -g dotnet-retest` and then `dotnet retest`, with the NUnit runsettings after the `--`. The tool version isn't pinned in the repo.

**The tests are the verification artifact I actually open.** The build tells me it compiles. The formatter tells me it looks like the rest of the repo. The test is where the change is supposed to say what it meant. I wrote about the failure mode of this in [the state of unit testing in the AI era](/blog/the-state-of-unit-testing-in-the-ai-era). A pile of tests the agent wrote so it could agree with itself is noise, and I've marked those files as viewed. The ones I still read are the ones that read like the spec.

## e2e-dotnet

The layer that gets closest to the videos and screenshots Lauren was talking about is [e2e-dotnet](https://github.com/hardkoded/e2e-dotnet). I wrote about it in [.NET developers also deserve E2E!](/blog/dotnet-developers-also-deserve-e2e), and the docs are at [hardkoded.com/e2e-dotnet](https://www.hardkoded.com/e2e-dotnet/).

It runs end-to-end tests on top of Playwright. The packages are `E2E`, plus `E2E.NUnit`, `E2E.XUnit.V3`, or `E2E.TUnit`, so you keep the runner you already have. The test states a goal, something like `Agent.ActAsync("upgrade the workspace to the Pro plan")`, and the check is a locator, `Expect.That(...)`. That check doesn't call the model. Once the step is verified, the next run replays it from a cache until the screen no longer matches.

That's the split I want. The agent gets to figure the clicks out the first time. After that, the check is deterministic, and a failure means the app or the recording. A run can keep the screenshot of the attempt, and the video if you asked for one, which is the kind of artifact she listed. I can watch what the test saw.

## Some promising verification layers

There is one I haven't turned on in Puppeteer-Sharp yet. I'm putting it here because it watches the other layers.

[dotnet-slopwatch](https://github.com/Aaronontheweb/dotnet-slopwatch), by Aaron Stannard. The NuGet package is `Slopwatch.Cmd`. The README calls it LLM anti-cheat, and that name fits. It looks for the shortcuts an agent takes when it wants the other layers to go green.

It flags a skipped or ignored test, including one compiled out with `#if false` (SW001), a `#pragma warning disable` or a `SuppressMessage` (SW002), and an empty catch (SW003). In tests it flags `Task.Delay` and `Thread.Sleep` (SW004). In a project file it flags `NoWarn`, and `TreatWarningsAsErrors` set back to false (SW005), plus a central package management bypass through `VersionOverride` or an inline `Version` (SW006). Any use of `dynamic` is SW021.

Install it globally:

```bash
dotnet tool install --global Slopwatch.Cmd
```

In the repo, `slopwatch init` writes `.slopwatch/baseline.json` from whatever is already there. Commit that file, so the tool doesn't yell about the legacy you already know about. After that, `slopwatch analyze` reports only the new stuff. The CI line from the README is:

```bash
slopwatch analyze -d . --output json --fail-on error
```

That `--fail-on error` breaks the job on the error rules. Suppressions, sleeps, and `NoWarn` are warnings, so if you want those to fail CI too you pass `--fail-on warning`. There is also a Claude Code hook mode, `slopwatch analyze -d . --hook`, and that one blocks on warnings and errors while the agent is still editing.

**It checks that the agent didn't cheat the other layers.** `TreatWarningsAsErrors` stops meaning anything if the next commit turns it off. A test suite stops meaning anything if the failing test grew an `Ignore`.

## Final words

That's the list I have on November 17, 2026, and I expect it to get longer. If you run a check on a .NET repo that should be here, send it to me. A tool, an analyzer, a CI step. If it fails when the agent cheats, I want it in this post.

Don't stop coding!
