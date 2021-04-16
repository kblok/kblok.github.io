---
title: How to delete all branches but one
tags: til, git
permalink: /til/how-to-delete-all-branches
layout: post
comments: true
social-share: true
---

Sometimes it's time to start over. This script will delete all git branches but one called `develop`.

```
git branch --v | grep "develop" -v | awk '{print $1}' | xargs git branch -D
```

If you don't trust me, don't worry, I don't trust myself either. Just remove the ` | xargs git branch -D` and the script will only print the result.