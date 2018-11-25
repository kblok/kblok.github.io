---
title: Creating a site for your project using DocFX
tags: docfx dotnet
permalink: /blog/creating-docfx-site
---
_A real-time journey_

# Motivation 

Many tutorials explain how to achieve some task by going through a list of steps. **Assuming that you share the same context as the author, and most importantly, assuming you succeed in executing every single step**.

So I wanted to share with you a real-time(ish) post, explaining how I created a site using [DocFx](https://dotnet.github.io/docfx/). Our context will be different of course, but I hope I can help you set up your site by explaining the right steps to follow and exposing the roadblocks you might stumble upon.

# Introduction

We have documented all the code on [Puppeteer-Sharp](https://github.com/kblok/puppeteer-sharp/) using [XML Documentation Comments](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/xmldoc/xml-documentation-comments), and we want to create a site using [DocFX](https://dotnet.github.io/docfx/) and [Github Pages](https://pages.github.com/). Finally, we want to make it available on http://www.puppeteer-sharp.com.

# What do we know?

 * We know that we need to tell the dotnet compiler to generate an XML file with the documentation. [We are already doing that](https://github.com/kblok/puppeteer-sharp/blob/master/lib/PuppeteerSharp/PuppeteerSharp.csproj#L67).
* We know we want to use [DocFX].(https://dotnet.github.io/docfx/tutorial/walkthrough/walkthrough_create_a_docfx_project.html)
* We want it to be an automatic step in our CI.

# Pomodoro 1 - Setup

As we need to run CI builds many times and we don't want to mess with Puppeteer's repo, let's create a new repo so we can play with it. [docfx-playground](https://github.com/kblok/docfx-playground) sounds like a pretty ~~cool~~ decent name.

![Repo Image](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/docfx-tutorial/1_repo.png)

We also need to set up a CI for this new project.
![App Veyor](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/docfx-tutorial/2_appveyor.png)

Now, let's copy our P# (yes, I call Puppeteer-Sharp, P#) to this new repo.

## DocFX

Now, we need two folders:

* We know that DocFX will need a folder for its project. A `docfx_project` folder.
* We also know it will try to generate the site using a `_site`  folder, but as we know that [Github Pages will look for a docs folder](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/), we'll generate our site there.

## docfx_project

If we run `docfx init` it should create a docfx_folder into our project
 
>docfx init -q

![Dcofx](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/docfx-tutorial/3_docfxproject.png)

Awesome!

Now, we just need to set the project location in the `docfx.json` file:

```
"metadata": [
    {
      "src": [
        {
          "cwd": "../",
          "files": [
            "lib/PuppeteerSharp/**.csproj"
          ]
        }
      ],
      "dest": "api",
      "disableGitFeatures": false
    }
  ],
```

Fair enough. Now if we call `docfx metadata` it should do... something...

>docfx metadata docfx_project/docfx.json 

BOOM!
![DocFx metadata](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/docfx-tutorial/4_docfx_metadata.png)

I don't know what those files are yet. But it is something.
Let's try to build the site.

>docfx build docfx_project/docfx.json -o docs 

Well... it could have been worse. First, it created a `_sites` folder under my `docs` folder. I didn't mean to do that by setting the output `docs`.
Then... well the Home page and the API index page could have had more links connecting the new pages.

_Site Home_
![First Home](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/docfx-tutorial/5_first_home.png)
_API Home page_
![FirstAPI](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/docfx-tutorial/6_first_api.png)
_Some doc page_
![Doc Page](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/docfx-tutorial/7_first_doc.png)

#### End of Pomodoro 1

## Pomodoro 2 -  Shaping the DocFx site

In order to get rid of the `_sites` folder, we need to change the `dest` property in the `docfx.json` file.

>"dest": "."

Perfect, now our site is using the `docs` folder.
Now let's try to improve the site a little bit:
 * I'll work in some style stuff.
 * Add some content to the home page.
 * See how to get links to the API.

I thought this was going to be a missed Pomodoro. But it turns out that you need to call `docfx serve` in order to get the site in good shape!

>docfx serve

![Good API Page](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/docfx-tutorial/8_first_good_api.png)

#### End of Pomodoro 2

## Pomodoro 3 - GitHub Pages and AppVeyor

Ok, we have a site running. Let's push it and setup Github Pages.

![Githubpage](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/docfx-tutorial/9_set_github_page.png)

And we have a site!

![Site](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/docfx-tutorial/10_first_site.png)

Though there are many things to improve here, let's move on to AppVeyor. The idea is simple:
 * We need to build docfx only when a Tag (release) is created.
 * We also need to update the DocFx metadata and the site.
 * Finally, we need to push that back to the repo.

So, AppVeyor has a [great document](https://www.appveyor.com/docs/how-to/git-push/) to help us setup git, so we can push content back to the repo. So basically we need to [setup a personal access token on GitHub](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/), encrypt it, and use it in our script. The git setup section looks something like this:

```
- git config --global credential.helper store
- Add-Content "$HOME\.git-credentials" "https://$($env:git_access_token):x-oauth-basic@github.com`n"
- git config --global user.email "dariokondratiuk@gmail.com"
- git config --global user.name "Darío Kondratiuk"
```

Then we generate the documentation:

```
- docfx metadata docfx_project/docfx.json
- docfx build docfx_project/docfx.json -o docs
```

And finally, we commit that back to the repo.
```
- git checkout master
- git add docfx_project/*
- git add docs/*
- git commit -m "Docs for"
- git push origin
```

Ouch... I'm getting this error from DocFx
>[18-06-08 12:17:14.994]Warning:ExtractMetadata(C:/projects/docfx-playground/lib/PuppeteerSharp/PuppeteerSharp.csproj)Workspace failed with: [Failure] Msbuild failed when processing the file 'C:\projects\docfx-playground\lib\PuppeteerSharp\PuppeteerSharp.csproj' with message: C:\Program Files\dotnet\sdk\2.1.300\Sdks\Microsoft.NET.Sdk\targets\Microsoft.NET.GenerateAssemblyInfo.targets: (161, 5): The "GetAssemblyVersion" task failed unexpectedly.

And this error when I try to push back to GitHub:

>fatal: unable to access 'https://github.com/kblok/docfx-playground.git/': The requested URL returned error: 403
550

#### End of Pomodoro 3
 
## Pomodoro 4 - gh-pages branch

Change of plans! I found an [article on Github](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/) which mentions that you can publish a Github Page using a branch called `gh-page`. That's great because **docfx commits won't mess with my master branch**, and also **I will be able to keep my [master branch protected](https://help.github.com/articles/configuring-protected-branches/)**. 

I found [this gist](https://gist.github.com/ramnathv/2227408) with a script to create an empty `gh-pages` branch. 

```
cd /path/to/repo-name
git symbolic-ref HEAD refs/heads/gh-pages
rm .git/index
git clean -fdx
echo "My GitHub Page" > index.html
git add .
git commit -a -m "First pages commit"
git push origin gh-pages
```

Awesome! Now we have an empty `gh-pages` branch.
Let's go back to our AppVeyor code. In order to be able to push to GitHub, we need to add `https` to our remote.

```
git remote add pages https://github.com/kblok/docfx-playground.git
``` 

And then we'll use `git subtree push` to push our site to our new remote branch.

```
git subtree push --prefix docs pages gh-pages
```

Ok, now I'm getting this on AppVeyor
```
"GetAssemblyVersion" task failed unexpectedly.
331System.NullReferenceException: Object reference not set to an instance of an object.
```

#### End of Pomodoro 4 :(

# Pomodoro 5 - Git subtree

[This post](https://dev.to/letsbsocial1/deploying-to-gh-pages-with-git-subtree) showed me that I had to register the subtree first before doing a `git subtree push`.

```
git subtree add --prefix docs gh-pages
```

I also learned that after creating a subtree you need to commit and push that subtree:

```
git checkout master
git subtree add --prefix docs gh-pages
docfx metadata docfx_project/docfx.json
docfx build docfx_project/docfx.json -o docs
git add docs/
git commit -m "Docs"
git subtree push --prefix docs pages gh-pages
```

But the push command is stuck :(

#### End of Pomodoro 5

# Pomodoro 6 - Setting up a GitHub Access Token

I found [a good script](https://github.com/dustinchilson/dustinchilson.com/blob/master/_tools/before_build.ps1) to setup git.

So the 403 error while trying to push to Github was because I had to check the "Repo" option when I created the Token.

![Repo check](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/docfx-tutorial/11_repo_check.png)

And I just learned that this is the right way to register the subtree

```
git subtree add --prefix docs pages/gh-pages
```

And we are done! Now we just need to wrap all this into an if block so the documentation is only updated when we create a new Tag/Release from GitHub.

So this is what the final git script would look like

```
if($env:APPVEYOR_REPO_TAG -eq 'True'){
    git config --global credential.helper store
    Add-Content "$env:USERPROFILE\.git-credentials" "https://$($env:git_access_token):x-oauth-basic@github.com`n"

    git config --global user.email "dariokondratiuk@gmail.com"
    git config --global user.name "Darío Kondratiuk"
    git remote add pages https://github.com/kblok/docfx-playground.git
    git fetch pages
    git checkout master
    git subtree add --prefix docs pages/gh-pages
   docfx metadata docfx_project/docfx.json
   docfx build docfx_project/docfx.json -o docs
    git add docs/* -f
    git commit -m "Docs build $($env:APPVEYOR_BUILD_VERSION)"
    git subtree push --prefix docs pages gh-pages
}
```
Now we setup our custom domain and we are ready to go!

![Setup domain](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/docfx-tutorial/12_setup_domain.png)

Oh, If you were wondering about this DocFx error:
>[18-06-08 12:17:14.994]Warning:[ExtractMetadata](C:/projects/docfx-playground/lib/PuppeteerSharp/PuppeteerSharp.csproj)Workspace failed with: [Failure] Msbuild failed when processing the file 'C:\projects\docfx-playground\lib\PuppeteerSharp\PuppeteerSharp.csproj' with message: C:\Program Files\dotnet\sdk\2.1.300\Sdks\Microsoft.NET.Sdk\targets\Microsoft.NET.GenerateAssemblyInfo.targets: (161, 5): The "GetAssemblyVersion" task failed unexpectedly.

It turns out that the metadata is being generated despite getting that.

#### End of Pomodoro 6

# Final words

This was a fun journey although a little bit longer than I expected. Though six Pomodoros are only two hours and a half, I only invested one Pomodoro per day for this task so my head was spinning on this for almost a week.
I hope this post helps you to go through this process and makes your life easier.

Don't stop coding!


