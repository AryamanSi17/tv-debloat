# tv-debloat: Debloat Android TV & Google TV and Remove Ads (No Root)

**Make a slow, ad-filled Android TV or Google TV fast and clean again.** tv-debloat removes
manufacturer bloatware, ads and telemetry over Wi-Fi, then replaces the cluttered home screen with
a fast, minimal, Apple TV-style launcher. No root, no PC cables, fully reversible.

Do it in one step with **Claude Code** (paste one prompt), or run the scripts yourself.

Works on **TCL, Xiaomi / Redmi / Mi TV, Hisense, Sony Bravia, OnePlus, Realme, Nvidia Shield,
Chromecast with Google TV** and most other Android TV and Google TV devices.

---

## Contents

- [Features](#features)
- [Quick start with Claude Code](#quick-start-with-claude-code)
- [Manual setup (macOS)](#manual-setup-macos)
- [Undo everything](#undo-everything)
- [The home screen launcher](#the-home-screen-launcher)
- [Tools](#tools)
- [Supported TVs](#supported-tvs)
- [FAQ](#faq)
- [Troubleshooting](#troubleshooting)
- [Licence](#licence)

---

## Features

- **Remove ads and sponsored rows** from the Android TV / Google TV home screen
- **Debloat preinstalled apps**: manufacturer telemetry, promo pop-ups, content tabs, auto-installers
- **No root needed**: uses ADB over Wi-Fi; apps are disabled, never uninstalled
- **Backup and one-command restore** before any change
- **Minimal Apple TV-style launcher**: clock, app dock, all-apps grid, rotating nature wallpapers
- **Rearrange the dock from your remote**: pin, reorder or hide apps without rebuilding
- **Ambient mode**: after a few idle minutes only the wallpaper and clock stay on screen
- **Laptop remote control**: drive the TV with your keyboard, type passwords from your laptop
- **Lightweight**: no network access, no background services, no tracking

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

Claude finds your TV, backs it up, asks which apps you use, debloats it, installs the launcher and
checks each step with screenshots from the TV. Accept **"Allow USB debugging?"** on the TV when it
appears.

## Manual setup (macOS)

```bash
./setup.sh                                                  # Python ADB client, JDK 17, Android SDK
tools/find-tv.sh                                            # find the TV on your Wi-Fi
tools/venv/bin/python -I tools/tv.py --probe                # show model and Android version
tools/backup.sh                                             # snapshot before changing anything
tools/disable.sh examples/tcl-google-tv-g07/debloat.txt     # disable bloat (or use your own list)
launcher/build-and-install.sh                               # build and install the launcher
```

Write your own debloat list: one package name per line, `#` for comments. List the TV's packages
with `tools/venv/bin/python -I tools/tv.py 'pm list packages'`.

## Undo everything

```bash
tools/backup.sh --restore backup/<date>          # roll back to the snapshot
tools/restore.sh examples/<your-tv>/debloat.txt  # or re-enable one debloat list and the stock launcher
```

## The home screen launcher

| | |
|---|---|
| **Header** | Clock, greeting, date; pills for **Inputs** (HDMI / AV / Live TV), **Wi-Fi** and **Settings** |
| **Dock** | Your favourite apps, with a glow coloured from the focused app's banner |
| **All apps** | Press Down for every other app in a grid |
| **Edit on the TV** | Long-press OK (or press Menu) on an app: add to dock, move left/right, remove, hide, app info |
| **Ambient mode** | After 3 idle minutes the UI fades to wallpaper and clock; any key wakes it |
| **Wallpapers** | 12 nature photos crossfade every 10 minutes |

Change the defaults in [launcher/res/values/config.xml](launcher/res/values/config.xml) (default dock,
hidden apps, Live TV app, grid columns, ambient delay), then run `launcher/build-and-install.sh`.
Swap wallpapers in `launcher/assets/wallpapers/` (1920×1080 JPEGs).

## Tools

| Command | What it does |
|---|---|
| `tools/find-tv.sh` | Finds Android TVs on your Wi-Fi and saves the IP |
| `tools/tv.py` | Pure-Python ADB client: shell commands, batch, screenshots, APK upload |
| `tools/backup.sh` | Snapshot app states, home app, device info and a screenshot; `--restore` rolls back |
| `tools/disable.sh <list>` | Disable every package in a debloat list |
| `tools/restore.sh <list>` | Re-enable a list and the stock launcher |
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

**Is it safe? Can I undo it?**
Yes. Apps are disabled, never uninstalled, and `tools/backup.sh --restore` puts everything back.
A factory reset also restores all apps.

**How do I remove ads from the Google TV home screen?**
The ads come from the stock launcher. tv-debloat disables it and installs a clean launcher with no
recommendations, no sponsored rows and no network access.

**Will my apps still update?**
Yes. Netflix, YouTube, Prime Video and other apps keep updating from the Play Store as normal.

**Why is my Android TV slow?**
Low-memory TVs (often 1.5 to 2 GB RAM) run many manufacturer services and a heavy launcher in the
background. Disabling them frees memory for the apps you actually use.

**Do I need Claude Code?**
No, the scripts work by hand. Claude Code just does the whole job for you from one prompt and
adapts to your TV model.

**Does it work on Windows or Linux?**
The scripts are written for macOS. Claude Code can usually adapt them; the `tools/tv.py` ADB client
itself is plain Python and runs anywhere.

## Troubleshooting

- **"No route to host" on macOS**: macOS blocks the `adb` binary on the local network. `tools/tv.py`
  uses the `adb-shell` Python package instead.
- **Home button opens the old launcher (Google TV)**: disable `com.google.android.tungsten.setupwraith`.
  The install script does this; `restore.sh` re-enables it.
- **Home opens the launcher behind the current app**: force-stop `com.android.tv.settings` and press
  Home. The install script does this.
- **Only the first app got disabled**: chained `pm` commands can stop early. The scripts run one per call.
- **A newly installed app doesn't appear**: go back to the home screen; the launcher rechecks
  installed apps every time it opens.

## Licence

Code is [MIT](LICENSE). Wallpaper photos are from Wikimedia Commons under their own licences, see
[launcher/WALLPAPER-CREDITS.md](launcher/WALLPAPER-CREDITS.md).
