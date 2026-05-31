# ChouTi upstream sync (GitHub Actions)

Automates what `chouti_pull.sh` does manually: merge the latest upstream [nicklockwood/SwiftFormat](https://github.com/nicklockwood/SwiftFormat) tag, run tests, build binaries with [`make-product.sh`](../make-product.sh) + [chouti-shell](https://github.com/honghaoz/chouti-shell), then tag `{version}-chouti` and publish a GitHub release.

## Workflow

- File: [`.github/workflows/sync-upstream.yml`](../.github/workflows/sync-upstream.yml)
- Script: [`Scripts/chouti-sync-upstream.sh`](../Scripts/chouti-sync-upstream.sh)

## Test before going live

1. Push this branch to `chouti-dev/SwiftFormat`.
2. Open **Actions → Sync upstream (ChouTi) → Run workflow**.
3. **Run mode:** `Test (dry run)` (default).
4. Optionally set **Upstream version** (e.g. `0.59.0`) to pin a tag. Leave blank for latest. If `-chouti` already exists for that version, the job exits early.
5. Confirm the job:
   - merges the tag
   - passes `xcodebuild` tests
   - runs `make-product.sh` (installs chouti-shell, produces `Products/*.zip`)
   - uploads artifacts
   - does **not** push or create a release
6. Download artifact **chouti-swiftformat-products** and verify the binaries.
7. Run again with **Run mode:** `Publish release` when ready.

## Publish releases (required secret)

Upstream merges update `.github/workflows/`. **`GITHUB_TOKEN` cannot push those files** — use a PAT:

1. GitHub → **Settings → Developer settings → Personal access tokens** → classic token with **`repo`** and **`workflow`** (or fine-grained: Contents + Actions read/write on this repo).
2. Repo **Settings → Secrets → Actions** → **`CHOUTI_RELEASE_TOKEN`** = that token.
3. Run **Publish release** (dry run does not need the secret).

## Enable automatic daily sync

In the fork repo on GitHub:

**Settings → Secrets and variables → Actions → Variables**

| Name | Value |
|------|--------|
| `CHOUTI_AUTO_SYNC` | `true` |

Cron runs at 14:00 UTC. Scheduled runs use **dry_run: false** (they publish when a new upstream tag is available).

## Local dry run

```bash
chmod +x Scripts/chouti-sync-upstream.sh
./Scripts/chouti-sync-upstream.sh --dry-run
# Pin a tag:
./Scripts/chouti-sync-upstream.sh --dry-run --upstream-tag 0.59.0
```

Requires Xcode and `~/.chouti-shell` (or the script will clone chouti-shell for you).

## Release artifacts

ChouTi releases attach:

- `Products/swiftformat.zip` (universal)
- `Products/swiftformat-arm64.zip`
- `Products/swiftformat-x86_64.zip`

Upstream’s [`release.yml`](../.github/workflows/release.yml) is skipped for `*-chouti` tags to avoid duplicate builds.

## When automation fails

- **Merge conflict**: fix on `master` locally, push, re-run workflow.
- **Tests fail**: fix ChouTi fork code or wait for upstream; do not enable `CHOUTI_AUTO_SYNC` until green.
- **`refusing to allow a GitHub App to create or update workflow`**: add secret **`CHOUTI_RELEASE_TOKEN`** (PAT with `repo` + `workflow`). Not fixable with `permissions:` in the workflow file.

## Local `git fetch` tag warnings

If you see `rejected ... (would clobber existing tag)` when fetching **origin**, the fork’s version tags (e.g. `0.46.3`) point at different commits than upstream’s tags. That is common on long-lived forks. The sync script only uses **upstream** tags for merges; it fetches `origin` branch updates without importing `origin` tags. ChouTi release tags (`*-chouti`) are checked via `git ls-remote origin`.
