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

# --- LFS: default to skip smudge to avoid 404s on mirror checkouts ---
git lfs install --skip-smudge || true
# Also make the filter explicitly skip on checkout
git config filter.lfs.process "git-lfs filter-process"
git config filter.lfs.smudge "git-lfs smudge --skip -- %f"
git config filter.lfs.required true

# Upstream URL from env or default
UPSTREAM_URL="${UPSTREAM_URL:-https://github.com/NOAA-GSL/zyra.git}"

# Ensure 'upstream' remote exists for diff/compare and targeted LFS fetches
if git remote get-url upstream >/dev/null 2>&1; then
  git remote set-url upstream "$UPSTREAM_URL"
else
  git remote add upstream "$UPSTREAM_URL"
fi

# Optional: tell origin to use upstream's LFS endpoint for reads (handy when blobs aren't in downstream)
git config remote.origin.lfsurl "${UPSTREAM_URL}/info/lfs" || true

# Fetch & wire local tracking for mirror branches (read-only)
git fetch --all --prune || true
git show-ref --verify --quiet refs/remotes/origin/mirror/main    && git update-ref refs/heads/mirror/main    refs/remotes/origin/mirror/main    || true
git show-ref --verify --quiet refs/remotes/origin/mirror/staging && git update-ref refs/heads/mirror/staging refs/remotes/origin/mirror/staging || true

echo "Devcontainer ready.
- LFS smudge disabled by default (no auto-download).
- Use:   git lfs fetch upstream --include=\"path/to/file\" && git lfs checkout path/to/file   to materialize specific files."
