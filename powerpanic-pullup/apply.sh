#!/usr/bin/env bash
# ABOUTME: Applies the power panic AC-fault pullup patch to a
# ABOUTME: Prusa-Firmware-Buddy tree.
set -euo pipefail

usage() {
    echo "usage: $0" >&2
    exit 2
}

[ $# -eq 0 ] || usage

kit_dir="$(cd "$(dirname "$0")" && pwd)"
repo_root="$(git rev-parse --show-toplevel)"

git -C "$repo_root" apply --verbose "$kit_dir/powerpanic-pullup.patch"

echo "power panic pullup patch applied; xBuddy acFault pin now has an internal pullup"
