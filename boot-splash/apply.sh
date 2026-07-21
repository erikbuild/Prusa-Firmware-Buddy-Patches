#!/usr/bin/env bash
# ABOUTME: Applies the boot-splash customization patch to a Prusa-Firmware-Buddy
# ABOUTME: tree and installs the splash image and byline text.
set -euo pipefail

usage() {
    echo "usage: $0 [--image path/to.png] [--text \"by @you\"] [--version \"X.Y.Z+N\"]" >&2
    exit 2
}

kit_dir="$(cd "$(dirname "$0")" && pwd)"
image="$kit_dir/spedpony_256x152.png"
text=""
version=""

while [ $# -gt 0 ]; do
    case "$1" in
    --image)
        [ $# -ge 2 ] || usage
        image="$2"
        shift 2
        ;;
    --text)
        [ $# -ge 2 ] || usage
        text="$2"
        shift 2
        ;;
    --version)
        [ $# -ge 2 ] || usage
        version="$2"
        shift 2
        ;;
    *)
        usage
        ;;
    esac
done

case "$text" in
*'"'* | *'\'*)
    echo "error: --text must not contain quotes or backslashes" >&2
    exit 1
    ;;
esac

if [ -n "$version" ] && ! printf '%s' "$version" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+\+[0-9]+$'; then
    echo "error: --version must be X.Y.Z+N (e.g. 6.6.3+1)" >&2
    exit 1
fi

if [ ! -f "$image" ]; then
    echo "error: image not found: $image" >&2
    exit 1
fi
if [ "$(head -c 8 "$image" | xxd -p)" != "89504e470d0a1a0a" ]; then
    echo "error: not a PNG: $image" >&2
    exit 1
fi

repo_root="$(git rev-parse --show-toplevel)"

git -C "$repo_root" apply --verbose "$kit_dir/boot-splash.patch"

mkdir -p "$repo_root/src/gui/res/splash"
cp "$image" "$repo_root/src/gui/res/splash/splash_image.png"

if [ -n "$text" ]; then
    cat > "$repo_root/src/gui/splash_byline.hpp" <<EOF
#pragma once
// ABOUTME: Byline text drawn on the boot splash below the version line.
// ABOUTME: Rewritten by patches/boot-splash/apply.sh --text "by @you".

inline constexpr const char *splash_byline = "$text";
EOF
fi

if [ -n "$version" ]; then
    printf '%s\n' "$version" > "$repo_root/version.txt"
fi

echo "boot-splash patch applied; image installed at src/gui/res/splash/splash_image.png"
