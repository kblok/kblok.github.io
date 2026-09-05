# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

This is the Jekyll source for [hardkoded.com](https://www.hardkoded.com), Darío Kondratiuk's personal blog (hosted as `kblok.github.io` on GitHub Pages). The visual theme is a Hardkoded adaptation of [Swimmer](https://github.com/dsillman2000/swimmer) (Poole + Tailwind v4, dedicated landing page, dark mode).

## Commands

Install Ruby gems and Node deps, then serve:

```
bundle install
npm install
make serve
```

Site is served at `http://localhost:4000`. CSS lives in `_css/` and is compiled to `styles.css` via `@tailwindcss/cli`.

Production build:

```
make build
```

There is no linter, formatter, or test suite in this repo.

**Note:** This stack is Jekyll 4 + Tailwind. GitHub Pages' built-in Jekyll builder will not compile CSS. Use `make build` locally (or a GitHub Action) and publish `_site/` if you want Pages to host this theme.

## Content architecture

- **`_posts/`** — main blog posts (Markdown), filename pattern `YYYY-MM-DD-slug.md`. Front matter uses `title`, `tags` (space-separated string, e.g. `tags: puppeteer-sharp csharp`), and `permalink` (posts use custom permalinks like `/blog/...`). Layout defaults to `post` via `_config.yml`. Optional `hero` / `image` renders above the body.
- **`index.md`** — dedicated landing page (not a paginated post list): 3 recent posts, Puppeteer-Sharp flagship CTA, other projects, About.
- **`archive.md`** — full post list grouped by month.
- **`tag/*.md`** — one stub page per tag (`layout: tag_index`). `_data/tags.yml` lists known tag slugs/names. `_plugins/_tag_gen.rb` generates indexes only for tags that do not already have a stub.
- **`goto/*.md`** — short-link redirect pages (`layout: redirected`, `redirect_to: <url>`).
- **`ui-testing-with-puppeteer/`** — standalone reference `.md` notes related to the "UI Testing with Puppeteer" book.
- **`_layouts/`** and **`_includes/`** — Swimmer templating. `default.html` is the root layout; `page.html` / `post.html` build on it. Dark-mode toggle + sidebar live here. Analytics snippets are still pulled from `_config.yml`. No Disqus.
- **`_css/`** — Tailwind v4 source. Edit here, then `make css` (or `make serve`).
- **`_config.yml`** — site-wide settings: title/tagline, author, plugins, collections, permalinks.

## Conventions to follow when adding content

- New blog posts: add to `_posts/` with a `YYYY-MM-DD-slug.md` filename, `title`, `tags` (space-separated), and an explicit `permalink: /blog/<slug>`.
- Introducing a brand-new tag: add an entry to `_data/tags.yml` and create the matching `tag/<slug>.md` stub (copy an existing one and change `tag`/`title`/`permalink`).
- Adding a redirect/short link: add a file under `goto/` following `goto/pptr-slack.md`'s front matter shape.
- Promoting a post (`.claude/skills/promote-post`): punch links must always carry UTMs so GA4 can attribute Organic Social / campaigns. Campaign slug = last path segment of `permalink`. Templates: `?utm_source=x&utm_medium=social&utm_campaign=<slug>` (X) and `?utm_source=linkedin&utm_medium=social&utm_campaign=<slug>` (LinkedIn). Never append a bare canonical URL as the punch link.
