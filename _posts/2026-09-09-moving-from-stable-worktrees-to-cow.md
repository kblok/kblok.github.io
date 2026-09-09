---
title: Moving from stable worktrees to CoW, will that work?
tags: general ai git
permalink: /blog/moving-from-stable-worktrees-to-cow
hero: /img/moving-from-stable-worktrees-to-cow/hero.png
image: /img/moving-from-stable-worktrees-to-cow/hero.png
---

A few weeks ago I wrote about [stable worktrees](/blog/getting-out-of-worktree-hell): six fixed slots, wt1 through wt6, reused instead of recreated. The WIP limit was the point. It still is.

But the WIP limit never fixed the expensive part.

# The cost was never git

My day job workspace is not one repo. It is a parent directory with **dozens of independent git repos**. Parallel work lives in "worktree sets": wt1 through wt7, each holding one `git worktree` per repo, plus hooks that keep the agent from editing the main tree.

Git was fine. Dependencies were not. Every set reinstalled `node_modules` and rebuilt Gradle output.

| Measurement | Value |
|---|---|
| Worktree sets total | 55 GB |
| `node_modules` in wt1 alone | 4.7 GB |
| Main workspace | 22 GB |

That is a lot of disk for six people who happen to be the same person with six agents.

# Then someone mentioned CoW

A tweet about [cow](https://github.com/joeinnes/cow) landed in my timeline. Copy-on-write workspace manager. Rust CLI. On macOS it uses APFS `clonefile(2)`. Instant near-zero-cost copies of a repo, including `node_modules`, `dist`, `.env`. No install step.

I wanted that.

# Wait, so you just installed cow?

No.

cow wants **one primary repo** as its source. My workspace is a parent plus dozens of repos under it. cow's branch / sync / extract would run on the parent, which holds nothing useful.

Also: nine hooks and scripts already key on paths like `../worktrees/<set>/<repo>`. cow keeps pastures in its own directory and its own registry. I could force the path with `--dir`, but then I am adding a second tool for no gain.

**The single valuable idea is the mechanism: `clonefile(2)`.**

macOS already exposes it. `cp -c`. Or five lines of Python ctypes. No new dependency.

# The model: disposable repo slots

Framing that clicked for me: a repo slot is disposable.

"We need that repo in wt1. Clone it in. New task? Delete it and clone again."

So I rewrote the create script:

1. Clone the main copy of a repo into `~/Code/.../worktrees/<set>/<repo>` with `clonefile`.
2. Drop the copied `.git/worktrees` admin dir.
3. Fetch, then `git checkout -f -B <branch>` from `origin/<branch>` if it exists, else `origin/main`.
4. Rerun for the same repo replaces the slot. Refuse if there are uncommitted changes, unless `--force`.

`node_modules` and Gradle `build/` arrive with the clone. The husky install step becomes a fast delta. Hooks needed zero changes: they match on path prefix and on `.git` existing, and both still hold for a clone.

Old linked worktrees still work. The scripts tell them apart by whether `.git` is a file (worktree) or a directory (clone).

# Numbers, on a 3 GB working copy

| Step | Time |
|---|---|
| `cp -c -R` (per-file clonefile) | 97 s |
| `clonefile(2)` on the directory via Python ctypes | 7 s |
| Full create script with checkout, no install | 12 s |
| `pnpm install --frozen-lockfile` after (56 packages changed) | 46 s |
| Disk cost of the clone | 82 MB |

The ctypes call is almost insultingly small:

```python
import ctypes, sys
libc = ctypes.CDLL(None, use_errno=True)
sys.exit(libc.clonefile(sys.argv[1].encode(), sys.argv[2].encode(), 0))
```

Falls back to `cp -c -R` if the syscall fails (non-APFS, or different volumes).

# A mistake worth telling

The first disk measurements used `df /`. On macOS that is the sealed system volume. It never changes.

Every "0 growth" number in the first report was **wrong evidence for a correct claim**. Re-measured on `/System/Volumes/Data`: 82 MB per clone.

Measure on the volume the files live on.

# What you give up

A branch made in a clone is invisible from the main repo until you push. Scripts that scanned main for branches now also scan the worktree sets.

`git gc` or a real `pnpm install` inside a clone rewrites files and ends block sharing for those files only. That is fine. Sharing is a bonus, not a promise.

And `clonefile` on a directory is not O(1). It is kernel-side and fast. Seven seconds for 3 GB here. Still not free.

# Cleanup

Before deleting the old sets, every slot was checked for uncommitted files and unpushed commits, and every unpushed branch was checked against GitHub. Twenty branches had merged PRs (squash merges make local commits look unpushed). About ten slots had real unsaved work, mostly from mid-August.

I deleted all of it. Nine sets removed. 55 GB freed.

# Final words

Stable worktrees solved the WIP problem. CoW clones solved the disk and install problem. I did not need a new pasture manager. I needed `clonefile` and a script that treats a repo as a disposable slot.

If you are drowning in worktrees because of `node_modules`, start there. Keep the WIP limit. Steal the syscall.

Don't stop coding!
