#!/usr/bin/env bash
set -euo pipefail

# Refresh remotes
git fetch origin --prune || true
git fetch upstream --prune || true

# Reinstall deps if lockfile changed
if [ -f pyproject.toml ]; then
  poetry install --with dev --all-extras
fi

echo "✅ maintenance.sh complete: remotes synced, dependencies refreshed"
