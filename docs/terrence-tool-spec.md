# Build spec: the Terrence 30 day tool

Paste-free brief. Open a new code chat on this repo and say "build
`terrence30.html` to `docs/terrence-tool-spec.md`". Everything needed is here.

## What it is

A private single page tool Jack uses to run a paid 30 day 1:1 direction
engagement. Terrence sends him what he is stuck on, Jack tells him straight
whether he is in his lane or drifting, and Jack logs both. At day 30 the log
prints as a case study.

Jack uses it on his phone, usually within a minute of texting Terrence back.
That is the whole design constraint. Thumb reach, one screen, no ceremony.

## The client, baked in

This engagement is one client, so hardcode him. No client switcher, no setup
wizard. The context is fixed reference material the verdict gets measured
against, so it belongs on screen, not in Jack's head.

- **Terrence.** Runs ads and marketing for other people's brands.
- **ICP:** bigger personal brands and ecom accounts.
- **Current clients:** a seven figure Arabic streetwear ecom brand, and a
  YouTuber with 48k subscribers.
- **Blockers going in, the three things drifting is measured against:**
  1. Content reads flat, not polarizing.
  2. Does not feel good charging for his own work.
  3. 60% of his X audience is the wrong geography for who he wants to attract.

Those three sit in a panel Jack can see while he writes the verdict. That is
what turns this from a diary into a judgement tool.

## Hard constraints

Same house rules as the rest of this repo, see `CLAUDE.md`:

- One file, `terrence30.html`. CSS in one `<style>`, JS in one `<script>`.
- No dependencies, no build step, no imports, no external assets, no fonts
  loaded over the network. It must work opened from Files with aeroplane mode
  on.
- No login, no backend, no analytics, nothing leaves the page.
- Mobile first. Check every layout narrow before wide.
- Dark or light, either is fine. Pick one and do it properly.
- No em dashes anywhere in the copy.

**This file is private and never gets published as an Artifact.** It holds a
named client's paid-for problems. The artifact workflow in `CLAUDE.md` applies
to the other two pages, not this one.

## The five decisions, answered

These are the things a builder would otherwise guess at. They are settled.

### 1. Day N is calendar derived, not entry derived

Jack sets a start date once, on first open. `day = daysBetween(startDate, today) + 1`,
clamped to 1..30. Never count entries.

If he misses a day, that day stays visibly empty forever. That is deliberate.
A gap is honest, and a gap in a paid daily engagement is information both for
Jack and for the case study. Do not backfill, do not renumber, do not hide it.

Let him edit the start date afterwards in case he sets it wrong, but warn that
it re-dates the whole log.

### 2. JSON export and import, not just the day 30 print

Non negotiable, this is the one that matters. `localStorage` is one cleared
cache from losing 30 days of a paid engagement, and Jack has already been
bitten once by having no backup of a client build.

- **Export:** a button that produces the whole state as JSON.
- **Import:** paste JSON back in, replacing state, with a confirm step.
- On iOS Safari a blob download can silently do nothing, so ship **two** ways
  out: a `<a download>` blob link **and** a "copy JSON" button using
  `navigator.clipboard.writeText` with a `<textarea>` select fallback. Do not
  rely on the download alone.
- Nudge him to export weekly. A quiet line on the summary screen is enough,
  not a modal.

### 3. Entries are editable and deletable

He is typing on a phone straight after texting. He will fat-finger one. Edit in
place, delete behind a confirm.

### 4. More than one entry a day is allowed

Some days Terrence sends twice. Multiple entries share a day number, sort
newest first within the day. The summary treats a day as "on lane" or
"drifting" by the last verdict logged that day, and shows a small marker when a
day holds more than one entry.

### 5. The three blockers are on screen while logging

See the client section above. Not decoration, it is the rubric.

## Data model

One `localStorage` key. Keep it boring and versioned so a later change does not
silently eat the log.

```
KEY = 'terrence30'

{
  v: 1,
  startDate: '2026-08-28',        // ISO date, set once on first open
  entries: [
    {
      id:      't7k2p',            // any stable unique string
      ts:      1756...,            // epoch ms, when logged
      date:    '2026-08-28',       // ISO date the entry belongs to
      sent:    'what he sent me',
      told:    'what I told him',
      verdict: 'lane'              // 'lane' | 'drift'
    }
  ]
}
```

`day` is derived from `date` and `startDate` at render time, never stored. Wrap
every read and write in try/catch, and render correctly when storage comes back
empty or throws.

## Screens

Four, switched by a tab bar fixed within thumb reach. No routing needed, but if
it helps, follow the hash pattern already used in `vision-k7x9q2.html`.

**Today.** The default landing screen. Big "Day 12 of 30" at the top. Two
textareas, "What he sent" and "What I told him". Two verdict buttons, "On lane"
and "Drifting", styled clearly apart. Save. The three blockers panel sits under
the form, collapsed by default after the first few days. If today already has an
entry, show it and offer "log another".

**Log.** Every entry, most recent first, each showing its date, day number,
both texts, and its verdict as a coloured chip. Edit and delete on each.

**Summary.** The 30 days at a glance. A grid of 30 cells, one per day, in three
states: on lane, drifting, nothing logged. Under it the counts: days logged out
of days elapsed, on lane vs drifting, current streak, and the longest run of
drifting days. That last one is the number that tells Jack whether his direction
is landing or whether he is repeating himself.

**Case study.** The day 30 output, and readable before then. One clean page,
chronological, oldest first, reading as "this is what he brought me, this is
what I told him". A print stylesheet that drops the tab bar, buttons and
blockers panel, sets a light ground and black text regardless of the app theme,
and avoids breaking an entry across pages. A print button calling
`window.print()`, which gets Jack to PDF from the iOS share sheet.

Keep the client's name in it. It is a private case study for Jack, not a
published testimonial, and it never leaves his device unless he sends it.

## Copy

Jack's voice, per `CLAUDE.md`. Irish, plain, short. "On lane" and "Drifting" are
his words, use them exactly. Nothing motivational, no streak celebration, no
emoji. This is a work log for something he is being paid €800 to do.

## After the build

- Add a third row to the table in `CLAUDE.md` describing this page, and a
  section on how it works, matching the two that are there.
- Note in `CLAUDE.md` that this page is private and is never published as an
  Artifact.
- Commit naming the files, per the Git section of `CLAUDE.md`.
