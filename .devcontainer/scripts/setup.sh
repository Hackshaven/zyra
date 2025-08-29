#!/usr/bin/env bash
set -euo pipefail

# Guard: run only inside a git repo
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not inside a git repository—skip setup."
  exit 0
fi

# Make repo path safe for git inside container
git config --global --add safe.directory "$(pwd)" || true

# Basic git UX defaults
git config --global pull.rebase false
git config --global fetch.prune true

# Ensure upstream remote exists (for compare/inspect; pushes still go through PR relay)
UPSTREAM_URL="${UPSTREAM_URL:-https://github.com/NOAA-GSL/zyra.git}"
if git remote get-url upstream >/dev/null 2>&1; then
  git remote set-url upstream "$UPSTREAM_URL"
else
  git remote add upstream "$UPSTREAM_URL"
fi

# Fetch everything
git fetch --all --prune

# Ensure local tracking branches for mirror/* exist (without switching worktree)
if git show-ref --verify --quiet refs/remotes/origin/mirror/main; then
  git update-ref refs/heads/mirror/main refs/remotes/origin/mirror/main || true
fi
if git show-ref --verify --quiet refs/remotes/origin/mirror/staging; then
  git update-ref refs/heads/mirror/staging refs/remotes/origin/mirror/staging || true
fi

# Provide a helper for new feature branches off mirror/staging
chmod +x .devcontainer/scripts/new-branch.sh

echo "Devcontainer setup complete. Use: .devcontainer/scripts/new-branch.sh codex/<slug>"
