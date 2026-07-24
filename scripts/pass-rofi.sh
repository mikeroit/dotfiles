#!/usr/bin/env bash
set -Eeuo pipefail

STORE_DIR="${PASSWORD_STORE_DIR:-$HOME/.password-store}"

# List entries as relative paths, minus the .gpg extension — this is what
# the user picks from. find+sed rather than `pass ls`'s tree output because
# tree formatting doesn't pipe cleanly into rofi's flat dmenu list.
selection="$(
    find "$STORE_DIR" -type f -name '*.gpg' \
        | sed -e "s|^$STORE_DIR/||" -e 's|\.gpg$||' \
        | rofi -dmenu -p "Pass"
)"

# Esc pressed or empty store — stop here, same guard as cliphist-picker.sh.
if [[ -z "$selection" ]]; then
    exit 0
fi

# Copy the password (first line of the entry) to the clipboard rather than
# printing it anywhere visible. pass already has a `-c` flag for exactly
# this, including its own auto-clear-after-45s timeout — reuse it instead
# of reimplementing clipboard-clear logic ourselves.
pass show -c "$selection"
