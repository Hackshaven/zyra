#!/usr/bin/env bash
set -euo pipefail
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <branch-name>   e.g., $0 codex/add-cli-tests"
  exit 2
fi
BR="$1"
BASE="${MIRROR_BASE:-mirror/staging}"

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Run inside repo root"; exit 1; }
git fetch origin --prune
git show-ref --verify --quiet "refs/remotes/origin/${BASE}" || { echo "Base origin/${BASE} not found (has the mirror sync run?)"; exit 3; }

git switch -c "${BR}" "origin/${BASE}"
git push -u origin "${BR}"
echo "Created and pushed ${BR} from origin/${BASE}. Open a PR with base=${BASE}."
