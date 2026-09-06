---
title: I Connected Quicken to My AI Agent
tags: general ai
permalink: /blog/quicken-skills
---

I moved my whole life into my AI bot. Calendar, notes, todos. Money was the last blocker.

Ten years of financial life live in Quicken for Mac. Transactions since 2011. And Quicken does not talk to anything.

Hard rule I set myself: **read-only**. I will not let an AI write into ten years of bookkeeping.

Then I found the real insight. Quicken for Mac stores everything in a plain SQLite database inside the `.quicken` package. If it is SQLite, an agent can read it.

So I built [quicken-skills](https://github.com/hardkoded/quicken-skills). A plugin for Claude Code, Cursor, GitHub Copilot, and Codex. Your personal finances, in your AI.

# Wait, Quicken is just SQLite?

Yes.

Open the package and you get a Core Data store. Tables are `Z`-prefixed. Entity types via `Z_ENT`. Soft deletes via `ZDELETIONCOUNT`. Timestamps are seconds since 2001-01-01 (add 978307200 for unix epoch). Weird, but readable.

One bash script (`quicken.sh`) over `sqlite3` and `curl`. No Node. No Python. No build step. The numbers come from SQL recipes, not from the model. The AI picks a recipe, runs it, and explains the table. Then it can write ad-hoc SQL for follow-ups using a schema reference we ship with the plugin.

# What does it feel like?

After setup, you ask questions. The agent picks the skill.

- "Where did my money go last month?"
- "What is my net worth and how did it change since January?"
- "Which subscriptions got more expensive this year?"
- "How is my portfolio doing? Show me gains by lot."
- "List everything I tagged vacation in 2024."
- "What is wrong with my data?"

On my file that is 20,486 transactions across 49 accounts (42 open), two currencies, from 2016-07-28 to 2026-09-04. Every recipe runs in under 0.4 seconds.

Hygiene found 13 accounts silent for over a year, 235 uncategorized lines in the last 12 months, and 80 possible duplicate groups. Spending for August: Auto & Transport 78% below the 12-month average. Pets up 672%. The vet. Top payee over 12 months: income tax. After we fixed a bad price-increase heuristic, the real top jumps were monthly charges up 34.5%, 26.7%, and 23.1% (insurance and taxes).

I am not publishing absolute net worth or account balances. You do not need those to see that the tool works.

# Is it really read-only?

Yes.

```bash
sqlite3 -readonly <file>.quicken/data ".backup <copy>"
```

That copies the database. If the file is locked, it falls back to `file:...?immutable=1`. The live file is never opened writable.

Everything runs on `~/.quicken-skills/snapshot.sqlite`, mode 600. Delete the folder and Quicken is untouched. Nothing from transactions leaves the machine. The only network calls fetch exchange rates (currency codes and dates).

The test suite builds a synthetic Quicken file from the real schema and checks known totals on Linux and macOS in CI.

# How to install

Claude Code:

```bash
/plugin marketplace add hardkoded/quicken-skills
/plugin install quicken@quicken-skills
/quicken:quicken-setup
```

Cursor: import the repo as a team marketplace, then install `quicken`.

GitHub Copilot (VS Code): **Chat: Install Plugin From Source** with `https://github.com/hardkoded/quicken-skills`.

Codex:

```bash
codex plugin marketplace add hardkoded/quicken-skills
codex plugin add quicken@quicken-skills
```

Requirements: Quicken Classic for Mac, file open, `sqlite3` and `curl`. Quicken for Windows (QDF) is not plain SQLite. Not supported yet.

Honest limits: realized gains per sale are not available (Quicken does not store the cost of shares sold on the sell row). Investment history rebuilt from transactions can disagree with lots after stock splits. Recurring-charge and price-increase detection are heuristics.

# Final words

The skills are markdown and SQL. Come add the one you miss. Send PRs. Break it. Tell me what is wrong with your data that I did not model yet.

Repo: [hardkoded/quicken-skills](https://github.com/hardkoded/quicken-skills)

Don't stop coding!
