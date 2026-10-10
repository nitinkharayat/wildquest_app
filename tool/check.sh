#!/usr/bin/env bash
set -euo pipefail

if command -v flutter >/dev/null 2>&1; then
  flutter pub get
  flutter analyze
  flutter test
else
  echo "Flutter SDK not found; skipping Flutter analyze/test." >&2
fi

if command -v python3 >/dev/null 2>&1; then
  python3 -m py_compile backend/main.py
fi

echo "WildQuest checks completed."
