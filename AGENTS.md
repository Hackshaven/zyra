# AGENTS.md — Contribution Guide (Downstream Mirror + Upstream Source)

> **Who is this for?**  
> Engineers, docs writers, and automation “agents” who work with the Zyra codebase.  
> **Important:** This repo is a **downstream mirror**. The **source of truth is upstream** at
> [NOAA-GSL/zyra](https://github.com/NOAA-GSL/zyra).

---

## TL;DR

- ✅ **Write code upstream** in `NOAA-GSL/zyra`.  
- 🚫 **Never** commit to `mirror/*` branches here; they are overwritten by automation.  
- 🌿 Create feature branches off **upstream** `main` (or `staging` when appropriate).  
- 🔁 Keep your branch fresh by rebasing/merging from the target base (usually `main`).  
- 🔎 Open Pull Requests **upstream** with a clear problem statement, scope, tests, and docs.

---

## Repositories & Roles

- **Upstream (canonical):** `https://github.com/NOAA-GSL/zyra`  
  All development happens here: issues, branches, pull requests, releases, tags.

- **Downstream (this repo):** mirror-only branches (`mirror/main`, `mirror/staging`, …).  
  Used for visibility/testing in this org. Workflows from upstream are **stripped**; releases are **not** published here.

---

## Branch Policy

### Long‑lived branches (upstream)
- `main` — default, always green; fast-forward or squash merges preferred.  
- `staging` — integration/pre-release (optional, if used by the team).  
- `release/*` — (optional) cut when preparing a release.

### Mirror branches (downstream)
- `mirror/*` — **read-only**. Force-pushed by automation. **Do not** open PRs against these.

### Short‑lived branches (upstream)
Use a clear prefix and optionally reference the issue number:

```
feat/<slug>-<issue#>
fix/<slug>-<issue#>
chore/<slug>
docs/<slug>
refactor/<slug>
perf/<slug>
test/<slug>
```

Examples:
- `feat/cli-login-oidc-742`
- `fix/handle-empty-config-803`
- `docs/add-getting-started`

---

## Where to Create New Code

1. **You have write access to upstream**
   - Base from `main` (or `staging` if your change targets that line).
   - Create a feature branch (examples below).
   - Open a PR **in upstream**.

2. **You don’t have write access (external contributor)**
   - **Fork** `NOAA-GSL/zyra`.
   - Create your feature branch in your fork.
   - Open a PR from your fork → upstream.

> Changes made in this downstream mirror will be discarded on the next sync.

---

## Creating & Maintaining a Branch (Upstream)

```bash
# 1) Clone upstream (or your fork) and configure remotes
git clone https://github.com/NOAA-GSL/zyra.git
cd zyra

# 2) Make sure main is up to date
git checkout main
git pull --ff-only

# 3) Create your feature branch
git checkout -b feat/cli-login-oidc-742

# ... commit code ...

# 4) Keep fresh – rebase (preferred) or merge main regularly
git fetch origin
git rebase origin/main   # or: git merge origin/main

# 5) Push your branch
git push -u origin feat/cli-login-oidc-742
```

**Rebase vs Merge:** Prefer **rebase** to keep a linear history. If the project mandates merge commits, follow that policy.

---

## Commit Messages

Use **Conventional Commits** style (where possible):

```
<type>(optional-scope): short summary

Body explains what & why (not just how).
Reference issues like: Closes #123 or Fixes #456.
```

Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `perf`, `test`, `build`, `ci`.

---

## Pull Requests (Upstream)

**Before you open a PR:**
- ✅ Tests updated/added and passing locally.
- ✅ Linting/formatting passes (`pre-commit` / repo linters).
- ✅ Docs updated (README, user guides, API docs) when behavior changes.
- ✅ Backwards-compat and migration notes included (if applicable).

**Open the PR with this framing:**
- **Title:** concise, uses imperative mood (e.g., “Add OIDC login flow”).
- **Context:** what problem are we solving? Why now?
- **Scope:** what’s in/out; note any follow-ups.
- **Implementation notes:** high-level approach; key tradeoffs.
- **Testing:** how did you test? include repro steps.
- **Risk/rollout:** migration, config, performance, and telemetry considerations.
- **Checklist:** link issues (`Closes #NNN`), screenshots for UI, docs links.

**PR hygiene:**
- Keep PRs small and focused when possible.  
- Mark as **Draft** early; convert to **Ready** when stable.  
- Request reviewers per CODEOWNERS (if configured).

**Merging strategy:**
- Default to **Squash & merge** to keep history tidy (unless the project specifies otherwise).
- Delete the feature branch after merge.

---

## CI, Checks, and Environments

- All PRs must pass CI checks configured upstream (linters, unit/integration tests).
- If your change alters workflows, coordinate with maintainers—CI changes may require elevated permissions.

---

## Releases & Tags

- Releases and version tags are managed **upstream** only.  
- The downstream mirror **does not** publish releases or accept tag pushes by default.

---

## Security & Secrets

- Do **not** commit credentials or private tokens.  
- Use `.env.example` and document required variables.  
- If you suspect a secret was committed, rotate it and inform maintainers.

---

## Interacting with the Downstream Mirror

- **Do not** open PRs against `mirror/*`.  
- If you need to compare changes, use GitHub’s **Compare** feature against `mirror/*` → your local branches.
- Local workflows in this repo should **ignore** mirror updates:
  ```yaml
  on:
    push:
      branches-ignore:
        - 'mirror/**'
  ```

---

## Issue Tracking

- File issues **upstream** with a clear template:
  - **Expected vs Actual** behavior
  - **Reproduction** steps
  - **Environment** (OS, versions)
  - **Logs** / screenshots
  - **Impact** (who/what is blocked)

---

## Code Style & Tooling

- Follow the linters/formatters defined in the repo (e.g., `ruff`, `black`, `eslint`, `prettier`, etc.).
- If a `pre-commit` config exists, install hooks:
  ```bash
  pip install pre-commit
  pre-commit install
  pre-commit run --all-files
  ```

---

## FAQ

**Q: Can I push directly to `mirror/*`?**  
A: No. Those branches are force-updated by automation and any manual changes will be overwritten.

**Q: Where should I open PRs?**  
A: Always **upstream** (`NOAA-GSL/zyra`). This downstream is read-only.

**Q: I need a temporary downstream-only patch.**  
A: Create a new **non-mirror** branch in this repo (e.g., `hotfix/<slug>`), but coordinate with maintainers—downstream patches can diverge from upstream and should be short-lived.

---

## Contact & Ownership

- Primary maintenance: Upstream maintainers at `NOAA-GSL/zyra`.
- Downstream mirror automation: GitHub Actions in this repo (`.github/workflows/sync-upstream.yml`).

Happy shipping! 🚢
