#!/usr/bin/env bash
# Drive the TV from your laptop keyboard over one ADB connection.
#   arrows move · Enter OK · Backspace/b back · h home · m menu · space play/pause · +/- volume · q quit
set -euo pipefail
cd "$(dirname "$0")/.."
PY="${PY:-tools/venv/bin/python}"
echo "arrows move · Enter OK · Backspace/b back · h home · m menu · space play/pause · +/- volume · q quit"
while IFS= read -rsn1 k; do
  if [ "$k" = $'\e' ]; then read -rsn2 k; fi
  case "$k" in
    '[A') key=DPAD_UP ;; '[B') key=DPAD_DOWN ;; '[C') key=DPAD_RIGHT ;; '[D') key=DPAD_LEFT ;;
    '') key=DPAD_CENTER ;; $'\x7f'|b) key=BACK ;; h) key=HOME ;; m) key=MENU ;;
    ' ') key=MEDIA_PLAY_PAUSE ;; +|=) key=VOLUME_UP ;; -) key=VOLUME_DOWN ;;
    q) break ;; *) continue ;;
  esac
  echo "input keyevent KEYCODE_$key"
done | "$PY" -I tools/tv.py --batch >/dev/null
