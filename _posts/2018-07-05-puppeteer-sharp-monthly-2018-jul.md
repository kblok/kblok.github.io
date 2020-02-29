---
title: Puppeteer Sharp Monthly Report - July 2018
tags: puppeteer-sharp csharp
permalink: /blog/puppeteer-sharp-monthly-jul-2018
---
 
The World Cup is here, but it didn’t stop is from releasing  [v1.1](https://github.com/kblok/puppeteer-sharp/releases/tag/v1.1) in June!
v1.1 is the first version created from a diff between two puppeteer versions: v1.0 and v1.1. This brought about some challenges, but let's talk about features first.

# New Features

The Downloader class has been improved and renamed as BrowserFetcher. Here are some of the new features:

 * `CanDownloadAsync(int revision)`, to check if a version is available
 * `LocalRevisions()`, to know which versions are ready to use locally.
 * `DownloadHost`. This property will be important for users who don't have access to Chrome servers and want to use chromium downloads hosted elsewhere.

Please note, this is a breaking change. So if you were doing this:

```cs
await Downloader.CreateDefault().DownloadRevisionAsync(chromiumRevision);
```

You should change it to :
```cs
await new BrowserFetcher().DownloadAsync(BrowserFetcher.DefaultRevision);
```

Another interesting feature is `WaitForXPath`. This will allow us to do cool stuff like this:

```cs 
await Page.SetContentAsync("<div>some text</div>");
var text = await Page.WaitForXPathAsync("//div/text()");
```

You'll be able to see a more complete [version report](https://github.com/kblok/puppeteer-sharp/releases/tag/v1.1) on GitHub.

# Missing Features :(

I'm so bummed we won't be able to include **pipes** support on Puppeteer Sharp (yet). I invested almost a week (not a full-time week of course) trying to bring pipes to life, just to find out that the way Pipes are implemented between Node and Chromium it's not supported in .NET.

I learned a lot about File Descriptors (those kind of things you only read about at College). I tried to see if the [AnonymousPipeServerStream](https://msdn.microsoft.com/en-us/library/system.io.pipes.anonymouspipeserverstream(v=vs.110).aspx) class would help us.  I even created a [question on Stack Overflow](https://stackoverflow.com/questions/50938404/c-sharp-process-using-pipes-file-descriptors), but no joy. So I ended up at the [corefx](https://github.com/dotnet/corefx) project and created the [issue 30575](https://github.com/dotnet/corefx/issues/30575), trying not to "StackOverflow" their project.
[Stephen](https://github.com/stephentoub) was super helpful. Despite the answer being a "no, it's not supported", he took the time to go through the problem and tried to understand my need. I encourage you to go and read that issue.

Don’t think that .NET is not "good enough" or "incomplete". I think that the pipe implementation on Chromium is just the result of a close collaboration between the Chromium and the Puppeteer (node.js) team, so the pipes implementation ended up having a "Node flavor".

# What's next

As I mentioned before, v1.1 was the first version created based on a diff. Before v1.1, tracking differences between Puppeteer Sharp and Puppeteer was relatively easy: We needed to implement [all the tests in the test.js file, looking at the v1.0 tag](https://github.com/GoogleChrome/puppeteer/blob/v1.0.0/test/test.js).

But now, we need to compare [two Puppeteer versions](https://github.com/kblok/puppeteer/pull/1) and see what's changed. The challenge is, of course, **not to miss a thing**. I found two approaches:

## v1.1: The diff approach

The approach we took on v1.1 was looking at the diff. We created a Pull Request from v1.1 to 1.0, we looked at changes in the test file and then we created [a project](https://github.com/kblok/puppeteer-sharp/projects/14) based on those changes.

### PROS

We see the final picture. We know all the changes we need to do on our tests.

### CONS

We don't know what changes in the libraries are related to a change in a test.

## v1.2 The commit approach

I knew that Puppeteer's devs refactored their test file and broke it into many files. So I knew that the diff approach was going to be useless at some point. So, for v1.2, we're taking a commit approach. We [compared v1.2 to v1.2](https://github.com/kblok/puppeteer/pull/2) and created a [project](https://github.com/kblok/puppeteer-sharp/projects/16) based on Puppeteer commits.

### Pros 
 
It's easy to follow. By using a commit, we can see changes to the library and the corresponding tests. This will make it easy to spot refactors.

### Cons

Using a commit approach forces our memory. When we create an issue for a commit we need to think and remember if this commit is undoing a previous commit or, making a previous issue a waste of time, e.g. I found many commits rolling up a chromium version. We also found that a test implemented in one commit was simplified in the other.

# Progress

* Google Puppeteer’s test: 447
* Puppeteer Sharp’s tests: 370 (prev. 342)

# Activity 

* Repository Stars: 139 (prev. 105) +32%
* Repository Forks: 24 (prev. 17) +58%
* Nuget downloads: 4785 (prev. 2293) +108%
* Contributors: 3

# Contributors

[Meir Blachman](https://www.twitter.com/MeirBlachman) pushed 26 PRs out of 54 and reviewed all my PRs.

[Ryan O'Neill](https://github.com/RyanONeill1970) found an [issue](https://github.com/kblok/puppeteer-sharp/issues/333) with special characters. You should always have an O'Neill on your team :)

[Ariex](https://github.com/Ariex) fixed another [issue](https://github.com/kblok/puppeteer-sharp/pull/364) related to duplicated requests on the Page class.

# Final Words

I hope we can get more users like Ryan and Ariex who not only use the library but are willing to help to improve it.
I'm stumbling upon features that are taking longer than expected. The (failed) pipes feature stole one week of my time. The [DumpIO test](https://github.com/kblok/puppeteer-sharp/pull/344) also took me more than expected.

Now I'm struggling with ["making sure chrome is closed"](https://github.com/kblok/puppeteer-sharp/issues/356). The problem there is that I have not been able to kill child processes gracefully.Although it might be complex to test, it's too important to put off. You deserve it.
So, be patient and...

Don't stop **coding**!

#### Previous Reports
 * [June 2018](https://www.hardkoded.com/blog/puppeteer-sharp-monthly-jun-2018)
 * [May 2018](https://www.hardkoded.com/blogs/puppeteer-sharp-monthly-may-2018)
 * [April 2018](https://www.hardkoded.com/blogs/puppeteer-sharp-monthly-april-2018)
 * [March 2018](https://www.hardkoded.com/blogs/puppeteer-sharp-monthly-march-2018)


