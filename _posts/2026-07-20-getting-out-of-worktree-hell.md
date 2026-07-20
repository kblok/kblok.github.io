---
title: Getting Out of Worktree Hell
tags: general ai git
permalink: /blog/getting-out-of-worktree-hell
---

Git worktrees aren't new. They shipped in [Git 2.5](https://github.blog/open-source/git/git-2-5-including-multiple-worktrees-and-triangular-workflows/), back in July 2015. And for years, almost nobody used them. Checking out a second branch into a second folder was a nice trick for the rare case, not something you reached for every day.

Then AI coding agents showed up, and worktrees became the obvious answer to a new question: how do you run more than one agent on the same repo at the same time? You can't have two agents fighting over the same branch and the same files. Give each one its own worktree, and they stop stepping on each other.

Claude Code leans into this hard. Ask it to start a task and it will happily create a worktree for you, attach it to a branch, and clean it up once that branch is gone. It's smooth. It's also how you end up in worktree hell.

# How you end up here

One worktree per task sounds great, until you have a dozen of them open. Each one is a PR in some state: waiting on CI, waiting on review, waiting on you to remember what you were even doing in there. I built [pr-memory](/blog/pr-memory) to fix the "wait, what was I doing" half of that problem. But it doesn't fix the other half: too many folders, too many terminals, too much to hold in your head at once.

And then, one day, you get a "disk full" alert on a machine that should have plenty of space. You dig in, and it turns out half your disk is dead worktrees: branches that merged weeks ago, folders nobody removed, build output sitting there because Claude Code created the worktree but nothing ever told it to clean up after the PR closed.

# It depends on the repo

None of this is a problem on a small, single-repo project. [puppeteer-sharp](https://github.com/hardkoded/puppeteer-sharp) is one repo with a light build; worktrees come and go and you'd never notice. But once you're working across several related repos, or a big repo with a heavy build — an Electron app, say, where every checkout drags a chunky `node_modules` and a pile of build artifacts behind it — an unmanaged stack of worktrees turns from an annoyance into a real problem, on disk and in your head.

# Stable worktrees

For my "enterprise" work, I stopped letting worktrees multiply and switched to what I call stable worktrees: a fixed set that's always there, reused instead of recreated.

<img src="https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/getting-out-of-worktree-hell/stable-worktrees.png" style="display: block; margin: auto;">

I keep six of them, wt1 through wt6, each one tied to its own [cmux](https://cmux.com) session, and each cmux session living in its own Chrome tab group with the matching name. Same six names everywhere, so I always know which terminal, which browser tabs, and which piece of work go together.

There's also a seventh, wt0. It isn't a real worktree — it's just a cmux tab for the stuff that doesn't belong to any single task: loops, PR checks, crons, the background chores that don't need a workspace of their own.

# The limit is the point

Six sounds restrictive, and it is. That's what makes it work. When all six are busy, I can't just spin up a seventh — I have to finish something, ship it, or park it, before I start anything new. It turns the worktrees into a kanban board with a hard WIP limit, and it's done more for shipping than any productivity tip I've tried: fewer half-finished branches, more PRs actually landing.

Don't stop coding!
