# Voice guide

Notes on how Darío writes on hardkoded.com, built from reading ~18 posts across years and post types (technical deep-dives, personal essays, milestone announcements, book reviews, monthly reports, TILs). Use this when drafting a new post so it sounds like him, not like generic AI-assistant prose.

## The sign-off

Almost every post (except TILs) ends with:

> Don't stop coding!

Sometimes with one extra line right before it, matching the post's occasion:
- "Happy automation!  \nDon't stop coding!"
- "I hope you can get more of my posts soon :)  \nDon't stop coding!"

Always end a full post with this line unless there's a strong reason not to.

## Post shapes (pick the one that matches what you're writing)

**1. Technical deep-dive / tutorial** (e.g. the async void post, interprocess communication, Azure Functions)
- Opens with a short, plain-language hook — often a "Let's see if..." or a one-line problem statement, not a formal intro.
  - "Let's see if we can get Puppeteer-Sharp running into an Azure Function."
  - "Let me tell you a story about async voids, SynchronizationContext, and async programming."
- Narrates in first-person-plural, present tense, as a live walkthrough: "Let's create...", "Now, let's go to...", "We are going to..."
- Poses the real question as an `##` header, then answers it directly underneath: "How is it possible that a try-catch block can't catch an Exception?", "Is async void the problem?"
- Code comments carry personality, not just explanation: `// If microsoft docs tells me to call this method I will.` / `// This is how a .NET developer leaves an app open in Node.JS`
- Uses a comic dramatic pause via stacked lines before a punchline reveal:
  ```
  Can I connect a .NET app there?
  .
  .
  .
  .
  No, you can't.
  ```
- Closes with a `# Final Words` (capitalization varies) section that steps back and states the one takeaway, then the sign-off.

**2. Personal essay / opinion** (e.g. "my language is the best", "how to start an OSS project", "hello world")
- Anecdote or personal claim first, general lesson second — never leads with the abstract point.
- Pulls the post's key line out into its own blockquote for emphasis, sometimes literally repeating a sentence from the paragraph above:
  > "If you want to finish an OSS project, you will need a roadmap"
- Talks directly to the reader and pre-empts their reaction: "I know what you might be thinking now, and it's true." / "You might say..."
- Self-deprecating asides: "Don't judge me.", "Pretty lame right?", "if you don't notice that I write like a caveman..."
- Ends on an encouraging, community-first note, then the sign-off.

**3. Milestone / announcement** (e.g. MVP award, book release, Playwright Sharp joining Microsoft, monthly reports)
- Opens with genuine excitement, stated plainly, not hyped up: "I'm super excited to share...", "It is my pleasure to announce that today..."
- Anticipates the skeptical reader question as its own header, answers it head-on: "Wait, did you give the project away?", "But, why?", "Are you leaving the project?"
- Always redirects credit outward — names specific people and links them, thanks them by name. Personal wins are framed as community wins ("It's not my project. It's OURS.").
- Raw numbers are presented unembellished as bullet lists (stars, downloads, reputation) without spin — the framing/humility comes in the surrounding prose, not the numbers.
- Closes with a "final words" beat that's modest about the achievement, then the sign-off.

**4. TIL** (`_tils/`)
- One or two sentences of context (often just "why I needed this"), then the command/snippet. No sign-off, no sections, no fluff.
  > "If I'm going to Google every time I need to kill a process locking a port let's at least get to my site"

## Recurring devices, usable in any post type

- **Rhetorical question → direct answer**, often as the header itself, then a blunt one-line answer right after: "Isn't `async void` the root of all evil? ... But that weird question helped me to understand that I wasn't getting what my problem was."
- **"Let's..." as a transition**, used constantly to move to the next step or topic, not just in tutorials.
- **Bold** for the single sentence that is the actual point of a paragraph/section — used like a highlighter, not for keywords.
- **GIFs** (usually Giphy) dropped in at emotional beats — reveal, frustration, celebration — doing comic timing that words alone would spell out. Use sparingly and only where a beat needs a laugh, not as decoration.
- Occasional emoji, always at the very end of a sentence, for a wink/self-aware tone: 😉 😜 ⭐️. Never more than one or two per post.
- Light self-aware jabs at his own English/writing: "I know I write like a caveman", informal contractions and run-on asides are fine — don't over-polish into "correct" textbook English. The voice is a non-native English speaker writing casually and confidently, not performing perfect prose.
- Community/gratitude is not an afterthought — if a post is about an achievement, expect at least one paragraph naming and linking the people who helped, by name.

## What NOT to do

- Don't open with a throat-clearing intro paragraph ("In this post, we will explore..."). Get to the hook in the first sentence.
- Don't write a generic corporate-blog closing ("In conclusion, ..."). Use "Final Words" / "Wrapping up" framed as a personal takeaway, then "Don't stop coding!"
- Don't smooth out every sentence into perfectly polished English — some informality and directness is part of the voice.
- Don't bury the human context. Even in a pure code tutorial, there's usually a one-line reason *why* ("I really want to implement it on Playwright-Sharp. So let's see how far we are from getting this done.").
