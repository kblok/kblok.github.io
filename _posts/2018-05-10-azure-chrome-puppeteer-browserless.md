---
title: Using Chrome in Azure with Puppeteer Sharp and Browserless.io
subtitle: Connect Puppeteer Sharp to a remote Chrome from Azure
tags: puppeteer-sharp csharp
permalink: /blog/azure-chrome-puppeteer-browserless
redirect_from:
  - /blogs/azure-chrome-puppeteer-browserless
last_modified_at: 2026-09-05
---

**Still valid in 2026.** `Puppeteer.ConnectAsync` is still the API. [Browserless](https://www.browserless.io/) is still the hosted Chrome I pointed at. What changed is the hostname: their current docs use regional endpoints such as `wss://production-sfo.browserless.io?token=...` ([connection URLs](https://docs.browserless.io/overview/connection-urls)). `chrome.browserless.io` is now documented for private/enterprise fleets, not the default cloud URL.

The Telegram bot below is a 2018 proof of concept. The [Telegram.Bot](https://www.nuget.org/packages/Telegram.Bot) package API has moved on since `OnMessage` / `FileToSend`. Don't paste this into production.

If you *do* want Chrome inside Azure, I later got that working with a [custom Functions container](/blog/running-puppeteer-sharp-azure-functions). Same Chrome-in-Docker recipe as [the Docker post](/blog/puppeteer-sharp-docker).

One of the most exciting features of [Puppeteer Sharp v0.4](/blog/puppeteer-sharp-v04-is-here) is the ability to connect to remote browsers, like browserless.io. So, when I decided to write a post about using Chrome in Azure, I knew I had two options:

The first option would be something like this:

"To connect to a remote browser you need to use the ConnectAsync function:

```cs
var options = new ConnectOptions()
{
    BrowserWSEndpoint = $"wss://chrome.browserless.io?token={apikey}"
};

var browser = await Puppeteer.ConnectAsync(options);
var page = await browser.NewPageAsync();
```

The end"

The second option was a bit more interesting: A Telegram WebPhotographer.

A tele what?

# Requirements

We need to implement an Azure Function which receives a URL and returns a screenshot of that URL. This Azure function would help not only the Telegram Photographer but also any other service we want to implement.

We also want to implement a Telegram bot in .NET Core and deploy it using a Docker container. This bot would listen to screenshot requests, call our Azure Function and return that image to the client.

# Let's get started

## The Azure Function

As we won't be able to execute Chrome inside an Azure Function, we will need to use a SaaS Chrome such as browserless.io.
Once we know the URL of a Chrome instance, we can connect to this external Chrome process using the `ConnectAsync` function.

```cs
var options = new ConnectOptions()
{
    BrowserWSEndpoint = $"wss://chrome.browserless.io?token={apikey}"
};

var browser = await Puppeteer.ConnectAsync(options);
```

Our Azure function will look something like this:

```cs
namespace ScreenshotFunction
{
    public static class TakeScreenshot
    {
        [FunctionName("TakeScreenshot")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)]HttpRequest req, 
            TraceWriter log,
            Microsoft.Azure.WebJobs.ExecutionContext context)
        {
            var config = new ConfigurationBuilder()
                .SetBasePath(context.FunctionAppDirectory)
                .AddJsonFile("local.settings.json", optional: true, reloadOnChange: true)
                .AddEnvironmentVariables()
                .Build();

            string url = req.Query["url"];
            if (url == null)
            {
                return new BadRequestObjectResult("Please pass a name in the query string");
            }
            else
            {
                string apikey = config["browserlessApiKey"];
                var options = new ConnectOptions()
                {
                    BrowserWSEndpoint = $"wss://chrome.browserless.io?token={apikey}"
                };

                var browser = await Puppeteer.ConnectAsync(options);
                var page = await browser.NewPageAsync();
                
                await page.GoToAsync(url);
                var stream = await page.ScreenshotStreamAsync(new ScreenshotOptions
                {
                    FullPage = true
                });

                byte[] bytesInStream = new byte[stream.Length];
                stream.Read(bytesInStream, 0, bytesInStream.Length);
                stream.Dispose();

                await page.CloseAsync();
                browser.Disconnect();

                return new FileContentResult(bytesInStream, "image/png");
            }
        }
    }
}

```

A piece of cake!

## Creating a bot on Telegram

First, we need to create our Telegram bot. Let's chat with BotFather:

![chat](https://github.com/kblok/kblok.github.io/raw/master/img/webphotographer/CreatingABot.png)

## The console app

Implementing a Telegram bot is quite easy thanks to [Telegram.Bot](https://www.nuget.org/packages/Telegram.Bot). Let’s connect with Telegram:

```cs
private static ManualResetEvent Wait = new ManualResetEvent(false);

static void Main(string[] args)
{
    string telegramApiKey = Environment.GetEnvironmentVariable("WEBPHOTOGRAPHER_APIKEY");
    var botClient = new TelegramBotClient(telegramApiKey);

    botClient.OnMessage += BotClient_OnMessage;

    botClient.StartReceiving(Array.Empty<UpdateType>());
    Console.WriteLine("Telegram Bot Started\npress any key to exit");
    Wait.WaitOne();
    botClient.StopReceiving();
}
```

If you are wondering about the `ManualResetEvent` class; It's just a recipe to get this process alive inside a Docker container. A simple `Console.ReadLine` won't work there.

Then, on the Message event, we need to listen to URLs, call our Azure Function and send the image back to the client.

```cs
private static async void BotClient_OnMessage(object sender, Telegram.Bot.Args.MessageEventArgs e)
{
    var linkParser = new Regex(@"\b(?:https?://|www\.)\S+\b", RegexOptions.Compiled | RegexOptions.IgnoreCase);
    var bot = (TelegramBotClient)sender;
    
    if (!string.IsNullOrEmpty(e.Message.Text))
    {
        foreach (Match m in linkParser.Matches(e.Message.Text))
        {
            await bot.SendTextMessageAsync(e.Message.Chat.Id, "Prepping a screenshot for you my friend");

            var url = (m.Value.StartsWith("http") ? string.Empty : "https://") + m.Value;
            MemoryStream stream = null;

            try
            {
                var data = await new WebClient().DownloadDataTaskAsync(azureFunction + url);
                stream = new MemoryStream(data);

                await bot.SendPhotoAsync(
                    e.Message.Chat.Id,
                    new Telegram.Bot.Types.FileToSend("url", stream),
                    m.Value);
                        
            }
            catch(Exception ex)
            {
                await bot.SendTextMessageAsync(e.Message.Chat.Id, "Unable to get a screenshot for you");
            }
            finally
            {
                stream?.Close();
            }
        }
    }
}
```

## Deploy time!

There is not much to say about deploying an Azure Function: Right click, Publish, next, next, next and it will be up in Azure.

In order to deploy our Console App in Docker we’ll need these two files:

A Dockerfile file:

```
FROM microsoft/dotnet:2.0-sdk
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# copy and build everything else
COPY . ./
RUN dotnet publish -c Release -o out
ENTRYPOINT ["dotnet", "out/WebPhotographerBot.dll"]
```
And a docker-compose.yml file:

```
version: '2.1'

services:
  telegrambotfriend:
    image: telegramwebphotographer
    build: .
    environment:
      - WEBPHOTOGRAPHER_APIKEY=BOT_APIKEY
      - WEBPHOTOGRAPHER_AZUREFUNCTION=FUNCTIONENDPOINT
```

We have include the real Telegram API Key and Azure Function endpoint.

Finally, we run `docker-compose up` and we'll have our bot up and running. Let's check this out!

![demo](https://github.com/kblok/kblok.github.io/raw/master/img/webphotographer/Chat.png)

# Final Words

First of all, this is a proof of concept. Don't use this code in production!
Second, I know this solution was a little bit over-engineered. The idea was showing off how to connect to a remote Chrome instance and also playing a little bit with .NET Core and Docker.
Wrapping up, you can find this code on Github as [telegram-webphotographer](https://github.com/kblok/telegram-webphotographer), feel free to fork it and play with it.

Related: [Azure Functions with Chrome in the image](/blog/running-puppeteer-sharp-azure-functions), [Puppeteer-Sharp on Docker](/blog/puppeteer-sharp-docker), [PDF generators](/blog/pdf-generators-benchmark).

Don't stop coding!


