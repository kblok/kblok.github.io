---
title: 'Yet another "I build a software factory" post. Part 2'
tags: ai dotnet
permalink: /blog/yet-another-software-factory-post-part-2
hero: /img/yet-another-software-factory-post-part-2/hero.png
image: /img/yet-another-software-factory-post-part-2/hero.png
---

In [Part 1](/blog/yet-another-software-factory-post) I said cloud sessions were next. Well, my first cloud worker just sat there waiting for someone to say yes.

## The problem

The orchestrator starts one cloud session per open issue with `claude --cloud`. That command clones only the repo it runs from.

A worker often needs a second repo. A reference fork, for example. To get it, the worker asks for the `add_repo` permission.

A headless session has nobody to answer that prompt. So the worker stopped, and waited.

Four repos, and a reference fork for each one. Eight in total. The orchestrator is [hardkoded/oss-orchestrator](https://github.com/hardkoded/oss-orchestrator).

## What I tried

I allowed the permission in `.claude/settings.json`, in each of the four repos. New cloud sessions still showed the prompt.

I passed a permissions file with `--settings`. The prompt was still there.

I passed the environment id with `--environment`. The CLI rejected it. That flag only accepts self-hosted `ccpool_` ids.

I tried `--allowedTools`. The session started. The prompt still showed up.

Two launches also failed with a 503 from the cloud service. Nothing I could fix from my side.

## What I built

One Claude routine. No schedule. An API trigger.

It holds the eight repos: the four I orchestrate, and the four reference forks. Every session starts with all eight already cloned, so the worker never needs `add_repo`.

The routine keeps the worker brief. Work only in the repo named in the payload. Open a PR with `Closes #N`. If there is a question, leave a `QUESTION:` comment and add the `needs-answer` label.

The payload the orchestrator sends is one line: the repo, and the issue number. The brief stays on the routine, so I write it once.

`Cloud.cs` fires the routine. The token comes from a user environment variable. No connectors on the routine. The workers don't need them.

## It works

The first worker went through the routine. It ran, and it works perfectly.

## What I learned

A repo setting does not reach a cloud session. **Put what the worker needs into the session itself**, like the cloned repos.

I don't trust a CLI flag just because the docs list it. `--allowedTools` only counted after I launched a session and looked.

A running exe locks its build output. I build to a scratch folder when I only want to see if it compiles, and I stop the process before I replace `bin`.

`setx` only lands on new terminals. I had to reopen the terminal before starting the agent.

## Final words

`claude --cloud` was the next step, and then the worker just waited. Starting the session with the repos already cloned is what got it through.

Don't stop coding!
