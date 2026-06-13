#!/usr/bin/env bash
# Remove known generated/local heavyweight artifacts from the Chromium checkout.

set -euo pipefail

usage() {
  cat >&2 <<'USAGE'
Usage: tools/banking_browser/clean_generated.sh [--dry-run]

Removes local generated artifacts that should not be committed. Run with
--dry-run first to inspect what would be deleted.
USAGE
}

dry_run=false
if [[ $# -gt 1 ]]; then
  usage
  exit 2
elif [[ $# -eq 1 ]]; then
  case "$1" in
    --dry-run) dry_run=true ;;
    -h|--help) usage; exit 0 ;;
    *) usage; exit 2 ;;
  esac
fi

repo_root=$(git rev-parse --show-toplevel)
cd "${repo_root}"

paths=(
  "out"
  "third_party/material_web_components/node_modules"
  "third_party/android_deps/build"
)

for path in "${paths[@]}"; do
  if [[ -e "${path}" ]]; then
    if [[ "${dry_run}" == true ]]; then
      echo "would remove ${path}"
    else
      echo "removing ${path}"
      rm -rf -- "${path}"
    fi
  fi
done
