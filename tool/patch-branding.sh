#!/usr/bin/env bash
# After `flutter create`, rename generated runners' display names to "Weekra".
# The runners are regenerated on every build (CI and local), so this patch must
# run right after each `flutter create` invocation.
# Usage: bash tool/patch-branding.sh   (run from the repo root)
set -euo pipefail
cd "$(dirname "$0")/.."

patched=0

# Windows native window title (windows/runner/main.cpp)
if [ -f windows/runner/main.cpp ]; then
  sed -i 's/window.Create(L"weekra"/window.Create(L"Weekra"/' windows/runner/main.cpp
  patched=$((patched + 1))
fi

# Android launcher label (android/app/src/main/AndroidManifest.xml)
if [ -f android/app/src/main/AndroidManifest.xml ]; then
  sed -i 's/android:label="weekra"/android:label="Weekra"/' android/app/src/main/AndroidManifest.xml
  patched=$((patched + 1))
fi

# Fail loudly if a lowercase display name is still present in a generated runner.
left=$(grep -rln 'Create(L"weekra"\|android:label="weekra"' windows/runner android/app/src 2>/dev/null || true)
if [ -n "$left" ]; then
  echo "patch-branding: FAIL — still lowercase in: $left" >&2
  exit 1
fi

echo "patch-branding: OK ($patched file(s) patched)"
