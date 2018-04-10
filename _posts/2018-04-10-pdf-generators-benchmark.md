---
title: PDF Generators benchmark - It’s competition time!
tags: puppeteer-sharp csharp
permalink: /blogs/pdf-generators-benchmark
---
 
Though there are many things left to be done on Puppeteer Sharp, I wanted to perform the first benchmark and see how Puppeteer Sharp is performing so far.

Generating PDF files was the reason why I started working on Puppeteer Sharp. Most PDF generator libraries don’t support javascript and results are not good at all in real-world scenarios. I ended up using [wkhtmltopdf](https://wkhtmltopdf.org/), which is pretty cool but it has a few disadvantages. First, it's a black box. If something is being rendered differently (compared to other WebKit browsers) you don’t have an easy way to solve it. You have to tweak your CSS code and run the process until you get the result you want. And second, the API is very limited and there is not much you can do to manipulate the rendering process.

But, in order to say that Puppeteer (the Node version or Puppeteer sharp) is better than wkhtmltopdf, we need to prove 3 things: It’s faster, it produces a pdf of the same or better quality and it’s easier to use.

# The Scenario

In order to try to make this benchmark as fair as possible, I looked for a real-world HTML page, with CSS, images, and javascript. Then, I downloaded it to be run locally so the test didn’t depend on the network status. I found that the homepage of my website was a good example. :p

Each test generates 10 PDF fields and will be run 5 times.

# The profiler

I wanted to be able to run a process X times and then get the fastest, slowest, average and the standard deviation, something like [wrk](https://github.com/wg/wrk) but for Windows processes. As I didn’t find any tool to help me, I coded my own; a [Tiny process profiler](https://github.com/kblok/TinyProcessProfiler). The idea is simple: run any process a pre-determined number of times, save the elapsed time of each run in a list and then show some stats.

# Environment

These tests were run on a DELL XPS 15
 * 7th Generation Intel® Core™ i7-7700HQ Quad Core Processor
 * Windows 10 Pro 64-bit 
 * 16GB, 2400MHz, DDR4
 * 512GB PCIe Solid State Drive

# Result

| Tool | Fastest Run | Slowest Run | Avg Run | Standard Deviation |
| ---- | ---------: | | ---------: | | ---------: | | ---------: |
| wkhtmltopdf | 18.725 | 19.880 | 19.170 | 0.5477 |
| Puppeteer Node JS | 7.673 | 8.20 | 7.838 | 0.4472 |
| Puppeteer Sharp | **7.285** | **7.457** | **7.602** | 0.4472 |

_All values in seconds_

# Final Words

### Quality

Unlike Puppeteer (Node and Sharp), wkhtmltopdf doesn’t honor [media print](https://www.w3schools.com/css/css3_mediaqueries.asp). This could be good or bad depending on your needs. A PDF file created by Puppeteer would be more like the PDF generated when you print a page to PDF in Chrome, whereas it would look more like a screenshot in wkhtmltopdf.

### Speed

Puppeteer proved to be way faster; three times faster according to my tests. Puppeteer Sharp and Puppeteer have pretty much the same performance

### API

Puppeteer (Node and Sharp) has a richer API than wkhtmltopdf. Though I used  a process call to execute wkhtmltopdf there are many wrappers around wkhtmltopdf, such as [the one coded by codaxy](https://github.com/codaxy/wkhtmltopdf), but all of them are limited to the small API the process itself exposes

This [benchmark](https://github.com/kblok/PdfGeneratorsBenchmark) is on Github, and also the [TinyProcessProfiler](https://github.com/kblok/TinyProcessProfiler). Issues and Pull Request are opened for comments and feedback.

Don’t stop coding!

