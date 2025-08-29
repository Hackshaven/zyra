#!/usr/bin/env bash
set -euo pipefail
# Keep remotes fresh on container start
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git fetch --all --prune || true
fi
