---
title: Creating a WhatsApp bot with Puppeteer-Sharp
tags: puppeteer-sharp csharp
permalink: /blog/creating-whatsapp-bot-puppteer-sharp
---

# Once upon a time

[Not enough friends? Get a bot!](http://www.hardkoded.com/blogs/not-enough-friends-get-a-bot) was my second post on this blog. I was learning some Machine Learning back then. I found that many devs were using [Marcovify](https://github.com/jsvine/markovify) and I thought it would be fun to create a bot to interact with my friends. But I found that it was not so simple to create a bot for WhatsApp. You need to set up a [business account](https://www.whatsapp.com/business/) and pay for it. So I built it on Telegram.

There is one problem with Telegram. **It wasn't our primary chat app**. We all love it, but we use WhatsApp...

So well, our bot was there. Hosted on my local docker, so we could go to Telegram once in a while to have fun with it.

# One guy automating VS Code

A few days ago I found a video where [Jarrod Overson](https://twitter.com/jsoverson) was automating VS Code using puppeteer! How cool is that?

<iframe width="560" height="315" src="https://www.youtube.com/embed/VDGiQ2cwFP4?start=500" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

After watching the video, I was like  
![Idea](https://media.giphy.com/media/B5AVgxf0OzlyE/giphy.gif)


>If he was able to automate VS Code because it was an electron app, I should be able to do that with the WhatsApp app.

But then I realized that:

>I don't need to hack electron. WhatsApp has a WebApp!!!

Let's get to work!

# The bot

We want to create a basic chatbot. It would wait for a **trigger word** and respond accordingly. 

Let's take a look at the WebApp.

![main page](https://github.com/kblok/kblok.github.io/raw/master/img/whatsappbot/main-whatsapp.png)

This is what we need to do:
 * Open that page.
 * Search for a Group or a Person.
 * Select that Group or Person.
 * Start listening to messages.
 * Type a message when needed.

# Exploring the page

I need to know how to search for a group, click on that group and type a message. DevTools is our best friend for this task.

![DevTools](https://github.com/kblok/kblok.github.io/raw/master/img/whatsappbot/devtools.png)

After exploring the DOM, we found that:
 * All the page is inside a `#pane-side` div.
 * The search chat has a `jN-F5` class.
 * Each person or group in the list has a `_2wP_Y` class.
 * The chat input is an editable DIV with a `_2S1VP` class.
 * The send message button has a `_35EW6` class.
 * There is a DIV containing all the messages and it has a `_9tCEa` class.
 * Each message line is a DIV with a `vW7d1` class.

# Code time!

We are going to create a regular console app, using the Puppeteer-Sharp NuGet package, of course!

First of all, let's create a class so we can put there all CSS classes we found in the previous section:

```cs 
internal class WhatsAppMetadata
{
    public const string WhatsAppURL = "https://web.whatsapp.com/";
    public const string MainPanel = "#pane-side";
    public const string SearchInput = ".jN-F5";
    public const string PersonItem = "._2wP_Y";
    public const string MessageLine = "vW7d1";
    public static string ChatContainer = "._9tCEa";
    public static string ChatInput = "._2S1VP";
    public static string SendMessageButton = "._35EW6";
}
```

Now, let's work based on the To-Do list we've made before:
 * Open the page.
 * Search for a Group or a Person.
 * Select that Group or Person.
 * Start listening to messages.
 * Type a message when needed.

## Open the page

First, we need a browser.

```cs
await new BrowserFetcher().DownloadAsync(BrowserFetcher.DefaultRevision);
_browser = await Puppeteer.LaunchAsync(new LaunchOptions
{
    UserDataDir = Path.Combine(".", "user-data-dir"),
    Headless = false
});
```

We need a `UserDataDir`, so we know where we are going to store our data (a.k.a. cookies, localStorage, etc.)
 
We are setting `Headless` in `false` mainly because we need to scan the QR code with our Phone the first time. We can set that to `true` afterward.

Now, let's navigate to the page.

```cs
_whatsAppPage = await _browser.NewPageAsync();
await _whatsAppPage.GoToAsync(WhatsAppMetadata.WhatsAppURL);
await _whatsAppPage.WaitForSelectorAsync(WhatsAppMetadata.MainPanel);
```

`.WaitForSelectorAsync(WhatsAppMetadata.MainPanel);` will wait until the WebApp is loaded, this is a good time to scan the QR code if needed.

## CommandLineParser

Before searching for a person or group, let's add the [CommanLineParser](https://github.com/commandlineparser/commandline) package. I love this package when I need to code reusable Console Apps. It will not only create an instance of a class based on the arguments but also validate all those arguments.

This is the BotArguments class:

```cs
public class BotArguments
{
    [Option('t', "trigger", Required = true, HelpText = "Trigger word.")]
    public string TriggerWord { get; set; }
    [Option('c', "chat", Required = true, HelpText = "Chat name.")]
    public string ChatName { get; set; }
    [Option('r', "response", Required = true, HelpText = "Response template.")]
    public string ResponseTemplate { get; set; }
    [Option('l', "language", Required = true, HelpText = "Language.")]
    public string Language { get; set; }
    [Option('f', "file", Required = true, HelpText = "Source text file.")]
    public string SourceText { get; set; }
}
```

This is how my `Main` method looks like:

```cs
static async Task Main(string[] args)
{
    await Parser.Default.ParseArguments<BotArguments>(args).MapResult(
        async (BotArguments result) => await LaunchProcessAsync(result),
        _ => Task.FromResult<object>(null));
}
```

Now that we have our BotArgument class let's go back to our app.

## Search for a group or person

Based on the person we got as an argument we can do this:

```cs
var input = await _whatsAppPage.QuerySelectorAsync(WhatsAppMetadata.SearchInput);
await input.TypeAsync(args.ChatName);
await _whatsAppPage.WaitForTimeoutAsync(500);
```

Pretty cool ah?
We query for an element, we type on it, and then we wait just a little bit for the DOM to be refreshed.

## Select the item

If we assume that the person we are looking for will be the first one on our list, we will know that it will be the second item on that list, because "CHATS" will be the first item.

![First Item](https://github.com/kblok/kblok.github.io/raw/master/img/whatsappbot/first-item.png)

Now that we know that, we can do:

```cs
var menuItem = (await _whatsAppPage.QuerySelectorAllAsync(WhatsAppMetadata.PersonItem)).ElementAt(1);
await menuItem.ClickAsync();
```

We query all the items on the list, and we select the second one.

## Start listening to messages

This is the fun part, and I think this something you will like to learn.
**How can we start listening to new messages?**

We will need two things:
 * A callback function on our side.
 * A DOM observer on the Browser/Javascript side with the ability to call our function.

### ExposeFunctionAsync to the rescue

`ExposeFunctionAsync` will help us register a C# function on the Chromium side.

![What?](https://media3.giphy.com/media/lsU7mOh76j4QM/giphy.gif?cid=790b76115caf2a587652616e2e96ddfa)

```cs
await _whatsAppPage.ExposeFunctionAsync("newChat", async (string text) =>
{
    Console.WriteLine(text);

    if (text.ToLower().Contains(args.TriggerWord) && !text.Contains(args.ResponseTemplate))
    {
        await RespondAsync(args, text);
    }

    text = text.Replace(args.ResponseTemplate, string.Empty);
    await File.AppendAllTextAsync(args.SourceText, text + "\n");
});
```

Done!
Now we have a function called `newChat` in Javascript.
When `newChat` is called we will:
 * Log the message.
 * Check if the message contains a trigger word.
 * Check that the message doesn't contain our response template (a.k.a. a message we just sent)
 * The last two lines are not so important now. But what they do is saving that message in a File, so we have more content to be able to create new messages. 

### Listen to new messages

If `ExposeFunctionAsync` was our best friend on the C# side, [MutatorObserver](https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver) will be our best friend on the Javascript side.

```cs
await _whatsAppPage.EvaluateFunctionAsync($@"() => {{
    var observer = new MutationObserver((mutations) => {{
        for(var mutation of mutations) {{
            if(mutation.addedNodes.length &&
               mutation.addedNodes[0].classList.value === '{WhatsAppMetadata.MessageLine}') {{
                newChat(mutation.addedNodes[0].querySelector('.copyable-text span').innerText);
            }}
        }}
    }});
    observer.observe(
        document.querySelector('{WhatsAppMetadata.ChatContainer}'),
        {{ attributes: false, childList: true, subtree: true }});
}}");
}
```

What we are doing here is observing changes on the childList of our `WhatsAppMetadata.ChatContainer` element. Inside the observer, we will filter items where the class value is our `MessageLine` const.
If we have a match, we call `newChat` sending that `innerText` to C#.

## Type a message when needed.

I found that (MarkovSharp)[https://github.com/chriscore/MarkovSharp] could help me build some responses based on a chat export I have.

Setting up `MarkupSharp` is as easy as this:

```cs
var chat = await File.ReadAllLinesAsync(args.SourceText);
_model = new StringMarkov(5);
_model.Learn(chat);
```

I hope this is not too much for a blog post, but the `RespondAsync` method would be something like this.

We will get a curated list of words from the message using [dotnet-stop-words](https://github.com/hklemp/dotnet-stop-words).
```cs
string response = null;
var words = text.RemoveStopWords(args.Language).RemovePunctuation().Replace(args.TriggerWord, string.Empty).Split(' ');
```

Now we will walk through the list of words in reverse order trying to find a valid message from our Markov model.

>The idea here is: If we get a message like "Hey this bot app is awesome". We will get [bot, app, awesome] as valid words, and we will try to make a message based on `awesome` first and then `app` and lastly `bot`.

```cs
for (var index = words.Length - 1; index >= 0; index--)
{
    response = _model.Walk(1, words[index]).First();

    if (response == words[index])
    {
        response = null;
    }
}

if (response == null)
{
    response = _model.Walk(1).First();
}
````

Once we have a "funny" message, we will send that message back.

```cs
await WriteChatAsync(args.ResponseTemplate + " " + response);
```

The method would look like this:

```cs
var chatInput = await _whatsAppPage.QuerySelectorAsync(WhatsAppMetadata.ChatInput);
await chatInput.TypeAsync(text);
await (await _whatsAppPage.QuerySelectorAsync(WhatsAppMetadata.SendMessageButton)).ClickAsync();
```

And voilà! We have our Bot!

# Wrapping up

I hope you enjoyed reading this tutorial. You will find [the repo on Github](https://github.com/kblok/WhatsAppBot).
The idea of this post was not only showing off this bot but also presenting some techniques and tools you can use to automate a browser.

Don't stop coding!
