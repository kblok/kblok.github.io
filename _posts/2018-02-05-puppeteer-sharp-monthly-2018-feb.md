---
title: Puppeteer Sharp Monthly Report - February 2018
tags: puppeteer-sharp csharp
permalink: /blogs/puppeteer-sharp-monthly-february-2018
---
 
# Introduction

Welcome to the first Puppeteer Sharp monthly digest. I hope this is the first of many to come.
As this is the first digest, I need to explain the current status and the roadmap I have planned.

# Current status

Turning that first test green is harder than it sounds. The first test is about browsing a page while ignoring HTTPS errors. But before browsing a page we need to create a browser process; start a WebSocket; implement messaging between puppeteer-sharp; among other things.

So, the current status is: ~~I'm almost there.~~ The first test is green!

Puppeteer Sharp is now able to:
 * Start a chromium process.
 * Start a WebSocket.
 * Send/Receive messages using that WebSocket.
 * Load a FrameManager.
 * Load an EmulationManager.
 * Build a response.
 * Close the browser gracefully.

# Roadmap
Getting to all the 523 tests Puppeteer has, will be a long and fun journey. So, this will be the roadmap for Puppeteer Sharp 1.0:

## 0.1 First Minimum Viable Product
The first 0.1 will include:
* Browser download
* Basic browser operations: create a browser, a page and navigate a page.
* Take screenshots.
* Print to PDF.

## 0.2 Repository cleanup
This version won't include a new version. It will be about improving the repository:

* Setup CI.
* Create basic documentation (Readme, contributing, code of conduct).

## 0.3 Puppeteer
It will implement all [Puppeteer related tests](https://github.com/GoogleChrome/puppeteer/blob/master/test/test.js#L108)

## 0.4 Page
It will implement all Page tests except the ones testing the evaluate method.
As this will be quite a big version, I think we will publish many 0.3.X versions before 0.4.

## 0.5 Frames
It will implement all Frame tests.

## 0.6 Simple interactions
It will implement all the test related to setting values to inputs and clicking on elements.

## 0.X Intermediate versions

At this point, We will have implemented most features, except the ones which are javascript related.
I believe there will be many versions between 0.6 and 1.0.

## 1.0 Puppeteer the world!
The 1.0 version will have all (or most) Puppeteer features implemented. I don't know if we'll be able to cover 100% of Puppeteer features, due to differences between both technologies, but we'll do our best.

# Progress

Let's talk about hard numbers. These numbers don't sound exciting now, but I hope we can see them grow month after month.

* Tests on Google's Puppeteer: 523
* Tests on Puppeteer Sharp: 1
* Passing tests: 1

I know, this sounds pretty lame, but we will get there.

# Activity

If we talk about user activity, these are the hard numbers:

* Repository Stars: 11.
* Repository Forks: 2.
* Nuget downloads: 114.

# Wrapping up

If you want to contribute to this project you are welcome!
I won't accept code contributions to the library before version 0.3 because the code is still taking shape, and because I will create the contributing document in version 0.2. However, you are welcome to start writing tests. We have 523 tests to code!
If you are interested, reach out to me on twitter, or by email.



