# CLAUDE.md

Notes for Claude working in this repo. Jack usually works from his phone, so
the point of this file is that Claude does not have to ask him things he would
have to answer with his thumbs.

## What this repo is

Five standalone, self-contained HTML pages. That is the whole repo.

| File | What it is |
| --- | --- |
| `vision-k7x9q2.html` | Jack's "vision build" of jackoregan.com, written as if it is August 2027. Home page, weekly post, Leak Finder quiz, the EUR 29 book sales page, an interactive reader for the book, the EUR 999 assessment funnel, and a funnel map. |
| `movienight.html` | A trailer-rating app. 61 films, score each 1-10, anything 7+ is kept on a shortlist that survives refreshes. |
| `getgoing.html` | The shop. Six things, each written up as a post with the first half free and the file itself behind a EUR 15 buy block. Bundle at EUR 69. |
| `promptvault.html` | Save, tag and search your own prompts. Blanks in double curly braces get filled in on the way to the clipboard. |
| `dinnertonight.html` | 45 dinners, score each 1-10, 7+ keeps it on a shortlist. Full ingredients and method for every one are in the file. |

## Hard rules

- **One file per page. Everything inline.** CSS in a single `<style>`, JS in a
  single `<script>`, no imports, no bundler, no framework, no external assets.
  A page must work by double-tapping the file with no network.
- **No dependencies and no build step.** Do not add npm, a package.json, a
  config file, or a toolchain. If a change seems to need one, the change is
  wrong.
- **No tracking, no analytics, no third-party scripts.** `vision-k7x9q2.html`
  is deliberately `noindex,nofollow`.
- **Mobile first.** Every page here is designed to be used on a phone. Check any
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
- **No em dashes.** There are none in the copy. Do not introduce any.
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

### `getgoing.html`

- **The six products are `P`**, an array of
  `{id, kind, t, hook, mins, free, eg, gets}`. `free` is the half that is
  given away, as an HTML string. `gets` is the bullet list of what is behind
  the buy block. Adding a product means appending one entry to `P` **and**
  adding a matching key to `BUY`. The index list, the posts and the numbering
  all render off `P`, so nothing else needs touching.
- **Checkout links live in one object, `BUY`, at the top of the script.** One
  key per product id plus `bundle`. They are plain `href`s, so a Stripe
  Payment Link, a Gumroad URL or a systeme.io URL all work the same and none
  of them puts a third-party script on the page. An empty string renders a
  dashed grey "checkout link not set yet" button instead of a dead link, and
  the footer quietly counts how many are still missing. That footer line
  disappears on its own once they are all filled in.
- **No paid content is in this file and none ever goes in.** The locked half
  is described, not included, because anything in the HTML can be read from
  view source. Delivery is whatever the checkout link uses.
- **Nothing persists.** No `localStorage`, no state, no tracking. The only JS
  is the render loop and the smooth scroll on the top bar button.
- **Serif for reading, system sans for anything you tap.** `--serif` is the
  stack the phone already has, nothing is loaded over the network. The one
  repeated device is `.lab`, the small tracked-out uppercase label used for
  eyebrows, the contents heading, the example labels and the cut marker.
- **The green is `#0e6b45`** again, same as the vision build.

**The audience decides what belongs on this page.** It is aimed at people who
have just started using Claude, not at Jack's own clients, so the nine private
work skills came off it on 30 Aug. `whats-real`, `josh-daily`, `leak-hunt`,
`read-whatsapp-thread` and the rest are no use to somebody with no client and
no CRM, and three of them name a client and carry a live account id, a location
id and API ids. Do not put them back. `future-jack` and
`online-business-action-partner` stayed because they work for anybody.

**Anything new goes on this page as a tool, not a document.** Something you
open and use in ten minutes, not something you read.

### `promptvault.html`

- **State is one key, `promptvault1`**, shaped `{v:1, items:[{id, title, body,
  tags, fav, uses, created, updated}]}`. Every read and write is wrapped,
  because a browser in private mode throws on both.
- **The blanks are the product.** `varsIn()` pulls `{{name}}` out of a body,
  `filledText()` substitutes with `split().join()` so a repeated blank is asked
  once and filled everywhere. An unfilled blank is left in place rather than
  replaced with nothing, and the copy toast says how many are still blank.
- **`copyText()` always has the textarea fallback behind it.** The async
  clipboard API is missing or blocked on a `file://` page in some browsers, and
  a buyer opening this from Files is exactly that case.
- Twelve seed prompts in `SEED` so it is useful on first open. `seedState()`
  is what Reset goes back to.
- Backup is not decoration. localStorage is one cleared cache from losing the
  lot, so there is copy, download and paste-to-restore.
- `MADE_BY` and `HOME` at the top of the script are the only mention of the
  outside world. `HOME` empty renders the name with no link. Same pair sits in
  `dinnertonight.html`. Fill them in before selling.

### `dinnertonight.html`

- **The 45 dinners are `D`**, entries of `{n, m, b, g, i, s}`: name, minutes,
  blurb, comma separated tags, ingredients array, steps array. Adding one means
  appending an entry, nothing else.
- **Same state shape as `movienight.html`**, one key `dinnertonight1` holding
  `{seen, short, bin}`. `n` is the index into `D`, so reordering `D` invalidates
  saved state. If the order ever has to change, change `KEY` too.
- The whole method is in the file on purpose. That is the thing worth paying
  for, not the scoring, so never replace a recipe with a link.
- Cook mode step ticks are deliberately not persisted. They are for one meal.

## Selling these

`docs/buyer-readme.md` is the text that ships with a download. It exists because
the buyer is somebody who has never opened a file that was not a photo, and the
first support email is always "how do I open this". It covers saving the file,
adding it to the home screen, and the one thing that catches everybody: state
lives in the browser it was opened in, so a different browser is a different
set of saved stuff. Keep it in that voice and keep it honest about the tradeoff.

**Not verified: iOS.** Everything here was checked in headless Chromium, opened
over `file://` as a buyer would, including that saved state survives a reload
and that blocked storage does not crash the page. Nobody has yet confirmed a
real iPhone opening one of these out of Files and keeping its state. That is a
two minute job on Jack's own phone and it needs doing before money changes
hands, because the audience is phone first.

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
| `movienight.html` | https://claude.ai/code/artifact/a4460892-791b-4885-86f1-6658ebb4c674 |
| `vision-k7x9q2.html` | https://claude.ai/code/artifact/1ce07a3f-9675-4864-8e56-e670ab18b631 |
| `getgoing.html` | https://claude.ai/code/artifact/427562e0-49b2-436a-bb64-0d994c743870 |
| `promptvault.html` | https://claude.ai/code/artifact/a3b3ec6a-f682-4676-bc56-c7f328cacb8f |
| `dinnertonight.html` | https://claude.ai/code/artifact/e6001ca1-d3dc-45ca-8744-c21a27033a37 |

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
