# Getting the brain into git

Ten minutes at the Mac, once. After it, every phone session can read your
memory index, your skills and your client files instead of asking you to type
them out with your thumbs.

## Why

A Claude Code session started from the phone runs in a cloud container. It
clones the repos you point it at and nothing else. It cannot see
`~/Desktop`, it cannot see `/Users/jack`, it cannot see your Mac at all.

So on 29 Aug a session was asked to read the memory index and
`Clients/Funnell Clients/CLAUDE.md` and could read neither. It had the two
field sales pages only because they had been published as Artifacts and could
be pulled back out of them. Anything never published is invisible.

Git is the pipe. Push it once, and it is there every time.

## Before you start, two things that can bite

**Secrets.** A private repo is still a copy of your files leaving the Mac. Go
looking for API keys, tokens, client passwords and `.env` files first. The
gitignore below blocks the obvious shapes, but it cannot know what you named
things. If a key does get pushed, treat it as burned and rotate it, deleting
the commit is not enough.

**Size.** GitHub starts complaining around 50 MB a file and 1 GB a repo. The
Desktop is where videos and screenshots go to die. Step 3 checks the size
before anything is pushed, do not skip it.

## Step 1, the gitignore

Open Terminal. Paste the whole block.

```sh
cd ~/Desktop
cat > .gitignore <<'EOF'
# Mac junk
.DS_Store
._*
.Spotlight-V100
.Trashes

# secrets, never commit these
.env
.env.*
*.pem
*.key
*.p12
*credentials*
*secret*
*token*

# heavy stuff
*.mov
*.mp4
*.zip
*.dmg
*.pkg
*.sketch
*.psd
*.heic
node_modules/
build/
dist/
__pycache__/
.venv/
venv/
EOF
```

## Step 2, ignore any repo already inside Desktop

If `v`, `leak-finder`, `buyers-walk` or any other clone lives inside
`~/Desktop`, git will make a mess of it. This finds them and ignores them:

```sh
cd ~/Desktop
find . -mindepth 2 -maxdepth 4 -type d -name .git \
  | sed 's|^\./||; s|/\.git$|/|' >> .gitignore
tail -20 .gitignore
```

Run that once, not twice, it appends every time.

Look at what it printed. Those folders stay as their own repos, they are
already backed up separately.

## Step 3, look at what is about to go in

This is the step that matters. Nothing is committed yet.

```sh
cd ~/Desktop
git init
git add -A
echo "FILES: $(git diff --cached --name-only | wc -l | tr -d ' ')"
git count-objects -vH | grep -E '^(count|size):'
echo "--- 20 biggest ---"
git diff --cached --name-only -z | xargs -0 du -h 2>/dev/null | sort -rh | head -20
```

`git add -A` on a full Desktop can sit there for a minute. Let it.

Read the list. If the size is over about 200 MB, or something is in there you
do not want copied off the Mac, add it to `.gitignore`, then
`git rm -r --cached .` and `git add -A` and look again.

Check the dotfolders made it, this is the one people miss:

```sh
git diff --cached --name-only | grep "^\.claude/" | head
```

If that prints nothing, your skills are not going in. Say so and it gets fixed.

## Step 4, commit and push

Make the repo private first. Either:

```sh
gh repo create jackoreg1/brain --private --source=. --remote=origin
```

or, if `gh` is not installed, make an empty private repo called `brain` at
github.com/new, then:

```sh
cd ~/Desktop
git remote add origin https://github.com/jackoreg1/brain.git
```

Then:

```sh
cd ~/Desktop
git commit -m "The brain, first push"
git branch -M main
git push -u origin main
```

**Private, not public.** `jackoreg1/v` is public and that is a decision you
made about the field sales pages. This one holds client work and it is not the
same call.

## Step 5, from the phone

Start a Claude Code session and pick `jackoreg1/brain` as the repo, or say
"add jackoreg1/brain" mid session and it gets pulled in.

Two things then work that do not work today:

- Claude reads your memory index and your client files directly.
- Skills in `.claude/skills/` load at session start, so `/business-brain` and
  the rest are there on the phone, not just at the Mac.

## Step 6, keeping it current

The repo is only as good as the last push. When you finish at the Mac:

```sh
cd ~/Desktop && git add -A && git commit -m "today" && git push
```

If a phone session changes a file, pull before you work at the Mac again:

```sh
cd ~/Desktop && git pull
```

Forget that and you get two versions of the same file and a bad afternoon.

## What this does not solve

WhatsApp, the Instagram inbox and anything behind a login are still not
reachable from a cloud session. Those need the skills that drive your own
logged in Chrome, which means the Mac. Git fixes files, not logins.
