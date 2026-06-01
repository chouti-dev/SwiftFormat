#!/bin/bash
#
# Non-interactive upstream sync for ChouTi SwiftFormat fork.
# Used by .github/workflows/sync-upstream.yml
#
# Usage:
#   ./Scripts/chouti-sync-upstream.sh [--upstream-tag VERSION]
#
# Environment:
#   UPSTREAM_REPO     default: nicklockwood/SwiftFormat
#   TARGET_BRANCH     default: master
#   CHOUTI_SHELL_REPO default: https://github.com/honghaoz/chouti-shell.git
#   GH_TOKEN / GITHUB_TOKEN / CHOUTI_RELEASE_TOKEN for push and gh release
#

set -euo pipefail

UPSTREAM_REPO="${UPSTREAM_REPO:-nicklockwood/SwiftFormat}"
TARGET_BRANCH="${TARGET_BRANCH:-master}"
CHOUTI_SHELL_REPO="${CHOUTI_SHELL_REPO:-https://github.com/honghaoz/chouti-shell.git}"

usage() {
    cat <<'EOF'
Usage: chouti-sync-upstream.sh [options]

Options:
  --upstream-tag TAG     Merge this upstream tag instead of the latest semver tag.
  -h, --help             Show this help.

Environment:
  UPSTREAM_REPO, TARGET_BRANCH, CHOUTI_SHELL_REPO, GITHUB_REPOSITORY, GH_TOKEN
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --upstream-tag)
            UPSTREAM_TAG="${2:?--upstream-tag requires a value}"
            shift 2
            ;;
        -h | --help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

log() { echo "➡️  $*" >&2; }
fail() { echo "🛑 $*" >&2; exit 1; }

install_chouti_shell() {
    if [[ -x "$HOME/.chouti-shell/bin/swift-build" ]]; then
        log "chouti-shell already installed at ~/.chouti-shell"
        return
    fi
    log "Installing chouti-shell from $CHOUTI_SHELL_REPO"
    rm -rf "$HOME/.chouti-shell"
    git clone --depth 1 "$CHOUTI_SHELL_REPO" "$HOME/.chouti-shell"
    # install.sh skips PATH changes in CI; we add bin to PATH explicitly below.
    "$HOME/.chouti-shell/install.sh" || true
}

ensure_path() {
    export PATH="$HOME/.chouti-shell/bin:$PATH"
    command -v swift-build >/dev/null 2>&1 || fail "swift-build not found after installing chouti-shell"
}

verify_upstream() {
    log "Verifying upstream repository $UPSTREAM_REPO"
    git ls-remote "https://github.com/${UPSTREAM_REPO}.git" HEAD >/dev/null 2>&1 \
        || fail "Cannot reach upstream https://github.com/${UPSTREAM_REPO}.git"
}

configure_git() {
    if [[ -z "$(git config user.email || true)" ]]; then
        git config user.email "m@honghao.dev"
        git config user.name "Honghao Zhang"
    fi
}

fetch_upstream() {
    log "Fetching upstream tags"
    if git remote get-url upstream >/dev/null 2>&1; then
        git remote set-url upstream "https://github.com/${UPSTREAM_REPO}.git"
    else
        git remote add upstream "https://github.com/${UPSTREAM_REPO}.git"
    fi
    # Upstream tags are authoritative for version merges.
    git fetch upstream --tags --force
    # Fetch origin branch only — do not fetch origin tags. Fork tags (e.g. 0.46.3)
    # often point at different commits than upstream and trigger "would clobber" warnings.
    git fetch origin "$TARGET_BRANCH"
    git checkout "$TARGET_BRANCH"
    git pull origin "$TARGET_BRANCH" --ff-only || true
}

resolve_upstream_tag() {
    if [[ -n "${UPSTREAM_TAG:-}" ]]; then
        log "Using upstream tag from argument: $UPSTREAM_TAG"
        git rev-parse "refs/tags/${UPSTREAM_TAG}^{commit}" >/dev/null 2>&1 \
            || fail "Upstream tag not found: $UPSTREAM_TAG"
        echo "$UPSTREAM_TAG"
        return
    fi

    local tag
    tag="$(git ls-remote --tags upstream | sed 's/.*refs\/tags\///; s/\^{}//' | grep -E '^[0-9]+\.[0-9]+(\.[0-9]+)?$' | sort -Vr | head -n 1)"
    [[ -n "$tag" ]] || fail "Could not determine latest upstream semver tag"
    log "Latest upstream semver tag: $tag"
    echo "$tag"
}

chouti_tag_already_published() {
    local upstream_tag="$1"
    local chouti_tag="${upstream_tag}-chouti"
    if git ls-remote --exit-code origin "refs/tags/${chouti_tag}" >/dev/null 2>&1; then
        log "Fork release tag already exists: $chouti_tag (nothing to do)"
        return 0
    fi
    return 1
}

merge_upstream_tag() {
    local upstream_tag="$1"
    log "Merging upstream tag $upstream_tag into $TARGET_BRANCH"
    git merge "$upstream_tag" --no-edit -m "Merge tag '$upstream_tag' from upstream $UPSTREAM_REPO"
}

run_tests() {
    log "Running Xcode tests (SwiftFormat Framework scheme)"
    xcodebuild -project SwiftFormat.xcodeproj \
        -scheme "SwiftFormat (Framework)" \
        -sdk macosx \
        clean build test
}

build_products() {
    log "Building release binaries with make-product.sh"
    export CI=true
    export GITHUB_ACTIONS="${GITHUB_ACTIONS:-true}"
    ./make-product.sh
}

write_github_output() {
    local upstream_tag="$1"
    local chouti_tag="${upstream_tag}-chouti"
    if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
        {
            echo "upstream_tag=$upstream_tag"
            echo "chouti_tag=$chouti_tag"
        } >>"$GITHUB_OUTPUT"
    fi
}

resolve_gh_repo() {
    # gh defaults to the "upstream" remote (nicklockwood/SwiftFormat); releases must be on origin (fork).
    if [[ -n "${GITHUB_REPOSITORY:-}" ]]; then
        echo "$GITHUB_REPOSITORY"
        return
    fi
    local url
    url="$(git remote get-url origin)"
    if [[ "$url" =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
        echo "${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
        return
    fi
    fail "Could not determine GitHub repo for gh release (set GITHUB_REPOSITORY or check origin remote)"
}

publish_release() {
    local upstream_tag="$1"
    local chouti_tag="${upstream_tag}-chouti"
    local gh_repo release_url
    gh_repo="$(resolve_gh_repo)"
    release_url="https://github.com/nicklockwood/SwiftFormat/releases/tag/${upstream_tag}"

    for asset in Products/swiftformat.zip Products/swiftformat-arm64.zip Products/swiftformat-x86_64.zip; do
        [[ -f "$asset" ]] || fail "Missing release asset: $asset"
    done

    log "Pushing $TARGET_BRANCH to origin"
    if ! git push origin "$TARGET_BRANCH"; then
        fail "git push origin $TARGET_BRANCH failed. Common causes: missing workflows: write permission on GITHUB_TOKEN (upstream merges .github/workflows), branch protection, or use secret CHOUTI_RELEASE_TOKEN (PAT)."
    fi

    log "Creating GitHub release $chouti_tag on $gh_repo"
    if [[ -z "${GH_TOKEN:-}" && -n "${GITHUB_TOKEN:-}" ]]; then
        export GH_TOKEN="$GITHUB_TOKEN"
    fi
    command -v gh >/dev/null 2>&1 || fail "gh CLI not found on runner"
    : "${GH_TOKEN:?GH_TOKEN (or GITHUB_TOKEN) is required for gh release create}"

    if ! gh release create "$chouti_tag" \
        --repo "$gh_repo" \
        --target "$TARGET_BRANCH" \
        --title "Merged from upstream (${upstream_tag})" \
        --notes "Merged ${release_url}" \
        Products/swiftformat.zip \
        Products/swiftformat-arm64.zip \
        Products/swiftformat-x86_64.zip; then
        fail "gh release create failed for $chouti_tag on $gh_repo"
    fi
}

main() {
    install_chouti_shell
    ensure_path
    verify_upstream
    configure_git
    fetch_upstream

    local upstream_tag
    upstream_tag="$(resolve_upstream_tag)"
    write_github_output "$upstream_tag"

    if chouti_tag_already_published "$upstream_tag"; then
        exit 0
    fi

    merge_upstream_tag "$upstream_tag"
    run_tests
    build_products
    publish_release "$upstream_tag"
    log "Published release ${upstream_tag}-chouti"
}

main
