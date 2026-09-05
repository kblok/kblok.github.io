---
layout: default
title: Home
---

<img class="landing-logo" src="{{ '/img/avatar-icon.png' | relative_url }}" alt="Darío Kondratiuk" width="160" height="160">

Dev notes from the maintainer of [Puppeteer-Sharp](https://github.com/hardkoded/puppeteer-sharp). I write about browser automation, .NET, and teaching computers to do the boring parts.

## Recent posts

<ol class="landing-posts">
{% for post in site.posts limit:3 %}
  <li>
    <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%b %-d, %Y" }}</time>
    <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    {% if post.subtitle %}<span class="landing-posts-sub">{{ post.subtitle }}</span>{% endif %}
  </li>
{% endfor %}
</ol>

<p class="landing-more"><a href="{{ '/archive/' | relative_url }}">All posts →</a></p>

## Projects

<p class="message">
  <strong><a href="https://github.com/hardkoded/puppeteer-sharp">Puppeteer-Sharp</a></strong> is a C# port of Google’s Puppeteer — a headless Chrome API for .NET. 36M+ NuGet downloads, still shipping. That’s the flagship. Everything else on this site is notes from building it, porting Playwright, and the agents that came after.
</p>

<ul class="project-list">
  <li>
    <a href="https://github.com/microsoft/playwright-dotnet">Playwright for .NET</a>
    <span>Started as Playwright-Sharp. Went to Microsoft and became the official library.</span>
  </li>
  <li>
    <a href="https://www.amazon.com/Testing-Puppeteer-end-end-automation/dp/180020678X">UI Testing with Puppeteer</a>
    <span>The book. End-to-end automation with the real browser.</span>
  </li>
  <li>
    <a href="https://github.com/hardkoded/cronito">cronito</a>
    <span>A small tool for scheduling work with coding agents.</span>
  </li>
</ul>

## About

I'm [Darío Kondratiuk]({{ '/aboutme/' | relative_url }}), a software developer from Buenos Aires. 25 years teaching computers how to use the software we write — ORMs, browser automation, now AI agents that author and repair tests at [mabl](https://www.mabl.com).

<p class="landing-more"><a href="{{ '/aboutme/' | relative_url }}">More about me →</a></p>
