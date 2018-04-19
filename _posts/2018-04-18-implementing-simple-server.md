---
title: Implementing a Simple Server in .NET Core
tags: puppeteer-sharp csharp
permalink: /blogs/implementing-simple-server
---

One thing we needed to start testing [Puppeteer Sharp](https://github.com/kblok/puppeteer-sharp) was a simple web server to run a testing website. I knew the ideal scenario was something like this: Run `dotnet test`, the test would load a web server, run all tests and shut down the server. I also knew that ASP.NET Core was able to run in any process so, starting a web server inside the unit test process seemed to be easy to implement.

It wasn't.

I tried executing the web host asynchronously, but it didn’t work. I couldn’t execute it synchronously because it would lock the test execution. I also had some issues running tests using the .NET Framework (instead of Core), so I moved on. I said: "whatever, let's create a process, call the test server and keep coding Puppeteer".

```cs
private async Task StartWebServerAsync()
{
    var taskWrapper = new TaskCompletionSource<bool>();
    const int timeout = 2000;

    var build = Directory.GetCurrentDirectory().Contains("Debug") ? "Debug" : "Release";
    var webServerPath = Path.Combine(Directory.GetCurrentDirectory(), "..", "..", "..", "..",
                                        "PuppeteerSharp.TestServer");

    _webServerProcess = new Process();
    _webServerProcess.StartInfo.UseShellExecute = false;
    _webServerProcess.StartInfo.FileName = "dotnet";
    _webServerProcess.StartInfo.WorkingDirectory = webServerPath;
    _webServerProcess.StartInfo.Arguments = $"./bin/{build}/netcoreapp2.0/PuppeteerSharp.TestServer.dll";

    _webServerProcess.StartInfo.RedirectStandardOutput = true;
    _webServerProcess.StartInfo.RedirectStandardError = true;

    _webServerProcess.OutputDataReceived += (sender, e) =>
    {
        Console.WriteLine(e.Data);
        if (e.Data != null &&
            taskWrapper.Task.Status != TaskStatus.RanToCompletion &&
            //Though this is not bulletproof for the purpose of local testing
            //We assume that if the address is already in use is because we have another
            //process hosting the site
            (e.Data.Contains("Now listening on") || e.Data.Contains("ADDRINUSE")))
        {
            taskWrapper.SetResult(true);
        }
    };

    _webServerProcess.Exited += (sender, e) =>
    {
        taskWrapper.SetException(new Exception("Unable to start web server"));
    };

    Timer timer = null;
    //We have to declare the timer before initializing it because if we don't,  
    //we can't dispose it in the action created in the constructor
    timer = new Timer((state) =>
    {
        if (taskWrapper.Task.Status != TaskStatus.RanToCompletion)
        {
            taskWrapper.SetException(
                new Exception($"Timed out after {timeout} ms while trying to connect to WebServer! "));
        }
        timer.Dispose();
    }, null, timeout, 0);

    _webServerProcess.Start();
    _webServerProcess.BeginOutputReadLine();

    await taskWrapper.Task;
}
```

# First internal process

Luckily for me, [Meir Blachman](https://www.twitter.com/MeirBlachman) jumped into the project and, among many other things, he was able to [make the web host run inside the test project](https://github.com/kblok/puppeteer-sharp/pull/101). It was a great day.

Now we were starting the server with only these 4 lines:

```cs
var builder = Startup.GetWebHostBuilder();
builder.UseContentRoot(TestUtils.FindParentDirectory("PuppeteerSharp.TestServer"));
_host = builder.Build();
await _host.StartAsync();
```

Meir [wrote a simple and cool explanation](https://github.com/kblok/puppeteer-sharp/pull/101#issuecomment-378902668) in his PR.

* DllNotFoundException: Unable to load DLL 'libuv' - especially this comment. Looking at aspnet/KestrelHttpServer#1292 (comment), I realized I only needed to add the RuntimeIdentifier element.
* Adding the RuntimeIdentifier to PuppeteerSharp.Tests.csproj instead of PuppeteerSharp.TestServer.csproj
* Using netstandard 2.0 instead of netcoreapp 2.0
*Finding the PuppeteerSharp.TestServer directory from tests, since for net471 it's one directory deeper
    * net471 - PuppeteerSharp.Tests\bin\Debug\net471\win7-x64
    * netcoreapp2.0 - PuppeteerSharp.Tests\bin\Debug\netcoreapp2.0

# We need a SimpleServer

We were able to keep working on Puppeteer Sharp. We stopped getting process leaks and port locks. But Puppeteer had many tests that were intercepting requests on the server side, such as **server.setAuth**.

```js
server.setAuth('/empty.html', 'user', 'pass');
````

This was easy to implement. We created a controller and [implemented a basic HTTP authentication](https://github.com/kblok/puppeteer-sharp/blob/8c5a9e531efcc0a6eaa406489eb3092bc1fc49a3/lib/PuppeteerSharp.TestServer/Controllers/AuthenticationTestController.cs).

But then, some things became quite tricky. For instance, we needed to wait for a request on the server-side:

```js
await server.waitForRequest('/one-style.css')
```

We had to integrate the Web host **into** the test suite. We needed to be able to change the Server behavior just before some test runs.

# Let's implement a Simple Server

Again, [Meir Blachman](https://www.twitter.com/MeirBlachman) said ["We need a Simple Server"](https://github.com/kblok/puppeteer-sharp/issues/116). He ended up implementing a [really cool solution](https://github.com/Meir017/puppeteer-sharp/blob/a522f3062e53a019ed6a4c06e00c7545b610135e/lib/PuppeteerSharp.TestServer/SimpleServer.cs)

The API is simple

```cs
public class SimpleServer
{
    public static SimpleServer Create(int port, string contentRoot)
    public static SimpleServer CreateHttps(int port, string contentRoot)

    public void SetAuth(string path, string username, string password)
    public Task StartAsync()
    public async Task StopAsync()
    public void Reset()
    public void SetRoute(string path, RequestDelegate handler)
    public void SetRedirect(string from, string to)
    public async Task<T> WaitForRequest<T>(string path, Func<HttpRequest, T> selector)
    private static bool Authenticate(string username, string password, HttpContext context)
}
```

And the middleware is implemented in just a few lines:

```
.Configure(app => app.Use((context, next) =>
{
    if (_auths.TryGetValue(context.Request.Path, out var auth) && !Authenticate(auth.username, auth.password, context))
    {
        context.Response.Headers.Add("WWW-Authenticate", "Basic realm=\"Secure Area\"");
        context.Response.StatusCode = StatusCodes.Status401Unauthorized;
        return context.Response.WriteAsync("HTTP Error 401 Unauthorized: Access is denied");
    }
    if (_requestSubscribers.TryGetValue(context.Request.Path, out var subscriber))
    {
        subscriber(context.Request);
    }
    if (_routes.TryGetValue(context.Request.Path, out var handler))
    {
        return handler(context);
    }
    return next();
})
```

So now, we can do things like this:

```cs
Server.SetAuth("/empty.html", "user", "pass");

var response = await Page.GoToAsync(TestConstants.EmptyPage);
Assert.Equal(HttpStatusCode.Unauthorized, response.Status);

await Page.AuthenticateAsync(new Credentials
{
    Username = "user",
    Password = "pass"
});

response = await Page.ReloadAsync();
Assert.Equal(HttpStatusCode.OK, response.Status);
```

Or intercept a request:

```cs
await Page.SetExtraHttpHeadersAsync(new Dictionary<string, string>
{
    ["Foo"] = "Bar"
});

var headerTask = Server.WaitForRequest("/empty.html", request => request.Headers["Foo"]);
await Task.WhenAll(Page.GoToAsync(TestConstants.EmptyPage), headerTask);

Assert.Equal("Bar", headerTask.Result);
```

# Final Words

Although Simple Server is a solution created for Puppeteer's needs, 
it also demonstrates what you can do with .NET Core while implementing a simple server inside your app.

Don't stop coding.

