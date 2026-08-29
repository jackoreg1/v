---
name: rep-burn-live
description: Run the Rep Burn Map with a field sales owner on a live call. The ten questions in order, the churn maths on his own numbers, and the six month map out of it. Use when Jack says "I have him on the phone", "run the burn map", "rep burn", "work out his churn", "he gave me his numbers", "what is this costing him", or is on or about to be on a call with a field sales owner.
---

# Running the Rep Burn Map on a live call

`rep-burn-map.html` in this repo is the tool. This skill is for when Jack has an
owner on the phone and cannot be tapping at a page while talking.

Take the answers as he reads them out, do the maths, and hand Jack the line to
say back. Everything here matches the page exactly, so what Jack says on the
phone and what the page would show are the same numbers.

## How to run it

Jack talks, Claude keeps the numbers. Ask him for answers as he gets them, in
order, and do not push for precision. **Guesses are fine, and saying so out loud
keeps the man talking.**

Three answers before the ten questions: business name, what the reps sell, how
many reps he has right now.

## The ten questions, in order, in his words

| # | Tag | Question | Key |
| --- | --- | --- | --- |
| 1 | Churn | How many reps did you take on in the last twelve months? Everyone who started, including the ones who lasted a fortnight. | `hired` |
| 2 | Churn | How many of those were gone inside three months? | `gone` |
| 3 | Ramp | How many weeks before a new rep makes their first sale? From their first day to money on the board. | `ramp` |
| 4 | Ramp | What does one rep cost you a week before they sell anything? Draw or basic, van, fuel, phone, kit, leads, and the hours somebody spends on them. | `cost` |
| 5 | Money | What does one sale put in the business? Gross profit, not the price the customer pays. | `gp` |
| 6 | Money | Your best rep against a middle one, sales a month in a normal month. | `best`, `avg` |
| 7 | Ramp | Who actually trains a new rep? | `train` |
| 8 | Control | Do you see every rep's numbers every week? | `track` |
| 9 | Leads | What happens to somebody who says not now, and roughly how many not nows a month? | `notnow`, `nncount` |
| 10 | Leads | Where do the reps' leads come from? | `leads` |

Question 5 is the one to get right. If he gives you the customer price, ask
again for gross profit. Every euro figure in the result hangs off it.

Questions 7 to 10 are multiple choice on the page. On a call just ask them open
and place his answer yourself.

## The maths, exactly as the page does it

`gone` is capped at `hired`. `stayed` is `hired - gone`.

```
burn    = gone * ramp * cost           the ones who never got past the ramp
slow    = stayed * (ramp / 2) * cost   the half of the ramp you could have skipped
gapFull = reps * (best - avg) * gp * 12
gapReal = min(reps * gp * 12, gapFull / 3)
nnValue = 0 if a system already brings them back
          else nncount * 12 * 0.05 * gp
total   = burn + slow + gapReal + nnValue
```

**The caps are the point, do not remove them to make a bigger number.**

- The gap to his best rep is shown in full but only ever **counted at a third**,
  and never more than one extra sale a month per rep.
- The not now pile is counted at **five in a hundred** coming good.
- If he already has a system bringing not nows back, that line is **zero**. Do
  not credit him for a problem he has already fixed.

Inflating any of these is off voice and it is bad selling. He knows his trade
better than you do and a number he does not believe ends the call.

## What each month of the map puts back

```
month 2, the ramp      = slow
month 3, the words     = gapReal
month 4, the not nows  = nnValue
month 5, the hiring    = burn / 2
recovered              = the four added up
```

Month 1 puts back nothing and that is deliberate, say so. **The map can never
put back more than was lost**, because every month is a slice of a number
already on the board. If a total ever exceeds `total`, the maths is wrong.

## The six months

1. **Put a scoreboard up.** Weeks 1 to 4. Buys the numbers, earns nothing.
2. **Fix the first fourteen days.**
3. **Take your best rep's words.**
4. **Work the not now pile.**
5. **Stop hiring people who cannot sell.**
6. **Make it hold without you.**

Three moves under each, 18 in total, in `rep-burn-map.html`. Read them from the
file rather than paraphrasing, they are written in Jack's voice already.

**The fixes ship in full.** Jack decided that against the advice, knowing his
model holds fixes back as the paid product. Do not hold them back on a call and
do not suggest turning the map into a teaser.

## Saying it back to him

Lead with the single biggest of the four numbers, not the total. The total
sounds like a sales pitch, one number he recognises sounds like the truth.

Then trace it: "that is your own four gone, times your own five weeks, times
your own six hundred." Every figure traces back to something he said. If you
cannot trace it, do not say it.

## After the call

Say plainly whether this moved a stranger closer to paying or only felt like
progress. A call that happened is progress. A nicer spreadsheet is not.

One action at the end, not three.
