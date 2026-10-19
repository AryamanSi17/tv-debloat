#!/usr/bin/env bash
# One-time setup on your computer: a Python ADB client in tools/venv. Nothing is installed on the TV.
set -euo pipefail
cd "$(dirname "$0")"
python3 -m venv tools/venv
tools/venv/bin/pip install -q --no-cache-dir -r tools/requirements.txt
echo "✓ Python ADB client in tools/venv"
