---
title: Playwright Sharp Monthly Report - December 2020
tags: playwright-sharp csharp
permalink: /blog/playwright-sharp-monthly-dec-2020
---

Wait, What happened with the November report? Well, well, November was a fun month. But here we are in the December report.

# Important Notice.

![alert](https://media0.giphy.com/media/Tdpbuz8KP0EpQfJR3T/giphy.gif?cid=ecf05e47pxmt5k97tbs7thqlrt0vus4sgbip66o3mj4u2fe1&rid=giphy.gif)

As you might know, [Playwright sharp is now part of the Microsoft family](https://www.hardkoded.com/blog/playwright-sharp-joins-microsoft). So you should read these reports as unofficial reports. I will share here, what I was working on, what cool stuff I learned, and how I'm going to contribute to the project in the next month. I will use that line that we see quite often in Twitter bios: Opinions are my own.

Too much talk. Let's got to the fun part.
 
# What's new

Since the last report, we got two new versions: [v0.151.0](https://github.com/microsoft/playwright-sharp/releases/tag/v0.151.0), [v0.152.0](https://github.com/microsoft/playwright-sharp/releases/tag/v0.152.0), and [v0.162.0](https://github.com/microsoft/playwright-sharp/releases/tag/v0.162.0).
If you read [my previous report](https://www.hardkoded.com/blog/playwright-sharp-monthly-oct-2020), you will know that those versions map the versions v1.5.1, v1.5.2, and 1.6.2, respectively.

PlaywrightSharp now offers some pretty cool new features, such as **Video Screencasts**, **HAR recording**,  **WebSockets inspection** and **Tap support** on mobile emulation.
Do you want to take a look at these new features? Comment this post with the feature you'd like to see, and I'll create a post just for you, well, for everybody.

# Driver and browser install refactor

PlaywrightSharp has two big dependencies: The playwright driver, a bundled Node.JS app with all the playwright logic, and the browsers used to perform the automation.  
We have one driver for each platform: OSX, Linux, Win64, and Win32. And we have three browsers: Chromium, Firefox, and WebKit, which are also platform-specific.  

## The first approach

The first approach was to embed the drivers inside the dll. When you call `Playwright.CreateAsync`. We would extract the driver for your platform and copy it to your bin folder.
Then you would need to call `Playwright.InstallAsync` to install the browsers if required.

This approach had a few downsides. 
First, We were shipping 60MB DLL files. We could say: "ok, but we need those drivers". But you needed only the driver for your platform, not all the drivers. This approach also prevented us from shipping platform-specific libraries, e.g., for .NET 5.
Second, we were writing files in runtime. That's not ideal. We have the risk of not being able to write to disk in some scenarios.
Last, we were doing install tasks in runtime, in production. `Playwright.InstallAsync` would cause the first call to your app to take a few minutes to download all the browsers. Not ideal at all.

We tried to remove the need for the `InstallAsync` task with a dotnet tool. It did the work. The potential problem there is that the dotnet tool was downloading the browsers for the version referenced in the tool, which might not be the same as the version needed for your app.

There should be a better way.

![better way](https://media1.giphy.com/media/Ns1zcDF7zA4co/giphy.gif?cid=ecf05e47qt5hckevtj1lf40bbqt81ha7xir8pvaj0aj6l11h&rid=giphy.gif)

## A new approach

v0.162.0 relies now on two features:
Nuget runtimes folder.
Custom Build targets.

Nuget has something called [architecture-specific folders](https://docs.microsoft.com/en-us/nuget/create-packages/supporting-multiple-target-frameworks?WT.mc_id=DT-MVP-5003814#architecture-specific-folders).

> If you have architecture-specific assemblies, that is, separate assemblies that target ARM, x86, and x64, you must place them in a folder named runtimes within sub-folders named {platform}-{architecture}\lib\{framework} or {platform}-{architecture}\native.

So now, instead of embedding the drivers into the DLL, we are shipping those inside the runtimes folder:

```
\runtimes 
    \osx
        \native 
    \unix
        \native 
    \win-x64
        \native 
    \win-x86
        \native 
```

So now, Nuget will add a build task to copy those files depending on the [RuntimeIdentifier](https://docs.microsoft.com/en-us/dotnet/core/project-sdk/msbuild-props?WT.mc_id=DT-MVP-5003814#runtimeidentifier) or on the [runtime used on dotnet publish](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-publish?WT.mc_id=DT-MVP-5003814).  
If you don't have a RuntimeIdentifer and don't use the publish command (this would be a typical unit test scenario), all the drivers will be copied under a `runtimes` folder. We needed to do an extra check in the code. If we find the `playwright-cli` in the current directory, we use it; if not, we try to go to the `runtimes` folder, looking for a platform-specific driver.

That gives us a PlaywrightSharp.dll file of only 500kb, which would allow us to ship multi-target binaries, e.g., for .NET 5. And we remove the need for writing files at runtime.

I also learn that you can [add targets inside Nuget packages](https://docs.microsoft.com/en-us/nuget/create-packages/creating-a-package?WT.mc_id=DT-MVP-5003814#include-msbuild-props-and-targets-in-a-package). That means that you can inject your own tasks into the build process.

![hacker](https://media2.giphy.com/media/YQitE4YNQNahy/giphy.gif?cid=ecf05e47je5sy622q1yar960f2r1cv0lbilasndalwin4w9i&rid=giphy.gif)

I create two targets that will run as part of your build process. The first task will run `playwright-cli install` command, installing the required browsers. At build time :o

```
 <Target Name="InstallBrowsers" AfterTargets="CopyFilesToOutputDirectory">
     <Message Text="Playwright is checking browser dependencies">
     </Message>
     <Exec Condition="$([MSBuild]::IsOSPlatform('Linux'))" WorkingDirectory="$(MSBuildThisFileDirectory)..\..\runtimes\unix$(NativeFolder)" Command="./playwright-cli install" />
     <Exec Condition="$([MSBuild]::IsOSPlatform('OSX'))" WorkingDirectory="$(MSBuildThisFileDirectory)..\..\runtimes\osx$(NativeFolder)" Command="./playwright-cli install" />
     <Exec Condition="'$(PlatformTarget)' != 'x86' AND $([MSBuild]::IsOSPlatform('Windows'))" WorkingDirectory="$(MSBuildThisFileDirectory)\..\..\runtimes\win-x64$(NativeFolder)" Command="playwright-cli.exe install" />
     <Exec Condition="'$(PlatformTarget)' == 'x86' AND $([MSBuild]::IsOSPlatform('Windows'))" WorkingDirectory="$(MSBuildThisFileDirectory)\..\..\runtimes\win-x89$(NativeFolder)" Command="playwright-cli.exe install" />
 </Target>
```

The second target is relatively new. It will copy the drivers if you try to use Playwright inside a Xamarin.Mac application.

```
 <Target Name="CopyPlaywrightDriversToMonoBundle" AfterTargets="CopyFilesToOutputDirectory" Condition="$(TargetFrameworkIdentifier) == 'Xamarin.Mac'">
     <Message Text="Copy drivers to MonoBundle" />
     <CreateItem Include="$(MSBuildThisFileDirectory)\..\..\runtimes\osx\native\*.*">
         <Output TaskParameter="Include" ItemName="PlaywrightDriverFiles" />
     </CreateItem>
     <Message Text="$(AppBundleDir)" />
     <Message Text="@(PlaywrightDriverFiles)" />
     <Copy SourceFiles="@(PlaywrightDriverFiles)" DestinationFolder="$(AppBundleDir)/Contents/MonoBundle/" />
 </Target>
```

## Shipping process 

We are removing the need for the `InstallAsync` method call in your code with these changes.
If you are using PlaywrightSharp for testing, you are getting the browsers at build time.
If you are using PlaywrightSharp in Docker, you will get the browser for free if you use an [official Docker image](https://hub.docker.com/_/microsoft-playwright).
If you are shipping it to a custom server, you will get the `playwright-cli` binary in your bin folder. You just need to run `.\bin\playwright-cli.exe install` in Windows or `./bin/playwright-cli install` in OSX/Linux as part of your deploy script.

I hope all these changes remove some barriers and deploy issues that some users were having.

# Bonus track

As we now have the driver in our `bin` folder, we can use the C# code generator that comes with the CLI.


![what](https://media0.giphy.com/media/lsU7mOh76j4QM/giphy.gif?cid=ecf05e47zomi5klflcf6e732w0l4ecbihlip83gppnsmr2gt&rid=giphy.gif)

If you go to the `bin` folder, you can run this command:

```
./playwright-cli codegen --target=csharp
```

And voilà!

![code gen](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/report-dec-2020/codegen.gif)

I hope you enjoy this new tool. It's still quite raw. But we'll get better.

# Activity

 * Repository Stars: 250 (prev 165) +51%
 * Repository Forks: 26 (prev 14) +85%
 * Nuget downloads: 2878

 
# Final words

I'm looking forward to getting more feedback. The issues tab in GitHub is open for all of you to share your ideas and thoughts.  
Don't forget to follow me on Twitter [@hardkoded](https://twitter.com/hardkoded) to get more updates.

Don't stop coding!

#### Previous Reports
 * [Oct 2020](https://www.hardkoded.com/blog/playwright-sharp-monthly-oct-2020)
 * [Sep 2020](https://www.hardkoded.com/blog/playwright-sharp-monthly-sep-2020)
 * [Jul 2020](https://www.hardkoded.com/blog/playwright-sharp-monthly-jul-2020)
 * [Jun 2020](https://www.hardkoded.com/blog/playwright-sharp-monthly-jun-2020)
 * [May 2020](https://www.hardkoded.com/blog/playwright-sharp-monthly-may-2020)
 * [April 2020](https://www.hardkoded.com/blog/playwright-sharp-monthly-apr-2020)
 * [March 2020](https://www.hardkoded.com/blog/playwright-sharp-monthly-march-2020)
 
