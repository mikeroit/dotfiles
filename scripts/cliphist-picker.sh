#!/usr/bin/env bash
set -Eeuo pipefail

selection="$(cliphist list | rofi -dmenu -p "Clipboard")"

# If nothing was selected (Esc pressed, or the list was empty), stop here.
# Without this check, piping an empty selection into wl-copy would
# overwrite your current clipboard with nothing — silently wiping
# whatever you had copied, which is worse than doing nothing at all.
if [[ -z "$selection" ]]; then
    exit 0
fi

echo "$selection" | cliphist decode | wl-copy
