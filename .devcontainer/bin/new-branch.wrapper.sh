#!/usr/bin/env bash
set -euo pipefail
ROOT=""
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  ROOT="$(git rev-parse --show-toplevel)"
fi

# Prefer the workspace copy if present; otherwise use the baked fallback
if [[ -n "${ROOT}" ]] && [[ -f "${ROOT}/.devcontainer/scripts/new-branch.sh" ]]; then
  exec bash "${ROOT}/.devcontainer/scripts/new-branch.sh" "$@"
elif [[ -f "/workspaces/${PWD##*/}/.devcontainer/scripts/new-branch.sh" ]]; then
  exec bash "/workspaces/${PWD##*/}/.devcontainer/scripts/new-branch.sh" "$@"
elif [[ -f "/workspaces/zyra/.devcontainer/scripts/new-branch.sh" ]]; then
  exec bash "/workspaces/zyra/.devcontainer/scripts/new-branch.sh" "$@"
else
  exec bash "/opt/devtools/new-branch.sh" "$@"
fi
