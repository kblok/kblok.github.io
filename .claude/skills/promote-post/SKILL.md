---
name: promote-post
description: Draft full-text LinkedIn article and X (Twitter) long-form post copy from an existing hardkoded.com blog post or TIL, ready to paste and publish manually. Use when the user says "promote this post", "cross-post this article", "share this on twitter and linkedin", or "/promote-post <file>".
---

# Promote Post

Turn an existing post from `_posts/` or `_tils/` into paste-ready copy for a LinkedIn
article and an X (Twitter) long-form post. Output is text only — this skill never
posts, opens a browser, or calls any API. The user always does the actual publishing
by hand.

This only works because the user has **X Premium** (supports long-form posts up to
~25,000 characters) and posts LinkedIn content via **"Write an article"** (LinkedIn's
long-form feature, no length cap) rather than a regular status update (~3,000 char
cap). Don't suggest a Twitter thread or a shortened teaser — the whole point is full
content replication.

## Steps

1. **Resolve the target file.** The user must supply a filename or path (bare filename
   like `2023-12-31-puppeteer-sharp-recap-2023` or `2023-12-31-puppeteer-sharp-recap-2023.md`,
   or a full relative path like `_posts/2023-12-31-puppeteer-sharp-recap-2023.md`).
   Look in `_posts/` first, then `_tils/`. If no argument was given, or nothing matches,
   **ask the user which file they mean** — do not guess or default to "the latest post."

2. **Read the file.** Pull `title` and `permalink` from the front matter, and the full
   Markdown body.

3. **Build the canonical URL**: `https://www.hardkoded.com` + the post's `permalink`
   (e.g. `https://www.hardkoded.com/blog/puppeteer-sharp-recap-2023` or
   `https://www.hardkoded.com/til/<slug>`).

4. **Convert the Markdown body to clean plain text** for both platforms — neither
   LinkedIn's article editor nor X's composer render Markdown syntax, so raw `##`,
   `**`, backtick fences, etc. must not appear in the output:
   - Headings (`#`, `##`, ...) become their own short standalone line (no `#` marks).
   - `**bold**` / `_italic_` markers are stripped (plain text) since neither platform's
     paste target reliably keeps emphasis from pasted Markdown.
   - Code blocks become plain indented text, still clearly separated from prose (e.g.
     a blank line before/after, indentation preserved) so code is still readable.
   - Inline links `[text](url)` become `text (url)` — never leave literal `[`/`]`/`(`/`)`
     Markdown link syntax in the output. This blog's posts lean heavily on inline
     links, so check every paragraph for these, not just obvious reference sections.
   - Images and GIFs are **not** included — replace each one with a bracketed
     placeholder at that position: `[GIF: <original url>]` or `[image: <original url>]`,
     so the user knows where to manually re-attach media. Do not attempt to download,
     re-host, or embed media.
   - Leave blockquotes as plain text (drop the `>` marker but keep the line distinct
     with surrounding blank lines) — voice.md-style pull-quotes and the "dramatic
     pause" stacked-line device should survive as-is, just without Markdown syntax.
   - Append the canonical URL from step 3 at the very end of the converted text (after
     the sign-off, if any), so readers can click through to the live post with real
     formatting, working code, and comments.

5. **Output two separate, clearly labeled paste-ready blocks** in the chat response:
   - `LinkedIn article body — paste into "Write an article" (not a regular post)`
   - `X post — requires X Premium long-form post`
   Both blocks contain the same converted full text (from step 4); there is no
   shortened/teaser variant.

6. **Never take any publishing action.** Do not open a browser tab, build a share-intent
   URL, or call any social API. The deliverable is the two text blocks — the user
   copies and pastes them in himself.
