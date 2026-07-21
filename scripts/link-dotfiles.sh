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

for package in bash hypr nvim; do
    if [[ -d "$package" ]]; then
        echo "Linking $package"
        stow --restow --target="$TARGET_DIR" "$package"
    fi
done
