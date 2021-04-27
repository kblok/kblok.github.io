---
title: TIL - How to delete all branches that are not in the remote repo
tags: til, git
permalink: /til/how-to-delete-all-branches-not-in-upstream
layout: post
comments: true
social-share: true
---

You tried all the possible combinations of `prune`, you still have branches you want to kill. Try this:

```
git branch --v | grep "\[gone\]" | awk '{print $1}' | xargs git branch -D
```

If you don't trust me, don't worry, I don't trust myself either. Just remove the ```| xargs git branch -D```, and the script will only print the result.