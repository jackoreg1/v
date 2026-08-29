# CLAUDE.md

Notes for Claude working in this repo. Jack usually works from his phone, so
the point of this file is that Claude does not have to ask him things he would
have to answer with his thumbs.

## What this repo is

Standalone, self-contained HTML pages. That is the whole repo.

| File | What it is |
| --- | --- |
| `index.html` | The Leak Room. Jack's real, present day offer page, modelled on a Skool plan picker. Standard EUR 39 and Premium EUR 249 a month, a Standard/Premium toggle, and an honesty section listing what he has not done yet. This is the page GitHub Pages serves at the root. |
| `vision-k7x9q2.html` | Jack's "vision build" of jackoregan.com, written as if it is August 2027. Home page, weekly post, Leak Finder quiz, the EUR 29 book sales page, an interactive reader for the book, the EUR 999 assessment funnel, and a funnel map. |
| `teardown-01.html` | Teardown 01, the first Standard tier asset. Five weeks inside one anonymised coaching account, 20 July to 28 August 2026. Built from Jack's own audit files and sprint updates, not written fresh. Every figure is dated and was read live. |
| `movienight.html` | A trailer-rating app. 61 films, score each 1-10, anything 7+ is kept on a shortlist that survives refreshes. |

## Hard rules

- **One file per page. Everything inline.** CSS in a single `<style>`, JS in a
  single `<script>`, no imports, no bundler, no framework, no external assets.
  A page must work by double-tapping the file with no network.
- **No dependencies and no build step.** Do not add npm, a package.json, a
  config file, or a toolchain. If a change seems to need one, the change is
  wrong.
- **No tracking, no analytics, no third-party scripts.** `vision-k7x9q2.html`
  is deliberately `noindex,nofollow`.
- **Mobile first.** Both pages are designed to be used on a phone. Check any
  layout change at a narrow width before a wide one.
- **Do not "fix" the 2027 numbers.** The dates, the EUR 214,000, the 61
  assessments, the 1,100 copies, the testimonials and the follower count in
  `vision-k7x9q2.html` are a deliberate vision build set in the future. They
  are not claims about today and they are not bugs. Leave them unless Jack
  says otherwise.

## Voice

Jack's copy has a specific voice and it is easy to wreck. Match it:

- Irish, spoken, plain. "the fella ranking first", "grand", "aye", "on the
  tools", "before the dinner".
- Short sentences. Comma splices are fine and used on purpose.
- **No em dashes.** There are none in either file. Do not introduce any.
- Numbers do the persuading, not adjectives. Every claim carries a figure.
- Never inflate. The book itself argues for the honesty cap and the mean
  0.1 multiplier. Copy that goes the other way is off-voice.

## How each page actually works

### `vision-k7x9q2.html`

- **Routing is the URL hash.** `SCREENS` lists the valid ids; `go(id)` sets
  `location.hash`, `route()` toggles `.screen.on` for `#s-<id>`. An unknown
  hash falls back to `home`. Adding a screen means adding a `<div class="screen"
  id="s-x">` *and* adding `"x"` to `SCREENS`.
- **Nothing persists.** No `localStorage` anywhere. `bought` is a plain
  variable, so a refresh re-locks the book. That is intentional for a demo.
- **The book paywall** is the `.locked` class. `readerRefresh()` shows or
  hides every `.locked` page and flips `#lockpanel` / `#ownedline`. A new
  paid page needs `class="bookpage locked"`.
- **The interactive book maths** runs off `calcBook()`, wired by
  `oninput` on each input. Ids are load-bearing: `bk-aj` and `bk-jw` are the
  two base numbers, `bk-l1` to `bk-l9` are the per-leak inputs, and each one
  writes into the scoreboard cell with the matching `sb-l1`..`sb-l9` id.
  Leak 10 is deliberately not counted, it rolls up into leak 7.
  The 15 percent honesty cap is computed in `calcBook()` and written to
  `#bk-capmsg`.
- **The quiz** is the `QUIZ` array. Each entry is `{cat, q, opts}` and each
  option is `[label, weight]` in euro per month. The last question, `cat:"size"`,
  is different: its weight is a multiplier, not a weight, and answering it
  jumps straight to the email capture. Result = sum of weights x multiplier,
  rounded to the nearest 10.
- **The green is `#0e6b45`** throughout, with `#0a5636` for hover. Use the
  existing CSS classes rather than adding new ones where one already fits.

### `movienight.html`

- **The film list is `F`**, an array of
  `[title, runtimeMinutes, blurb, "Comma,Separated,Tags", youtubeId]`.
  Adding a film means appending one row, nothing else.
- **State persists** in `localStorage` under the key `movienight1`, shaped
  `{seen: [], short: [{n, s}], bin: []}` where `n` is the index into `F`.
  Changing the shape of `F` or reordering it invalidates saved state, so if the
  order ever has to change, change `KEY` too.
- A round is 15 unseen, unbinned films, shuffled. A score of 7 or more puts
  the film on the shortlist. The shortlist survives every new round.
- Dark theme, colours are the `:root` custom properties. `--amber` is the
  accent, `--red` is the trailer button only.

## Hosting on GitHub Pages

The repo is public and Pages serves it straight from `main` at the repo root,
no workflow, no build step. Settings, Pages, Source: Deploy from a branch,
Branch: `main`, folder `/ (root)`.

| Page | Live URL |
| --- | --- |
| `index.html` | https://jackoreg1.github.io/v/ |
| `movienight.html` | https://jackoreg1.github.io/v/movienight.html |
| `vision-k7x9q2.html` | https://jackoreg1.github.io/v/vision-k7x9q2.html |

Two things follow from serving the whole repo root:

- **Everything committed here is publicly reachable as a live page.** The
  vision build renders as a real looking site at a guessable URL. It is
  `noindex,nofollow` so it stays out of search, but a shared link works.
- **Never commit a page holding a named client's private material.**
  `terrence30.html` in `docs/terrence-tool-spec.md` is the current example. If
  it ever gets built, it does not go in this repo.

Pages redeploys on every push to `main`, usually inside a minute.

### `teardown-01.html` specifics

- **Anonymised on purpose.** No client name, no lead names, no domain, no CRM
  platform. It is one real account and the numbers are exact. If a name ever
  goes back in, it does not go in this repo.
- Sources are Jack's own files, so the voice is already his: the 20 July full
  system audit, the 25 July inbox run, the 24 August pipeline truth, the
  27 August 56 conversation read, and the two-hourly sprint updates in Gmail.
- **The headline is no longer EUR 3,997.** Jack caught it on 29 August: EUR
  1,500 is not a price Josh sells. The real offers are EUR 997 for the 16 week
  one to one, EUR 197 for the 8 week group and EUR 250 a month rolling. Two of
  the three stalled cards carry a CRM value that matches no product, so the
  page now reads "EUR 997 plus two unknowns" and the mis-pricing is itself the
  finding. Never re-add a total that sums unsourced CRM values.
- It ends without a win because there is not one yet. Do not add one.

### `index.html` specifics

- Prices are plain text in the markup, one spot each: search `&euro;39` and
  `&euro;249`.
- Every figure on it comes from the Notion Track Record page, Proven column
  only. 639 conversations, 106 unanswered, 22 appointments, 28 opportunities
  with 23 unmoved. If a number changes there, change it here.
- **The apply form does not post anywhere.** It validates, then shows the
  message and a copy button. Wire it to a real endpoint before the link goes
  out to anyone.
- The "What I have not done yet" section is deliberate, not filler. It is the
  honesty cap applied to Jack's own page. Do not quietly delete it to make the
  page sell harder.

## Previewing on a phone

The pages are full HTML documents, so they cannot be published as an Artifact
as-is. `scripts/build-artifact.py` strips the document wrapper into a
publishable body and writes it to `build/`:

```
python3 scripts/build-artifact.py movienight.html
python3 scripts/build-artifact.py vision-k7x9q2.html --banner "Vision build, written from August 2027. The figures, quotes and reviews on this page are imagined, not real yet."
```

`--banner` pins one line above the page. The vision build gets one because its
testimonials and figures read as real once the page is out of context, and an
Artifact link can be shared on. Keep it unless Jack says to drop it.

Then publish `build/<name>.artifact.html` with the Artifact tool. Re-run the
script and publish the same file path to update the same link:

| Page | Artifact |
| --- | --- |
| `index.html` | https://claude.ai/code/artifact/bf754532-e7a6-4a4b-b351-223d12eced03 |
| `teardown-01.html` | https://claude.ai/code/artifact/bd810181-71bc-475f-9526-2243e71d21b5 |
| `movienight.html` | https://claude.ai/code/artifact/a4460892-791b-4885-86f1-6658ebb4c674 |
| `vision-k7x9q2.html` | https://claude.ai/code/artifact/1ce07a3f-9675-4864-8e56-e670ab18b631 |

From a session that did not publish them, pass the URL above as `url` or a
second, separate artifact is created instead.

`build/` is gitignored and generated. Never edit anything in it, and never
treat it as the source of truth.

## Git

Jack reviews on a phone, so a commit that quietly contains something he did not
expect is expensive to spot and expensive to unpick. Three rules:

- **Always name the files: `git commit <paths>`.** A bare `git commit` commits
  whatever happens to be in the index, which is not necessarily what you just
  staged. This has already gone wrong once: a file that had been staged for an
  earlier, abandoned commit rode along in an unrelated one.
- **`git status --short` before committing, `git show --stat` after.** The first
  catches a stray staged file, the second proves what actually landed.
- **If something is refused, unstage it there and then.** A blocked file left in
  the index is a trap for the next commit. Then tell Jack it was refused rather
  than parking it and carrying on.

## Working with Jack

- He is usually on a phone. Keep replies short, lead with what changed, and do
  not paste long code blocks he has to scroll.
- Commit and push to the working branch as you go rather than saving it all up.
- If a change is visual, build and publish the artifact so he can look at it
  instead of reading a diff.
- Config and permission files go through the file tools, never a shell heredoc.
