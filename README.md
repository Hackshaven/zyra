# Zyra Mirror (Downstream)

This repository hosts **mirror branches** (`mirror/main`, `mirror/staging`, etc.) of the upstream
[NOAA-GSL/zyra](https://github.com/NOAA-GSL/zyra) project.

⚠️ **Note:** This is *not* the canonical repository. Please go to the
[NOAA-GSL organization repo](https://github.com/NOAA-GSL/zyra) for issues,
pull requests, releases, and active development.

## Purpose

- Provide a downstream mirror of selected branches for internal use.
- Keep NOAA-GSL code available in this org, without modifying upstream.
- Ensure upstream workflows (like release publishing or wiki sync) **do not run here**.

## How the mirror works

- A GitHub Action syncs `main` and `staging` from NOAA-GSL into `mirror/main` and `mirror/staging`.
- Upstream workflow files (`.github/workflows/**`) are stripped out before pushing.
- Tags are *not* mirrored by default (avoids triggering release jobs).
- Force pushes are allowed on `mirror/*` so history matches upstream.

## Branch & Workflow Policies

- **Default branch:** `main` (local content, not overwritten).
- **Protected branches:**  
  - `main` → strict protection (reviews required, no force push).  
  - `mirror/*` → allow force push by GitHub Actions bot, block human pushes.
- **Other workflows:**  
  To prevent your own workflows from firing on mirror updates, add:
  ```yaml
  on:
    push:
      branches-ignore:
        - 'mirror/**'
  ```

## Where to contribute

If you want to contribute code, file issues, or discuss features, use the **upstream repo**:
👉 [NOAA-GSL/zyra](https://github.com/NOAA-GSL/zyra)

This downstream is read-only, maintained by automation.
