#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source_root="$(cd -- "$script_dir/.." && pwd)"
common_dir="$source_root/moonlight-common-c/moonlight-common-c"
patch_file="$source_root/patches/0001-rfi-congestion-recovery.patch"

if git -C "$common_dir" apply --check "$patch_file" 2>/dev/null; then
    echo "Applying RFI congestion-recovery patch to moonlight-common-c"
    git -C "$common_dir" apply "$patch_file"
elif git -C "$common_dir" apply --reverse --check "$patch_file" 2>/dev/null; then
    echo "RFI congestion-recovery patch is already applied"
else
    echo "moonlight-common-c does not match the expected pinned revision" >&2
    git -C "$common_dir" diff -- src/ControlStream.c src/VideoDepacketizer.c >&2
    exit 1
fi
