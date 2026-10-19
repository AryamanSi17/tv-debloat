#!/usr/bin/env bash
# Disable every package in a debloat list (one pm call per shell command; chained pm calls can stop early).
# Packages are disabled for user 0, never uninstalled. Undo with tools/restore.sh <same list>.
# The TV's home screen app and its fallback are always skipped, so Home keeps working.
# Usage: tools/disable.sh examples/tcl-google-tv-g07/debloat.txt
set -euo pipefail
cd "$(dirname "$0")/.."
LIST="${1:?usage: tools/disable.sh <debloat list>}"
PY="${PY:-tools/venv/bin/python}"
home=$("$PY" -I tools/tv.py "cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME" \
  | tr -d '\r' | grep / | tail -1)
keep="${home%%/*} com.google.android.tungsten.setupwraith"
grep -vE '^\s*(#|$)' "$LIST" | awk -v keep="$keep" '
  BEGIN { n = split(keep, k, " "); for (i = 1; i <= n; i++) skip[k[i]] = 1 }
  skip[$1] { print "skipping " $1 " (home screen)" > "/dev/stderr"; next }
  { print "pm disable-user --user 0 " $1 }' \
  | "$PY" -I tools/tv.py --batch
