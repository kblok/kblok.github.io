# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

This is the Jekyll source for [hardkoded.com](https://www.hardkoded.com), Darío Kondratiuk's personal blog (hosted as `kblok.github.io` on GitHub Pages). It's a fork/customization of the "Beautiful Jekyll" theme. There is no application code, build pipeline, or test suite — just Jekyll content, layouts, and static assets.

## Commands

Serve the site locally (uses the `github-pages` gem, pinned to match GitHub Pages' actual environment):

```
bundle install
bundle exec jekyll serve
```

Site is served at `http://localhost:4000`.

Alternatively, via Docker (uses an old, pinned toolchain — `Dockerfile` installs Jekyll 3.1.6 and specific gem versions):

```
docker build -t kblok.github.io .
docker run -p 4000:4000 kblok.github.io
```

There is no linter, formatter, or test suite in this repo.

## Content architecture

- **`_posts/`** — main blog posts (Markdown), filename pattern `YYYY-MM-DD-slug.md`. Front matter uses `title`, `tags` (space-separated string, e.g. `tags: puppeteer-sharp csharp`), and `permalink` (posts use custom permalinks like `/blog/...` rather than the site-wide `/:year-:month-:day-:title/` default). Layout defaults to `post` via `_config.yml` scoping rules, so it usually doesn't need to be declared per-file.
- **`_tils/`** — a separate Jekyll collection ("Today I Learned" short posts), rendered on `til.html`. Front matter here explicitly sets `layout: post`, `tags` as a comma-separated string (different convention from `_posts`), and a `/til/...` permalink.
- **`tag/*.md`** — one stub page per tag (`layout: tag_index`), used as the target for tag-index URLs. `_data/tags.yml` lists known tag slugs/names. Actual tag→post indexing is generated automatically by `_plugins/_tag_gen.rb` (a Jekyll `Generator` that builds a `TagIndex` page per tag found in `site.tags`, using `_layouts/tag_index.html`) — you don't need to hand-maintain per-tag post lists.
- **`goto/*.md`** — short-link redirect pages (`layout: redirected`, `redirect_to: <url>`), rendered via `_layouts/redirect.html` (meta-refresh + JS redirect). Used for stable outbound links (e.g. Slack invites) that might change destination later without changing the short URL.
- **`ui-testing-with-puppeteer/`** — a large flat set of standalone reference `.md` notes (not a Jekyll collection with an index); mostly source material/snippets related to the "UI Testing with Puppeteer" book.
- **`_layouts/`** and **`_includes/`** — standard Jekyll templating. `base.html` is the root layout; `default.html`/`page.html`/`post.html`/`minimal.html` build on it. Analytics/social/comments snippets live in `_includes/` (`google_analytics.html`, `gtm_head.html`/`gtm_body.html`, `disqus.html`, `social-share.html`) and are pulled in via `_config.yml` values (`google_analytics`, `gtm`, `disqus`) rather than hardcoded per page.
- **`_config.yml`** — site-wide settings: nav bar links, colors, social links (`_data/SocialNetworks.yml` backs the `social-network-links` keys), Disqus/GA IDs, permalink scheme, and the `defaults` block that sets `layout: post` for everything under `_posts` and `layout: page` for everything else.

## Conventions to follow when adding content

- New blog posts: add to `_posts/` with a `YYYY-MM-DD-slug.md` filename, `title`, `tags` (space-separated), and an explicit `permalink: /blog/<slug>`.
- New TILs: add to `_tils/` with `YYYY-MM-DD-slug.md`, and front matter matching the existing pattern (`layout: post`, comma-separated `tags`, `permalink: /til/<slug>`).
- Introducing a brand-new tag: add an entry to `_data/tags.yml` and create the matching `tag/<slug>.md` stub (copy an existing one and change `tag`/`title`/`permalink`) — the tag index generator does the rest.
- Adding a redirect/short link: add a file under `goto/` following `goto/pptr-slack.md`'s front matter shape.
