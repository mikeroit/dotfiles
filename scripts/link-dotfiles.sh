#!/usr/bin/env bash

set -Eeuo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
STOW_DIR="$REPO_DIR/stow"
TARGET_DIR="${HOME:?HOME is not set}"

if ! command -v stow >/dev/null 2>&1; then
    echo "GNU Stow is not installed." >&2
    exit 1
fi

cd "$STOW_DIR"

# Auto-discover: link every non-empty directory under stow/, instead of a
# hardcoded package list. This is what silently broke hyprland linking
# before (milestone 1) — a package existing on disk didn't mean it was
# in the loop. Iterating the directory itself removes that whole class of bug.
for package_path in "$STOW_DIR"/*/; do
    package="$(basename "$package_path")"

    # Skip empty package directories (e.g. a placeholder scaffolded but
    # never filled in) — stow would either no-op or error on these
    # depending on version, and an empty package isn't ready to link anyway.
    if [[ -z "$(find "$package_path" -mindepth 1 -print -quit)" ]]; then
        echo "Skipping $package (empty, nothing to link)"
        continue
    fi

    echo "Linking $package"
    stow --restow --target="$TARGET_DIR" "$package"
done
