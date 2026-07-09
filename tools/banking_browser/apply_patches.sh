#!/usr/bin/env bash
# Apply an exported banking-browser patch stack to the current branch.

set -euo pipefail

usage() {
  cat >&2 <<'USAGE'
Usage: tools/banking_browser/apply_patches.sh <patch-dir>

Applies *.patch files from <patch-dir> in lexical order with git am.
If a sibling series file exists, its order is used instead.

Example:
  tools/banking_browser/apply_patches.sh ../banking-browser-patches/patches
USAGE
}

if [[ $# -ne 1 ]]; then
  usage
  exit 2
fi

patch_dir=$1
series_file="$(dirname "${patch_dir}")/series"

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "error: must be run from inside a Git checkout" >&2
  exit 1
fi

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "error: working tree has unstaged or staged changes; commit or stash first" >&2
  exit 1
fi

if [[ ! -d "${patch_dir}" ]]; then
  echo "error: patch directory '${patch_dir}' does not exist" >&2
  exit 1
fi

patches=()
if [[ -s "${series_file}" ]]; then
  while IFS= read -r patch_name; do
    [[ -z "${patch_name}" || "${patch_name}" == \#* ]] && continue
    patches+=("${patch_dir}/${patch_name}")
  done < "${series_file}"
else
  while IFS= read -r patch_path; do
    patches+=("${patch_path}")
  done < <(find "${patch_dir}" -maxdepth 1 -type f -name '*.patch' | sort)
fi

if [[ ${#patches[@]} -eq 0 ]]; then
  echo "No patches found in ${patch_dir}"
  exit 0
fi

for patch_path in "${patches[@]}"; do
  if [[ ! -f "${patch_path}" ]]; then
    echo "error: missing patch '${patch_path}'" >&2
    exit 1
  fi
done

git am "${patches[@]}"
echo "Applied ${#patches[@]} patch(es) from ${patch_dir}"
