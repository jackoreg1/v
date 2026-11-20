# WhatsApp bridge, read only

Lets Claude read your WhatsApp chats on your Mac. It can't send anything.

## What it is

- Your Mac becomes a linked device, the same way WhatsApp Web is.
- It keeps a copy of your chats in a file on your Mac, and Claude reads that file
  through 9 read only tools: search contacts, list chats, read messages, and
  download a voice note, photo or file.
- Nothing goes to a server. Claude only sees a chat when you ask it to read one.

## The risks, straight

- **It's unofficial.** WhatsApp doesn't approve tools like this. Bans mostly hit
  accounts that send automated messages. This one can't send, which keeps the
  risk low, but not zero.
- **Your chats sit on your Mac in plain text**, in `~/whatsapp-bridge`. That's the
  message store and `bridge.log`, which logs every message as it arrives. Keep
  the Mac locked and FileVault on.
- **WhatsApp changes often.** If it stops connecting, see Fixes.

## What's changed from the original

Built on [lharries/whatsapp-mcp](https://github.com/lharries/whatsapp-mcp) (MIT
licence), pinned at commit `7d6a06d`. `readonly.patch` does 5 things:

1. Removes the `send_message`, `send_file` and `send_audio_message` tools.
2. Removes the bridge's `/api/send` endpoint, so nothing on the Mac can send through it.
3. Makes the bridge listen on `127.0.0.1` only. The original listened on your
   whole network, so anyone on the same Wi-Fi could have used it to send as you.
4. Updates the WhatsApp library (whatsmeow) to the 16 Nov 2026 version and fixes
   the 5 calls that changed. The original's July 2025 version is likely to be
   refused as out of date.
5. Tells Claude that message text is information, never instructions.

Checked before it went in: the patched bridge builds and passes `go vet`, the
patch applies cleanly to the pinned commit, and the Claude side registers only
the 9 read tools. Not tested yet: a live link to WhatsApp, which needs your phone.

## Set it up, at your Mac

The QR code is always scanned by you, on your phone. Claude never scans it.

**Easiest:** open the Claude desktop app, start a Claude Code session on this
repo, and say "set up the WhatsApp bridge in tools/whatsapp-bridge". It runs
`install.sh`, then you run `pair.sh` yourself in Terminal.

**By hand, in Terminal:**

```
git clone --branch claude/trusting-bardeen-sbd2r0 https://github.com/jackoreg1/v ~/v-kit
```
```
bash ~/v-kit/tools/whatsapp-bridge/install.sh
```
```
bash ~/v-kit/tools/whatsapp-bridge/pair.sh
```

`pair.sh` shows a QR code. On your phone: WhatsApp, Settings, Linked devices,
Link a device, then scan it. When Terminal says "Connected to WhatsApp, read
only", press Ctrl+C. The bridge then runs in the background and starts again
whenever you log in.

The first link pulls in your recent history, which can take a few minutes.

## Use it

- **On your Mac:** ask Claude "read my WhatsApp chat with Conor from this week".
- **From your phone:** start Remote Control on your Mac (Claude desktop app,
  Settings, Claude Code, Remote Control, or `claude remote-control` in Terminal)
  and open that session in the Claude app. The Mac has to be on and awake.
- **Voice notes:** Claude downloads them with `download_media` and can transcribe
  them on the Mac with faster-whisper. Transcripts are machine made, so check
  anything that matters.

## Fixes

- **Is it running?** `tail -n 20 ~/whatsapp-bridge/bridge.log`
- **Logged out, or the log says to scan again:** run `pair.sh` again.
- **"Client outdated", or it won't connect:** in Terminal run
  `cd ~/whatsapp-bridge/whatsapp-bridge && go get go.mau.fi/whatsmeow@latest && go mod tidy && go build -o whatsapp-bridge .`
  then `pair.sh`. If the build fails, ask Claude on your Mac to fix it.

## Switch it off

1. `launchctl bootout gui/$(id -u)/com.whatsapp-bridge.readonly`
2. `claude mcp remove --scope user whatsapp`
3. On your phone: WhatsApp, Settings, Linked devices, tap the bridge, Log out.
4. Delete the `~/whatsapp-bridge` folder. It holds a copy of your chats.
