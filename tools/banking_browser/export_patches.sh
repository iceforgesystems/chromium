#!/usr/bin/env bash
# Export the current branch as an ordered git-format-patch stack.

set -euo pipefail

usage() {
  cat >&2 <<'USAGE'
Usage: tools/banking_browser/export_patches.sh <base-ref> <patch-dir>

Exports commits in <base-ref>..HEAD into <patch-dir> and writes a series file
next to the patch directory.

Example:
  tools/banking_browser/export_patches.sh banking/base/m126 ../banking-browser-patches/patches
USAGE
}

if [[ $# -ne 2 ]]; then
  usage
  exit 2
fi

base_ref=$1
patch_dir=$2
series_file="$(dirname "${patch_dir}")/series"

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "error: must be run from inside a Git checkout" >&2
  exit 1
fi

if ! git rev-parse --verify --quiet "${base_ref}^{commit}" >/dev/null; then
  echo "error: base ref '${base_ref}' does not exist" >&2
  exit 1
fi

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "error: working tree has unstaged or staged changes; commit or stash first" >&2
  exit 1
fi

mkdir -p "${patch_dir}"
rm -f "${patch_dir}"/*.patch

if [[ -z $(git rev-list --count "${base_ref}..HEAD") || $(git rev-list --count "${base_ref}..HEAD") == 0 ]]; then
  : > "${series_file}"
  echo "No commits to export from ${base_ref}..HEAD"
  exit 0
fi

git format-patch "${base_ref}..HEAD" -o "${patch_dir}"
find "${patch_dir}" -maxdepth 1 -type f -name '*.patch' -printf '%f\n' | sort > "${series_file}"

echo "Exported patches to ${patch_dir}"
echo "Wrote series file to ${series_file}"
