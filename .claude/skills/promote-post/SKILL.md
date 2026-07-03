---
name: promote-post
description: Draft full-text LinkedIn article and X (Twitter) long-form post copy from an existing hardkoded.com blog post or TIL, then publish both automatically via browser automation. Use when the user says "promote this post", "cross-post this article", "share this on twitter and linkedin", "post it", or "/promote-post <file>".
---

# Promote Post

Turn an existing post from `_posts/` or `_tils/` into paste-ready copy for a LinkedIn
article and an X (Twitter) long-form post, then publish both directly using browser
automation (the `claude-in-chrome` MCP), driving the user's own logged-in LinkedIn and
X sessions. This is fully autonomous — it clicks Publish/Post without a manual review
step, per explicit user instruction. There is no undo once a post goes out; if the
`claude-in-chrome` MCP is not connected/authorized, or the user isn't logged into
LinkedIn/X in that browser, stop and tell the user rather than guessing.

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
   - Use exactly one blank line between paragraphs/list items — no double blank lines,
     and no leading/trailing blank lines around the whole block. This converted text is
     what gets typed into the editors in step 6, so its spacing directly determines the
     posted spacing.

5. **Show the two converted blocks in the chat response** before publishing anything,
   clearly labeled:
   - `LinkedIn article body`
   - `X post`
   Both blocks contain the same converted full text (from step 4); there is no
   shortened/teaser variant. This is a record of what's about to be posted, not a
   request for approval — proceed straight to step 6 after showing it.

6. **Publish via browser automation**, using the `claude-in-chrome` MCP tools against
   the user's already-authenticated LinkedIn and X sessions. If those tools aren't
   loaded yet, load them first (`ToolSearch` for `claude-in-chrome`). For each
   platform:
   - **LinkedIn**: open `https://www.linkedin.com/article/new/`, put the post `title`
     (from step 2) in the article title field, paste the converted body (step 4) into
     the article body editor, then click **Publish**.
   - **X**: open the X compose view, paste the converted body (step 4) into the
     composer (X Premium long-form supports up to ~25,000 characters in one post — do
     not split it into a thread), then click **Post**.
   - If either platform doesn't show the user as logged in, or the composer/editor
     can't be located, stop and report that instead of guessing at selectors or
     retrying blindly.
   - Media placeholders (`[image: ...]` / `[GIF: ...]`) are left as literal text in
     the posted content — this skill does not download, re-host, or attach media.
     Report their presence to the user after posting so they know to add media by
     hand if they want it.
   - **Typing into the rich-text editors is lossy — verify before publishing.** Both
     LinkedIn's article editor and X's composer are contenteditable surfaces that can
     silently mangle a fast/scripted `type`: paragraph breaks (`\n\n` in the converted
     text) can turn into extra empty paragraphs (visible as oversized gaps between
     paragraphs), list items can retain a literal `-`/`*` alongside the editor's own
     bullet glyph, and — observed in practice — LinkedIn can autosave/redirect
     mid-type and silently drop everything typed after that point. Before clicking
     Publish/Post:
     1. Reload the draft (LinkedIn) or re-screenshot the composer (X) so you're
        looking at what's actually persisted, not just what you think you typed.
     2. Scroll through the whole thing and compare against the converted text from
        step 4, checking specifically for:
        - Missing paragraphs or sections (a dropped tail from a mid-type autosave).
        - Doubled blank lines / oversized gaps between paragraphs, and any extra
          spaces (double spaces mid-sentence, stray leading/trailing spaces on a
          line) that shouldn't be there.
        - Stray leading `-`/`*` characters duplicating the editor's own bullet glyph
          on list items.
        - Bullets actually rendering as a bulleted list (bullet glyphs, indented
          items) rather than as plain paragraphs that happen to start with a dash.
        - Every `text (url)` pair from step 4's link conversion has its URL rendered
          as a real clickable hyperlink (colored/underlined) by the editor's
          auto-link detection — not sitting there as plain, unclickable text.
     3. Fix anything wrong directly in the editor (retype a dropped section, delete
        an extra blank paragraph or stray space, strip a stray list-marker character,
        click into a URL that didn't auto-link and re-trigger it e.g. by adding/
        removing a trailing space) and re-verify before publishing. Don't click
        Publish/Post on unverified content.
   - After both platforms are posted, report back the two live post URLs (or confirm
     posting succeeded) to the user.

7. **Reshare the LinkedIn article to the feed, with approval.** A published LinkedIn
   article doesn't get much feed visibility on its own — it needs a companion post
   pointing at it. On the article page, click **Share** → **Repost to Feed**, which
   opens a normal post composer with the article already attached as a link card and
   an empty "What do you want to talk about?" text field.
   - Draft a short, catchy teaser (1–4 sentences) for that field, in Darío's voice per
     `voice.md` (direct hook, no corporate throat-clearing, at most one emoji at the
     very end). This is new copy you're generating, not a repetition of the article —
     treat it like a hook, not a summary.
   - **Show the draft teaser to the user and wait for explicit approval before
     posting it.** This is the one exception to this skill's normal fully-autonomous
     flow — unlike the article body (which is a direct conversion of the user's own
     writing), this teaser is text you're originating, so it gets a human check before
     it goes out. If the user asks for changes, revise and show the new draft; don't
     post until they approve.
   - Once approved, type the exact approved text into the composer, verify it rendered
     correctly (same lossy-typing check as step 6) and that the article card is still
     attached, then click **Post**.
   - X's long-form post already appears directly in the X feed, so this reshare step
     is LinkedIn-only — there's no equivalent needed on X.
