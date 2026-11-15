---
title: 'Yet another "I build a software factory" post. Part 2'
tags: ai dotnet
permalink: /blog/yet-another-software-factory-post-part-2
hero: /img/yet-another-software-factory-post-part-2/hero.png
image: /img/yet-another-software-factory-post-part-2/hero.png
---

In [Part 1](/blog/yet-another-software-factory-post) I said cloud sessions were next. Well, my first cloud worker just sat there waiting for someone to say yes. Let me tell you what it was waiting for.

The orchestrator starts one cloud session per open issue with `claude --cloud`, and that command clones only the repo it runs from. But a worker often needs a second repo, a reference fork for example, and to get it the worker asks for the `add_repo` permission. A headless session has nobody to answer that prompt, so the worker stopped and waited.

I run this on four repos, and a reference fork for each one, so that's eight if you are counting. The orchestrator is [hardkoded/oss-orchestrator](https://github.com/hardkoded/oss-orchestrator).

## What I tried

Let's go through what I tried, because I kept thinking the next flag would be the one.

- I allowed the permission in `.claude/settings.json`, in each of the four repos, and new cloud sessions still showed the prompt.
- I passed a permissions file with `--settings`, and the prompt was still there.
- I passed the environment id with `--environment`, and the CLI rejected it, because that flag only accepts self-hosted `ccpool_` ids.
- I tried `--allowedTools`, the session started, and the prompt still showed up.

Two launches also failed with a 503 from the cloud service, and there was nothing I could fix from my side.

## What I built

So I made one Claude routine, with no schedule, and an API trigger. It holds the eight repos, the four I orchestrate and the four reference forks, and every session starts with all eight already cloned, so the worker never needs `add_repo`.

The routine keeps the worker brief, so I write it once. Work only in the repo named in the payload, open a PR with `Closes #N`, and if there is a question, leave a `QUESTION:` comment and add the `needs-answer` label. The payload the orchestrator sends is one line, the repo and the issue number, and the brief stays on the routine.

`Cloud.cs` fires the routine, and the token comes from a user environment variable. There are no connectors on the routine, because the workers don't need them.

The first worker went through the routine, it ran, and it works perfectly.

## Don't trust the session to watch its PR

Then I found something else. You can't trust the session to watch the pull request the way you'd expect, because sometimes it starts the loop, and other times it just waits for someone to tell it.

So now the orchestrator watches that pull request deterministically, and it tells the routine for that PR when the build is broken or when there are conflicts. Watching a PR is a deterministic task, so the console app does it. Same golden rule from [Part 1](/blog/yet-another-software-factory-post): deterministic tools for deterministic tasks, agentic tools for agentic tasks.

## What I learned

A repo setting does not reach a cloud session, so **put what the worker needs into the session itself**, like the cloned repos.

I don't trust a CLI flag just because the docs list it. I passed `--allowedTools`, and it only counted after I launched a session and looked.

A running exe locks its build output, so when I only want to see if the code compiles I build to a scratch folder, and I stop the process before I replace `bin`.

`setx` only lands on new terminals, so I had to reopen the terminal before starting the agent.

And I can't trust the session to watch its own pull request. Sometimes the loop starts, and sometimes it just waits, so the orchestrator reports a broken build or conflicts to that routine.

## Final words

`claude --cloud` was the next step, and then the worker just waited. Starting the session with the repos already cloned is what got it through, and watching the PR stayed on the console app.

Don't stop coding!
