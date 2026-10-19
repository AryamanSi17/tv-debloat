#!/usr/bin/env bash
# Undo a debloat list: re-enable every package in it.
# Usage: tools/restore.sh <debloat list>
set -euo pipefail
cd "$(dirname "$0")/.."
LIST="${1:?usage: tools/restore.sh <debloat list>}"
PY="${PY:-tools/venv/bin/python}"
grep -vE '^\s*(#|$)' "$LIST" | awk '{print "pm enable " $1}' | "$PY" -I tools/tv.py --batch
echo "Restored."
