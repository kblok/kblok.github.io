---
title: "Getting out of DocFX hell"
tags: dotnet docfx
permalink: /blog/getting-out-of-docfx-hell
hero: /img/getting-out-of-docfx-hell/hero.png
image: /img/getting-out-of-docfx-hell/hero.png
---

DocFX got the API reference out. The site around it felt stuck in 2018.

I wrote a [DocFX tutorial](/blog/creating-docfx-site) back then. XML comments in, GitHub Pages out. It worked. Search, dark mode, the sidebar, the look: it stayed in that era. The docs I like opening now look like Mintlify. I wanted that UX, and I wanted to stay on GitHub Pages.

**So the site moved to [Astro Starlight](https://starlight.astro.build/). DocFX stayed in the pipeline, one step earlier.**

## Why it felt dated

DocFX is still good at one job. It reads a .NET project and emits an API model. The website it builds on top of that model is the part that felt old. Search, dark mode, the sidebar, the whole look and feel.

I don't have a bug list to wave around. The pages worked. I just stopped wanting to send people there.

## Why Starlight

[Starlight](https://starlight.astro.build/) is the Astro docs theme. Open source. The build is a static site, so GitHub Pages can host it the same way it hosted DocFX, with no new bill and no new host. Search ships with the production build. Dark mode ships with the theme. It looks like the docs sites I was jealous of.

The goal was a Mintlify-like UX without leaving GitHub Pages. That was the whole brief.

## DocFX still reads the code

Starlight has no idea what a C# `uid` is. DocFX does. The API reference still starts there. DocFX stops at the YAML, and Starlight is the website.

`npm run api` restores the local DocFX tool and runs `docfx metadata`. That writes YAML. A small script turns the YAML into Markdown under `docs-site/src/content/docs/api/`, and Starlight renders that. Member headings keep the old DocFX anchors (`#E2E_App_OpenAsync_...` and the same idea on the other repo).

The generated Markdown is committed. `npm run dev` can start without the .NET SDK. CI runs `npm run api` again before `npm run build`, so the published site matches the code on that commit.

## Two sites, same move

The first one was [e2e-dotnet](https://github.com/hardkoded/e2e-dotnet), in [pull request 667](https://github.com/hardkoded/e2e-dotnet/pull/667). It is live: [hardkoded.github.io/e2e-dotnet](https://hardkoded.github.io/e2e-dotnet/).

The site lives in `docs-site/` on `@astrojs/starlight`. The accent is the logo blue, `#4fa8ff`. Links in light mode are `#0c74d4`. `npm run sync` copies `README.md`, `COMPATIBILITY.md`, and `CONTRIBUTING.md` into the site. The rest of the guides live in `docs-site/`. The API reference comes from `E2E`, `E2E.NUnit`, and `E2E.XUnit.V3`.

Same pattern, a bit later, on [typesafe-sdk-dotnet](https://github.com/hardkoded/typesafe-sdk-dotnet), [pull request 28](https://github.com/hardkoded/typesafe-sdk-dotnet/pull/28). Also live: [hardkoded.github.io/typesafe-sdk-dotnet](https://hardkoded.github.io/typesafe-sdk-dotnet/). Gold stayed gold, `#e3a008` on the dark theme and `#b87d06` in light mode. Guides sit in `docs-site/guides/`. The API comes from `src/TypeSafe.AI.Sdk`.

## Still GitHub Pages

Both repos use `.github/workflows/docs.yml`. A pull request builds the site. A push to `main` builds it and deploys with `actions/deploy-pages`. That is the only deploy.

On e2e-dotnet, docs used to publish when a version tag went out. That path is gone. **Docs publish from `main`.** A release tag does not ship the site anymore.

Old DocFX `.html` URLs redirect to the new paths. The redirect page keeps `location.hash` when JavaScript runs, so a member link still lands on the member. A browser that only follows the meta refresh drops the hash. Worth knowing.

One aside, because it bit the runner. Astro wants Node `>=22.23.4`. The `"22"` alias on GitHub Actions resolved to `22.23.3`. Close enough to fail. The workflow pins `>=22.23.4 <23` and sets `check-latest: true`.

## Let's preview it

From `docs-site/` in either repo:

```bash
cd docs-site
npm ci
npm run api
npm run dev
```

`npm run api` needs the .NET 10 SDK. If the generated API Markdown is already in the checkout and you only want to click around, `npm ci` and `npm run dev` are enough. `npm run sync` refreshes the guides. Search shows up after `npm run build`.

Open `http://localhost:4321/e2e-dotnet/` or `http://localhost:4321/typesafe-sdk-dotnet/`. The prefix is the GitHub Pages project-site base.

## Final words

DocFX still reads the assemblies. Starlight is the site. Pages still hosts it, from `main`, for free.

If your library docs feel like the year you first set DocFX up, this split is small enough to copy. Metadata in, Markdown out, Starlight on top. I did it twice this week. Both sites are up.

Don't stop coding!
