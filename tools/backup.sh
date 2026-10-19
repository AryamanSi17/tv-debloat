#!/usr/bin/env bash
# Snapshot the TV before changing anything, and roll back to that snapshot later.
#   tools/backup.sh                         save to backup/<timestamp>/
#   tools/backup.sh --restore backup/<dir>  re-enable every package that was enabled then, restore the home app
set -euo pipefail
cd "$(dirname "$0")/.."
PY="${PY:-tools/venv/bin/python}"
tv() { "$PY" -I tools/tv.py "$@"; }
pkgs() { tv "pm list packages $1" | sed -n 's/^package://p' | tr -d '\r' | sort; }

if [ "${1:-}" = "--restore" ]; then
  DIR="${2:?usage: tools/backup.sh --restore backup/<dir>}"
  {
    comm -12 "$DIR/enabled.txt" <(pkgs -d) | awk '{print "pm enable " $1}'
    echo "cmd package set-home-activity --user 0 $(cat "$DIR/home.txt")"
    echo "input keyevent KEYCODE_HOME"
  } | "$PY" -I tools/tv.py --batch
  echo "Restored to $DIR. Press Home on the remote."
  exit 0
fi

DIR="backup/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$DIR"
tv --probe > "$DIR/device.txt"
pkgs -e > "$DIR/enabled.txt"
pkgs -d > "$DIR/disabled.txt"
tv "cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME" \
  | tr -d '\r' | grep / | tail -1 > "$DIR/home.txt"
tv --shot "$DIR/home.png" >/dev/null
echo "Saved $DIR ($(wc -l < "$DIR/enabled.txt" | tr -d ' ') enabled, $(wc -l < "$DIR/disabled.txt" | tr -d ' ') disabled, home: $(cat "$DIR/home.txt"))"
echo "Undo later with: tools/backup.sh --restore $DIR"
