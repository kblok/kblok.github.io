---
title: Pushing your Docker images to Docker Hub
tags: puppeteer-sharp docker
permalink: /blog/pushing-to-docker
---

In my [previous post](https://www.hardkoded.com/blog/puppeteer-sharp-docker) we created an image to get Puppeteer-Sharp running on Docker. Let's see if we can publish that image to Docker Hub and make that image available to the community.

I already have a [user on Docker Hub](https://hub.docker.com/u/hardkoded), so I bet the first step is done.

![First step](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/pushing-to-docker/1.png)

I want to create one repository with two tags:
 * `puppeteer-sharp-base:1.0`
*  `puppeteer-sharp-base:1.0-sandboxed`

If we go to the [Create Repository](https://cloud.docker.com/repository/create) page, we can see that we should be able to create a Github repository and make Docker build our images from there. We LOVE that kind of stuff, don't we?

![Second step](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/pushing-to-docker/2.png)

So let's create our repo!

![Third step](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/pushing-to-docker/3.png)

I'm going to commit there two images:

 * A base image without the user creation.
 * A sandboxed image, which will start from the base image and it create the user after that. I will put this file inside a "sandboxed" folder.

![Fourth step](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/pushing-to-docker/4.png)

Time to go back to Docker Hub...

We are going to create two sets of builds:
 
 * One for the latest version, using the master branch.
 * One for tagged versions.

And we are going to build two images:
 * puppeteer-sharp-base:`<version>`
 * puppeteer-sharp-base:`<version>`-sandboxed

![Fifth step](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/pushing-to-docker/5.png)

Let's Create and Build!

![Sixth step](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/pushing-to-docker/6.png)

Now, we can create a 1.0 release on Github.

![Seventhh step](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/pushing-to-docker/7.png)

And voilà! We have a v1.0 on Docker!

![Eight step](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/pushing-to-docker/8.png)

Finally, the moment of truth, let's see if I can replace all the code I had y my previous Dockerfile and replace it only with the new image.

```
FROM hardkoded/puppeteer-sharp-base:latest

COPY bin/Release/netcoreapp2.1/publish/ /app/
ENTRYPOINT ["dotnet", "/app/PuppeteerSharpPdfDemo-Local.dll"]
```

Boom! We have our new image working!

![Ninth step](https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/pushing-to-docker/9.png)

![Celebration](https://media2.giphy.com/media/3o8doT9BL7dgtolp7O/giphy.gif?cid=ecf05e47466ea3c4637d81e4575ee127d7e94f854c1c9c11&rid=giphy.gif)


## Final Words

I hope this journey can help you to setup your own images, and also to start using Puppeteer-Sharp on Docker.
As you can see, I'm not a Docker expert. If you are, and you found something off on my post, please let me know!

Don't stop coding!