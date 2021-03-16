---
title: How to reset viewed files on GitHub
tags: til
permalink: /til/how-to-reset-viewed-files
layout: post
comments: true
social-share: true
---

If you want to uncheck all viewed files... well, uncheck them using JavaScript

```
document.querySelectorAll('.js-reviewed-checkbox').forEach(c => c.checked ? c.click() : null)
```