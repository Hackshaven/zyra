# Devcontainer for Zyra (Downstream Mirror)

This directory defines the **development container** used when working in VS Code Remote Containers or GitHub Codespaces.  
It ensures that local contributors (and Codex automation) have a consistent environment that understands the **mirror workflow**.

---

## Image Build

- The `Dockerfile` here extends from a lightweight base (`mcr.microsoft.com/devcontainers/base:ubuntu`).
- Extra features are installed via [Dev Container Features](https://containers.dev/features):
  - Git, GitHub CLI
  - Node.js (LTS)
  - Python 3.11
- Additional system packages: `curl`, `jq`, `less`, `openssh-client`, etc.
- Git default branch is set to `main`.

This means the container is lightweight, fast to build, and doesn’t try to replicate the full **upstream NOAA-GSL/zyra** environment — it’s focused on mirror and contribution workflows.

---

## Scripts

- **`.devcontainer/scripts/setup.sh`**  
  Runs once after the container is created (`postCreateCommand`).  
  Ensures remotes are configured (`origin`, `upstream`), fetches mirror branches, and installs any helper scripts.

- **`.devcontainer/scripts/post-start.sh`**  
  Runs every time the container starts (`postStartCommand`).  
  Useful for refreshing remotes, pruning branches, or syncing environment variables.

These scripts are intended to keep the local container aligned with the **mirror → codex → relay** flow.

---

## Bin Utilities

- **`.devcontainer/bin/new-branch.sh`** (wrapper installed into `$PATH`)  
  A helper that creates new feature branches off `mirror/staging` automatically, so Codex (or developers) don’t accidentally branch off `mirror/main` or `main`.  

  Example usage:
  ```bash
  new-branch codex/add-cli-tests
  ```

  This will:
- Fetch `mirror/staging`
- Create `codex/add-cli-tests` locally
- Push it to `origin`
- Set up tracking

Other small helpers can be added here over time (e.g., scripts for relay debugging or cleaning old branches).

---

## Workflow Awareness

The devcontainer is **mirror-aware**:
- It uses `MIRROR_BASE=mirror/staging` and `MIRROR_MAIN=mirror/main` (see `devcontainer.json`).
- All new branches should derive from `mirror/staging`.
- CI/CD is not run inside this container — that happens via GitHub Actions upstream.

---

## Why This Matters

- Prevents contributors from accidentally working off upstream `main`.
- Gives Codex automation a consistent branching environment.
- Provides humans with one-command helpers (`new-branch`) to avoid mistakes.
- Ensures downstream contributions can be cleanly relayed back into `NOAA-GSL/zyra`.

- **LFS mirrored**: All Git LFS objects from the upstream repo are also mirrored into this downstream, so you can safely check out `mirror/*` branches without missing asset errors. Large files are available locally without needing to fetch from upstream.


---

### TL;DR
- 🐳 Lightweight container for mirror workflows.  
- ⚡ Scripts keep remotes/mirrors aligned.  
- 🌿 Always branch from `mirror/staging`.  
- 🤖 Bin helpers make Codex + human branching safe and repeatable.  
