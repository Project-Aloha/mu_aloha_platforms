#!/bin/bash
set -euo pipefail

if command -v avbtool >/dev/null 2>&1; then
    exit 0
fi

# Keep the standalone AOSP tool pinned for reproducible builds.
avb_revision=5ac0c3a071d811846a62412383dd6e259f341e6e
avb_tmp=$(mktemp)
trap 'rm -f "$avb_tmp"' EXIT

curl -fsSL --retry 3 \
    "https://android.googlesource.com/platform/external/avb/+/${avb_revision}/avbtool.py?format=TEXT" |
    base64 --decode > "$avb_tmp"
python3 "$avb_tmp" version
install -Dm755 "$avb_tmp" /usr/local/bin/avbtool
