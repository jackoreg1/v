# CLAUDE.md

Notes for Claude working in this repo. Jack usually works from his phone, so
the point of this file is that Claude does not have to ask him things he would
have to answer with his thumbs.

## What this repo is

Standalone, self-contained HTML pages. One file each, no build.

| File | What it is |
| --- | --- |
| `unworked-hundred.html` | 100 Irish markets that have money, have the problems Jack fixes, and have had no AI or systems person near them. Scored, filterable, and each one carries the way in and an opening question. Star it or Start it. |
| `rep-burn-map.html` | Ten questions to a field sales owner, then what rep churn cost him last year and a six month map out of it. Six months, 18 moves, in full detail. |
| `vision-k7x9q2.html` | Jack's "vision build" of jackoregan.com, written as if it is August 2027. Home page, weekly post, Leak Finder quiz, the EUR 29 book sales page, an interactive reader for the book, the EUR 999 assessment funnel, and a funnel map. |
| `movienight.html` | A trailer-rating app. 61 films, score each 1-10, anything 7+ is kept on a shortlist that survives refreshes. |

The first two are the live field sales tools. They came into git late, recovered
out of their published Artifacts, so treat this repo as the source of truth for
them from now on rather than whatever copy is on the Mac.

This repo is public and Jack decided on 29 Aug to keep it that way, having been
told the 100 markets and their openers are readable by anyone. Settled, do not
raise it again. The brain repo is the private one.

## Hard rules

- **One file per page. Everything inline.** CSS in a single `<style>`, JS in a
  single `<script>`, no imports, no bundler, no framework, no external assets.
  A page must work by double-tapping the file with no network.
  Two exceptions, both known and both in the field sales pages. They pull their
  fonts from Google Fonts over the network, and `rep-burn-map.html` splits its
  JS into two `<script>` blocks, data then logic. With no network they fall back
  to the system stack and still work, so it is a look problem, not a broken page.
  Do not fix either one without asking Jack, the fix changes how they look.
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

### `unworked-hundred.html`

- **The list is `D`**, one row per market:
  `[name, category, money, pain, untouched, why the money is there, what you fix,
  the warm way in, top pick rank]`. The three scores are 1 to 5 and the total is
  their sum, computed in `ROWS`, never stored. `top` is 0 for everything except
  the eight picks, which are ranked 1 to 8. Adding a market means appending one
  row, categories come out of the data itself via `CATS`.
- **`EXTRA` is keyed by the market name, not the index**, and holds
  `[opening question, timing note]`. The timing note is empty on the ones where
  season does not matter, which is why only 22 of them show timing. `TOP_NOTES`
  is keyed by top pick rank, 1 to 8, and is the line about why that one is a pick.
  Rename a market and you have to rename its `EXTRA` key too, nothing warns you.
- **Marks persist** in `localStorage` under `unworked-hundred-marks-v2`, shaped
  `{ "market name": "star" | "start" }`. The older key
  `unworked-hundred-stars` was a plain array of starred names and is still read
  once and carried over, so do not delete that fallback.
- **Start this one is the point of the page.** It produces the brief Jack copies
  into the business brain, which is where the actual plan gets written. Star is
  only a maybe. There is no AI in the page and there cannot be one, so never
  build towards an in-page answer.

### `rep-burn-map.html`

- **`Q` is the questions**, each `{id, tag, title, hint, fields}` with each field
  `{k, t, l}` where `t` is `text` or `num`. The first entry, `id:"start"`, is the
  intro screen carrying three fields, so `Q` is 11 entries for 10 questions.
  `k` is the answer key and it is load-bearing, the maths reads answers by `k`.
- **`MAP` is the six months**, each `{n, t, tag, val, why, moves}` with three
  `{h, p, how}` moves under each, 18 in total. They ship in full detail. That is
  deliberate and Jack decided it against the advice, the fixes are not held back
  here. Do not "correct" it back to a teaser.
- **State persists** in `localStorage` under `rep-burn-map-v1`, holding the
  answers, which months are open, and where he was. Every read and write is in a
  try/catch already, keep it that way.
- **Two `<script>` blocks on purpose**, data first then logic. See the note in
  Hard rules.
- Colours are the `:root` custom properties. `--burn` is the cost of the churn,
  `--climb` is the way out. Light and dark are both defined properly, do not
  add a colour that only exists inside one of the media blocks.

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
| `unworked-hundred.html` | https://claude.ai/code/artifact/a989592d-d9bc-481b-b938-117bdf21c749 |
| `rep-burn-map.html` | https://claude.ai/code/artifact/e152290f-485a-4be7-bec2-9f24d7fb9c93 |
| `movienight.html` | https://claude.ai/code/artifact/a4460892-791b-4885-86f1-6658ebb4c674 |
| `vision-k7x9q2.html` | https://claude.ai/code/artifact/1ce07a3f-9675-4864-8e56-e670ab18b631 |

`unworked-hundred.html` is also deployed at https://unworked-hundred.vercel.app.
That deployment is a temporary one, it was pushed without a login. To make it
permanently Jack's: `vercel login`, then `vercel deploy --prod` from the page's
own folder.

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

## What is not in this repo

A session started from the phone runs in a cloud container. It clones the repos
it is pointed at and can see nothing else. No `~/Desktop`, no `/Users/jack`, no
Mac at all.

So the memory index, the skills, the client folders, the Josh files and
`assessment-business/offer-and-pricing.md` are all invisible from a phone
session unless they are in git. Do not tell Jack to check them, you cannot,
and do not work off a guess about what they say. Ask him or say you cannot see
them.

`docs/brain-repo-setup.md` is the ten minutes at the Mac that fixes this by
pushing the Desktop to a private `jackoreg1/brain` repo. Once that exists, ask
for it to be added to the session and the rest of his work is readable.

Outbound network is restricted too. `unworked-hundred.vercel.app` could not be
fetched from a session on 29 Aug, so recovering a page meant reading it back
out of its published Artifact.

## Working with Jack

- He is usually on a phone. Keep replies short, lead with what changed, and do
  not paste long code blocks he has to scroll.
- Commit and push to the working branch as you go rather than saving it all up.
- If a change is visual, build and publish the artifact so he can look at it
  instead of reading a diff.
- Config and permission files go through the file tools, never a shell heredoc.
