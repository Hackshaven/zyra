#!/usr/bin/env bash
# Create a new working branch based on origin/mirror/staging and set upstream
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <branch-name>   e.g., $0 codex/add-cli-tests"
  exit 2
fi
BR="$1"
BASE="${MIRROR_BASE:-mirror/staging}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Run inside the repo root."
  exit 1
fi

git fetch origin --prune
if ! git show-ref --verify --quiet "refs/remotes/origin/${BASE}"; then
  echo "Base branch origin/${BASE} not found. Did the mirror sync run yet?"
  exit 3
fi

git switch -c "${BR}" "origin/${BASE}"
git push -u origin "${BR}"
echo "✅ Created and pushed ${BR} based on origin/${BASE}. Open a PR with base=${BASE}."
