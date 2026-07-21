#!/usr/bin/env bash
# ABOUTME: Applies the G751 squiggly purge patch to a Prusa-Firmware-Buddy
# ABOUTME: tree.
set -euo pipefail

usage() {
    echo "usage: $0" >&2
    exit 2
}

[ $# -eq 0 ] || usage

kit_dir="$(cd "$(dirname "$0")" && pwd)"
repo_root="$(git rev-parse --show-toplevel)"

git -C "$repo_root" apply --verbose "$kit_dir/g751-squiggly-purge.patch"

echo "G751 squiggly purge patch applied"
