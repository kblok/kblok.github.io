---
title: Running Puppeteer-Sharp on Azure Functions
tags: puppeteer-sharp azure-functions azure docker
permalink: /blog/running-puppeteer-sharp-azure-functions
---

Let's see if we can get Puppeteer-Sharp running into an Azure Function.

Finally!!!  

![Finally](https://media2.giphy.com/media/13HdQUsXSa6QYU/giphy.gif?cid=790b7611775d3f466a85a8b08e6a669c01659359ddc1eb2c&rid=giphy.gif)

# Environment

Azure sandboxes have [some restrictions](https://github.com/projectkudu/kudu/wiki/Azure-Web-App-sandbox#pdf-generation-from-html). They also have blocked many GDI APIs. So, copying and executing a chrome.exe file in the build folder won't work.

**But**, we can [create a function using a custom docker image](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-function-linux-custom-image), and we’ve already learned [how to run puppeteer-sharp on Docker ](https://www.hardkoded.com/blog/puppeteer-sharp-docker).

![Idea](https://media1.giphy.com/media/l3mZasrfwrWUMnndS/giphy.gif?cid=790b7611ce327bb0e3f23a0d7571e481e562dcbc8c362319&rid=giphy.gif)

# Resources

I think these three posts will be super helpful:

 * [Create a function on Linux using a custom image](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-function-linux-custom-image).
 * [Azure Functions in a Docker Container](https://medium.com/faun/azure-functions-in-a-docker-container-56e625da3243) by [Matias Miguenz](https://medium.com/@miguenz.matias)
 * [How to run puppeteer-sharp on Docker ](https://www.hardkoded.com/blog/puppeteer-sharp-docker) ;)

# Prerequisites

I followed all the steps mentioned in the "[Create your first function from the command line](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-first-azure-function-azure-cli)" post.
 
# Let's get started

## Our Example 

Let's create a simple function that will receive a GitHub user as an argument and will return the activity section as an image.

![Activity](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/puppeteer-sharp-azure-functions/activity.png)

## Our Function 

First, we are going to initialize our project:

```
func init . --worker-runtime dotnet --docker
```

Notice that I added a `--docker` flag, so we get a `DockerFile` in our project.

Now, let's create a new function:

```
func new --name GitHubActivity -t HttpTrigger
```

This command will create a new `GitHubActivity` class. Let's write our code there.


```cs
[FunctionName("GitHubActivity")]
public static async Task<IActionResult> Run(
    [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
    ILogger log)
{
    log.LogInformation("C# HTTP trigger function processed a request.");

    await new BrowserFetcher().DownloadAsync(BrowserFetcher.DefaultRevision);

    string owner = req.Query["owner"];

    var contributorsPage = $"https://github.com/{owner}/";

    using (var browser = await Puppeteer.LaunchAsync(new LaunchOptions
    {
        Headless = true,
        Args = new[] { "--no-sandbox" },
        DefaultViewport = new ViewPortOptions
        {
            Width = 2000,
            Height = 800
        } 
    }))
    using (var page = await browser.NewPageAsync())
    {
        await page.GoToAsync(contributorsPage);
        await page.WaitForSelectorAsync(".graph-before-activity-overview");
        var element = await page.QuerySelectorAsync(".graph-before-activity-overview");
        var image = await element.ScreenshotDataAsync();

        return new FileContentResult(image, "image/png");
    }
}
```

Let's run the function!

```
func start
```
![Activity](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/puppeteer-sharp-azure-functions/start1.png)

![Activity](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/puppeteer-sharp-azure-functions/start2.png)

So, if we browse `http://localhost:7071/api/GitHubActivity?owner=kblok&repo=puppeteer-sharp` we should get the activity section:

![Activity](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/puppeteer-sharp-azure-functions/firstrun.png)

So far, so good. Now, as I mentioned in the introduction, chromium won't run just like that in an Azure Function. We need to dockerize it.
But before doing that. Matías tells us something important on [this post](https://medium.com/faun/azure-functions-in-a-docker-container-56e625da3243):

>First, we need to make some changes in our code. We need to change the authorization level for HttpTriger Attribute. It works fine when we are running azure functions locally, but it will return us a 401 request error when we run our Azure Function inside a Docker Container. We need to set AuthorizationLevel to Anonymous.

Let's change that in our code:
```cs
[FunctionName("GitHubActivity")]
public static async Task<IActionResult> Run(
    [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
    ILogger log)
```

Let's take a look at the DockerFile the command `func` created for us:

```
FROM microsoft/dotnet:2.2-sdk AS installer-env

COPY . /src/dotnet-function-app
RUN cd /src/dotnet-function-app && \
    mkdir -p /home/site/wwwroot && \
    dotnet publish *.csproj --output /home/site/wwwroot

FROM mcr.microsoft.com/azure-functions/dotnet:2.0
ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true

COPY --from=installer-env ["/home/site/wwwroot", "/home/site/wwwroot"]
```
So, [a few posts ago](https://www.hardkoded.com/blog/puppeteer-sharp-docker), we learned how to run Puppeteer-Sharp on Docker. What if we mix the DockerFile `func` created with our recipe?

It would be something like this:

```
FROM microsoft/dotnet:2.2-sdk AS installer-env

COPY . /src/dotnet-function-app
RUN cd /src/dotnet-function-app && \
    mkdir -p /home/site/wwwroot && \
    dotnet publish *.csproj --output /home/site/wwwroot

FROM mcr.microsoft.com/azure-functions/dotnet:2.0
ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true

COPY --from=installer-env ["/home/site/wwwroot", "/home/site/wwwroot"]

#####################
#PUPPETEER RECIPE
#####################
# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
ARG CHROME_VERSION="81.0.4044.138-1"
RUN apt-get update && apt-get -f install && apt-get -y install wget gnupg2 apt-utils
RUN wget --no-verbose -O /tmp/chrome.deb http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}_amd64.deb \
&& apt-get update \
&& apt-get install -y /tmp/chrome.deb --no-install-recommends --allow-downgrades fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf \
&& rm /tmp/chrome.deb
#####################
#END PUPPETEER RECIPE
#####################

ENV PUPPETEER_EXECUTABLE_PATH "/usr/bin/google-chrome-unstable"
```

We also know that we need to remove the browser download method, because the docker image will have a chromium installed:

```cs
//await new BrowserFetcher().DownloadAsync(BrowserFetcher.DefaultRevision);
```

Let's build  this image and run it:

```
docker build --tag hardkoded/az-function-demo:v1.0.0 .
docker run -p 8080:80 -it hardkoded/az-function-demo:v1.0.0
```

And boom!

![Activity](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/puppeteer-sharp-azure-functions/runondocker.png)

## Publish to Azure

Now, let's follow [Microsoft Tutorial](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-function-linux-custom-image#push-the-custom-image-to-docker-hub)

```
docker login --username hardkoded
docker push hardkoded/az-function-demo:v1.0.0
az group create --name azfunctiondemo --location westeurope
az storage account create --name azfunctiondemo --location westeurope --resource-group azfunctiondemo --sku Standard_LRS
az functionapp plan create --resource-group azfunctiondemo --name azfunctiondemo --location WestUS --number-of-workers 1 --sku EP1 --is-linux
az functionapp create --name azfunctiondemo --storage-account  azfunctiondemo  --resource-group azfunctiondemo --plan azfunctiondemo --deployment-container-image-name hardkoded/az-function-demo:v1.0.0
``` 

The last command got us our function's URL

```
{
  "availabilityState": "Normal",
  "clientAffinityEnabled": false,
  "clientCertEnabled": false,
  "clientCertExclusionPaths": null,
  "cloningInfo": null,
  "containerSize": 0,
  "dailyMemoryTimeQuota": 0,
  "defaultHostName": "azfunctiondemo.azurewebsites.net",
  "enabled": true,
  "enabledHostNames": [
    "azfunctiondemo.azurewebsites.net",
    "azfunctiondemo.scm.azurewebsites.net"
  ],
   ...
   ...
```

Let's see if it works...

![Drum rolls](https://media0.giphy.com/media/116seTvbXx07F6/giphy.gif?cid=790b761116db3f75d23493f3b7280bbf71cc29ebc26be25e&rid=giphy.gif)

![Activity](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/puppeteer-sharp-azure-functions/runonazure.png)

![Yes](https://media1.giphy.com/media/nXxOjZrbnbRxS/giphy.gif?cid=790b7611f5a95ee0d88a76d2158d31ab7d30fba7abdc1af8&rid=giphy.gif)

## A few things to consider

I didn't configure the app [as the tutorial says](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-function-linux-custom-image#configure-the-function-app), you should do it on a real app.

This setup uses a Premium plan. You might need to check the pricing.
![Premium](https://i.ytimg.com/vi/Xjzmjh-9ee4/maxresdefault.jpg)

# Final Words

I know this is not as easy as one new line of code, and requires some extra work, and resources, such as a Docker Account. But at least now we know that it is possible to run a Puppeteer-Sharp function on Azure Functions.

If you tried this recipe and it’s working for you, please let me know! If it doesn’t, let me know as well!

Don't stop coding!

