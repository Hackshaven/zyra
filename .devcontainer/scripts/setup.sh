#!/usr/bin/env bash
set -euo pipefail

# Run only if we're inside a Git repo
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not a git repository; skipping setup."
  exit 0
fi

# Make repo safe for Git in containers
git config --global --add safe.directory "$(pwd)" || true
git config --global pull.rebase false
git config --global fetch.prune true

# Ensure 'upstream' remote exists for diff/compare
UPSTREAM_URL="${UPSTREAM_URL:-https://github.com/NOAA-GSL/zyra.git}"
if git remote get-url upstream >/dev/null 2>&1; then
  git remote set-url upstream "$UPSTREAM_URL"
else
  git remote add upstream "$UPSTREAM_URL"
fi

# Fetch & wire local tracking for mirror branches (read-only)
git fetch --all --prune || true
git show-ref --verify --quiet refs/remotes/origin/mirror/main    && git update-ref refs/heads/mirror/main    refs/remotes/origin/mirror/main    || true
git show-ref --verify --quiet refs/remotes/origin/mirror/staging && git update-ref refs/heads/mirror/staging refs/remotes/origin/mirror/staging || true

# DO NOT chmod workspace scripts; bind mounts may not allow it, and the wrapper doesn't require it.
echo "Devcontainer ready. To create a branch from mirror/staging, run:  new-branch.sh codex/<slug>"
