# Swimmer theme preview (Hardkoded)

**Preview only — no pull request.** This branch is a visual/structural spike so we can see Hardkoded wearing [Swimmer](https://github.com/dsillman2000/swimmer) before deciding whether to merge.

## Branch

`cursor/preview-swimmer-theme-3afa`

GitHub: https://github.com/kblok/kblok.github.io/tree/cursor/preview-swimmer-theme-3afa

## How to run

Needs Ruby 3.2+ (Jekyll 4), Bundler, and Node 20+ (Tailwind v4 CLI).

```bash
bundle install
npm install
make serve
```

Open http://localhost:4000

Production build (writes `_site/`):

```bash
make build
```

`make css` compiles `_css/` → `styles.css`. A compiled `styles.css` is committed so a Jekyll-only build still has styles, but edit the sources in `_css/` and recompile after CSS changes.

## What this preview does

- Replaces vendored Beautiful Jekyll (Dean Attali) layouts/CSS/JS with Swimmer layouts, Inter/Roboto Mono, Tailwind v4, dark-mode toggle, and the post sidebar.
- Keeps Hardkoded content: `_posts/`, About, Resume (standalone HTML + `css/resume-style.css`), tag stubs, `goto/` redirects, images, `CNAME`, `/feed.xml`. TIL collection and chrome are removed in this preview.
- Homepage is a funnel (issue #44), not a paginated river:
  1. Avatar + one-line pitch
  2. **3 most recent posts** + link to archive
  3. **One** Puppeteer-Sharp flagship CTA; other projects listed below (no duplicate)
  4. **About** teaser + resume
- Branding: title **Hardkoded**, tagline Darío Kondratiuk, author/SEO/Twitter `@hardkoded`.
- Adds Swimmer `atom.xml` next to the existing `feed.xml`.

## Known gaps

| Area | Status |
| --- | --- |
| **Disqus** | Removed. No `disqus` config, no embed include, no `comments` default. Posts do not load Disqus / Discovery ads. |
| **`/es/` Spanish site** | No En Español / `/es/` nav link. Footer, homepage, config, and layouts do not point at hardkoded.com/es/. Historical `cross-site-link` front matter on a few old posts is unused by Swimmer. `es/tag/books.md` remains as a leftover inbound redirect, not a site link. |
| **Beautiful Jekyll leftovers** | `Dockerfile` still pins ancient Jekyll 3.1.6 — do not use it for this branch. `json-demo.html`, `BingSiteAuth.xml`, `ui-testing-with-puppeteer/` notes, and `_data/SocialNetworks.yml` remain. Bootstrap/jQuery/theme CSS+JS were removed. Resume still uses its own stylesheet. |
| **GitHub Pages** | Native Pages Jekyll is 3.x and will not run Tailwind or this Gemfile. Preview locally, or add an Actions workflow that runs `make build` and publishes `_site/`. Raw GitHub will show source, not a styled site. |
| **Social share buttons** | Dropped (Twitter/Facebook/LinkedIn buttons on posts). |
| **Navbar** | Swimmer has no top nav. Site links live in the footer + sidebar. |
| **UA analytics** | Still the old `UA-586295-8` snippet. No GA4/gtag in this preview. |
| **Liquid warnings** | Two existing posts contain raw `{{ ... }}` in code samples; Jekyll 4 warns, pages still build. |
| **TIL** | Removed from this preview: no `_tils/`, no `/til/` page, no chrome links. |
| **`ui-testing-with-puppeteer/`** | Book notes still render as pages; one destination conflict (`repo.html`) is pre-existing. |

## Artifacts

Screenshots (also under `/opt/cursor/artifacts`):

- `homepage_light.png`
- `homepage_dark.png`
- `post_stream_deck.png`
- `about_page.png`
- `ai_era_hero_light.png`
