---
title: TIL - How to kill a process locking a port in MacOS
tags: til, macos
permalink: /til/how-to-kill-a-process-using-a-port
layout: post
comments: true
social-share: true
---

If I'm going to Google every time I need to kill a process locking a port let's at least get to my site

```
lsof -ti:8081 | xargs kill
```