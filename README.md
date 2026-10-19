# tv-debloat: Debloat Android TV & Google TV and Remove Ads (No Root, Nothing Installed on the TV)

**Make a slow, ad-filled Android TV or Google TV fast and clean again.** tv-debloat turns off
manufacturer bloatware, ad services and telemetry over Wi-Fi using ADB. No root, no cables, no app
installed on the TV, and every change can be undone.

Do it in one step with **Claude Code** (paste one prompt), or run the scripts yourself.

Works on **TCL, Xiaomi / Redmi / Mi TV, Hisense, Sony Bravia, OnePlus, Realme, Nvidia Shield,
Chromecast with Google TV** and most other Android TV and Google TV devices.

---

## Contents

- [Features](#features)
- [Quick start with Claude Code](#quick-start-with-claude-code)
- [Manual setup (macOS)](#manual-setup-macos)
- [Undo everything](#undo-everything)
- [Tools](#tools)
- [Supported TVs](#supported-tvs)
- [FAQ](#faq)
- [Troubleshooting](#troubleshooting)
- [Licence](#licence)

---

## Features

- **Nothing installed on the TV**: everything runs from your computer over ADB
- **No root needed**: apps are disabled with `pm disable-user`, never uninstalled
- **Remove bloat and ads**: manufacturer telemetry, promo pop-ups, content tabs, silent auto-installers
- **Safe by default**: the TV's home screen app is always skipped, so the Home button keeps working
- **Backup and one-command restore** before any change
- **Laptop remote control**: drive the TV with your keyboard, type passwords from your laptop
- **Screenshots from the TV** so every step can be checked

## Quick start with Claude Code

**1. Turn on USB debugging on the TV**

Settings → System → About → press OK on **Build** 7 times → back → **Developer options** → turn on
**USB debugging**. Keep the TV on and on the same Wi-Fi as your computer.

**2. Clone and open Claude Code**

```bash
git clone https://github.com/AryamanSi17/tv-debloat.git
cd tv-debloat
claude
```

**3. Paste the prompt from [PROMPT.md](PROMPT.md)**

Claude finds your TV, backs it up, asks which apps you use, debloats it and checks each step with
screenshots from the TV. Accept **"Allow USB debugging?"** on the TV when it appears.

## Manual setup (macOS)

```bash
./setup.sh                                                  # Python ADB client in tools/venv
tools/find-tv.sh                                            # find the TV on your Wi-Fi
tools/venv/bin/python -I tools/tv.py --probe                # show model and Android version
tools/backup.sh                                             # snapshot before changing anything
tools/disable.sh examples/tcl-google-tv-g07/debloat.txt     # disable bloat (or use your own list)
```

Write your own debloat list: one package name per line, `#` for comments. List the TV's packages
with `tools/venv/bin/python -I tools/tv.py 'pm list packages'`.

## Undo everything

```bash
tools/backup.sh --restore backup/<date>          # roll back to the snapshot
tools/restore.sh examples/<your-tv>/debloat.txt  # or re-enable everything in one list
```

## Tools

| Command | What it does |
|---|---|
| `tools/find-tv.sh` | Finds Android TVs on your Wi-Fi and saves the IP |
| `tools/tv.py` | Pure-Python ADB client: shell commands, batch, screenshots, file pull |
| `tools/backup.sh` | Snapshot app states, home app, device info and a screenshot; `--restore` rolls back |
| `tools/disable.sh <list>` | Disable every package in a debloat list (skips the home screen app) |
| `tools/restore.sh <list>` | Re-enable every package in a list |
| `tools/remote.sh` | Control the TV from your keyboard: arrows, Enter, Back, Home, play/pause, volume |
| `tools/type.sh "text"` | Type into the TV's on-screen keyboard; run with no text for hidden password input |

## Supported TVs

| Works | Doesn't work |
|---|---|
| Android TV and Google TV: TCL, Xiaomi / Redmi / Mi, Hisense, Sony, OnePlus, Realme, Nvidia Shield, Chromecast with Google TV | Samsung (Tizen), LG (webOS), Amazon Fire TV |

Ready-made debloat lists live in [examples/](examples/). Add one for your model.

## FAQ

**Does debloating Android TV need root?**
No. tv-debloat uses ADB over Wi-Fi and `pm disable-user`, which works on stock, unrooted TVs.

**Does it install anything on my TV?**
No. All commands run from your computer. Nothing is added to the TV; apps are only switched off.

**Is it safe? Can I undo it?**
Yes. Apps are disabled, never uninstalled, the home screen app is never touched, and
`tools/backup.sh --restore` puts everything back. A factory reset also re-enables all apps.

**How do I remove ads from the Google TV home screen?**
Disabling the manufacturer's promo apps and Google's auto-installer removes most of them. For the
recommendation rows on Google TV itself, turn on **Apps only mode** (Settings → Accounts & Sign In →
your account → Apps only mode); note it also turns off some Google features.

**Will my apps still update?**
Yes. Netflix, YouTube, Prime Video and other apps keep updating from the Play Store as normal.

**Why is my Android TV slow?**
Low-memory TVs (often 1.5 to 2 GB RAM) run many manufacturer services in the background. Disabling
them frees memory for the apps you actually use.

**Do I need Claude Code?**
No, the scripts work by hand. Claude Code just does the whole job for you from one prompt and
adapts to your TV model.

**Does it work on Windows or Linux?**
The scripts are written for macOS. Claude Code can usually adapt them; the `tools/tv.py` ADB client
itself is plain Python and runs anywhere.

## Troubleshooting

- **"No route to host" on macOS**: macOS blocks the `adb` binary on the local network. `tools/tv.py`
  uses the `adb-shell` Python package instead.
- **"Allow USB debugging?" never appears**: make sure the TV is on, then run `tools/tv.py --probe` again.
- **Only the first app got disabled**: chained `pm` commands can stop early. The scripts run one per call.
- **Something stopped working after debloating**: run `tools/restore.sh` on the list, then remove
  that app's line from the list.

## Licence

[MIT](LICENSE).
