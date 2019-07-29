---
title: Running Puppeteer-Sharp on Docker
tags: puppeteer-sharp csharp
permalink: /blog/puppeteer-sharp-docker
---

I get many questions about running Puppeteer-Sharp on Docker. Let's see if we can get a:

![Book](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/puppeteer-sharp-docker/orly.png)

Let's take a look at the [example provided by Puppeteer](https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#running-puppeteer-in-docker) and see what we need to change there to make it work.

```
FROM node:10-slim

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# If running Docker >= 1.13.0 use docker run's --init arg to reap zombie processes, otherwise
# uncomment the following lines to have `dumb-init` as PID 1
# ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
# RUN chmod +x /usr/local/bin/dumb-init
# ENTRYPOINT ["dumb-init", "--"]

# Uncomment to skip the chromium download when installing puppeteer. If you do,
# you'll need to launch puppeteer with:
#     browser.launch({executablePath: 'google-chrome-unstable'})
# ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Install puppeteer so it's available in the container.
RUN npm i puppeteer \
    # Add user so we don't need --no-sandbox.
    # same layer as npm install to keep re-chowned files from using up several hundred MBs more space
    && groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /node_modules

# Run everything after as non-privileged user.
USER pptruser

CMD ["google-chrome-unstable"]
```

# FROM 
We need to change the base image. Instead of:

```
FROM node:10-slim
```

We will use:

```
FROM mcr.microsoft.com/dotnet/core/runtime:2.1
```
 
The minor version shouldn't matter here. We could use 2.0, 2.1 or 2.2

# Puppeteer Recipe

So this is their setup recipe:

```
# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai, and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# If running Docker >= 1.13.0 use docker run's --init arg to reap zombie processes, otherwise
# uncomment the following lines to have `dumb-init` as PID 1
# ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
# RUN chmod +x /usr/local/bin/dumb-init
# ENTRYPOINT ["dumb-init", "--"]

# Uncomment to skip the chromium download when installing puppeteer. If you do,
# you'll need to launch puppeteer with:
#     browser.launch({executablePath: 'google-chrome-unstable'})
# ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Install Puppeteer, so it's available in the container.
RUN npm i puppeteer \
    # Add user so we don't need --no-sandbox.
    # same layer as npm install to keep re-chowned files from using up several hundred MBs more space
    && groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /node_modules

# Run everything after as non-privileged user.
USER pptruser
```

Here's where all the fun begins.  If we run that setup using our Docker image we will get this:

>/bin/sh: 1: wget: not found
E: gnupg, gnupg2 and gnupg1 do not seem to be installed, but one of them is required for this operation

I found that we need this before running that setup:

```
RUN apt-get update && apt-get -f install && apt-get -y install wget gnupg2 apt-utils
```

We also need to remove some Node stuff. Let's remove the `npm i puppeteer` and `&& chown -R pptruser:pptruser /node_modules`.
That would leave our user setup like this:

```
RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser
```


Well, at least we are building our image now.

![First build](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/puppeteer-sharp-docker/first-build.png)

Notice two important things on this recipe:

## We are downloading Chrome

If we take a closer look, we can see that we are already downloading Chrome there:

>&& apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \

**We don't need to use BrowserFetcher in our app**. This is important because `BrowserFetcher` is not going to download a valid version to be used on Docker.

So, how do we tell Puppeteer-Sharp to use that Chrome?  
Easy, we can set an environment variable:

```
ENV PUPPETEER_EXECUTABLE_PATH "/usr/bin/google-chrome-unstable"
```

## We are creating a new user.

We are not going talk about the `--no-sandbox` on this post. You will find many posts on the internet about the goods and bads of this flag. You can also take a look at the [official doc](https://chromium.googlesource.com/chromium/src/+/master/docs/design/sandbox.md).

But what you need to know here, is that we have two ways of setting up your image:

### With --no-sandbox

If you are ok adding the `--no-sandbox` flag on your app, because you will browse a website you own or trust, you can remove all the user setup.

All this will be out:

```
# Add user, so we don't need --no-sandbox.
# same layer as npm install to keep re-chowned files from using up several hundred MBs more space    
RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser

# Run everything after as non-privileged user.
USER pptruser
```

And we'll need to add the `--no-sandbox` flag on our app.

```cs
var launchOptions = new LaunchOptions
{
    Headless = true,
    Args = new[]
    {
        "--no-sandbox"
    }
};
```

### Without --no-sandbox

If you don't want to use the `--no-sandbox` flag, you will need to keep the user setup. But if you try to launch Chrome you might get this error:

>Failed to move to new namespace: PID namespaces supported, Network namespace supported, but failed: errno = Operation not permitted

You will find [many](https://github.com/jessfraz/dockerfiles/issues/65), [many](https://github.com/GoogleChrome/puppeteer/issues/2668) posts talking about this.

I found the solution on [this post](https://github.com/jlund/docker-chrome-pulseaudio/issues/8#issue-166464652).
We'll need to run docker using the `--security-opt=seccomp:unconfined` 

# What else?

After doing all that setup, we need to do a normal .NET deploy to that Docker. You can copy the source code and make the publish inside the image or copy an existing publish there, just like this:

```
COPY bin/Release/netcoreapp2.1/publish/ /app/
ENTRYPOINT ["dotnet", "/app/PuppeteerSharpPdfDemo-Local.dll"]
```

# Final Solution 

This is how our new Dockerfile looks like:

```
FROM mcr.microsoft.com/dotnet/core/runtime:2.1

#####################
#PUPPETEER RECIPE
#####################
# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
RUN apt-get update && apt-get -f install && apt-get -y install wget gnupg2 apt-utils
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Add user, so we don't need --no-sandbox.
# same layer as npm install to keep re-chowned files from using up several hundred MBs more space    
RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser

# Run everything after as non-privileged user.
USER pptruser
#####################
#END PUPPETEER RECIPE
#####################

ENV PUPPETEER_EXECUTABLE_PATH "/usr/bin/google-chrome-unstable"
COPY bin/Release/netcoreapp2.1/publish/ /app/
ENTRYPOINT ["dotnet", "/app/PuppeteerSharpPdfDemo-Local.dll"]
```

# Demo

Does it work?  
Let's code that `PuppeteerSharpPdfDemo-Local` console app:

```cs
class MainClass
{
    public static async Task Main(string[] args)
    {
        using (var browser = await Puppeteer.LaunchAsync(new LaunchOptions()
        {
            Headless = true
        }))
        using (var page = await browser.NewPageAsync())
        {
            await page.GoToAsync("https://www.hardkoded.com");
            Console.WriteLine(
                await page
                    .QuerySelectorAsync(".page-subheading")
                    .EvaluateFunctionAsync<string>("el => el.innerText"));
        }
    }
}
```
Let's publish it:
```
dotnet publish PuppeteerSharpPdfDemo-Local.csproj -c Release
```

Build the docker image:

```
docker build --tag hardkoded/simple-docker-demo:v1.0.0 .
```

And run it!
```
docker run --security-opt=seccomp:unconfined -it hardkoded/simple-docker-demo:v1.0.0
````
![Magic](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/puppeteer-sharp-docker/magic.png) 
![Magic](https://media3.giphy.com/media/12NUbkX6p4xOO4/giphy.gif?cid=790b76115d3af0964552327845de62c8&rid=giphy.gif)

# Final words

I hope this post helps the community to start using Puppeteer-Sharp on Docker. I will see if I can publish these images to the Docker Repository, stay tuned! :)

Don't stop coding!