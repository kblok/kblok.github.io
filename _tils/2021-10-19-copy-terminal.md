---
title: TIL - How to copy a terminal output to the clipboard?
tags: til, git
permalink: /til/terminal-to-clipboard/
layout: post
comments: true
social-share: true
---

Do you want to copy a terminal output to the clipboard? You can do it by piping the command to the `pbcopy` command:

```
pwd | pbcopy
```

This will copy the current directory to the clipboard.
