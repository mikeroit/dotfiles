#!/usr/bin/env bash
echo "$(date '+%H:%M:%S.%N') - triggered" >> /tmp/theme-timing.log

set -Eeuo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
MODE_FILE="$REPO_DIR/theme-mode"

# Allow "gen-theme.sh soft" / "gen-theme.sh contrast" to switch modes;
# with no argument, just regenerate configs for whatever mode is already set.

if [[ $# -gt 0 ]]; then
    case "$1" in
        soft|contrast) echo "$1" > "$MODE_FILE" ;;
        toggle)
            current="$(<"$MODE_FILE")"
            if [[ "$current" == "soft" ]]; then
                echo "contrast" > "$MODE_FILE"
            else
                echo "soft" > "$MODE_FILE"
            fi
            ;;
        *) echo "Unknown mode: $1 (expected 'soft', 'contrast', or 'toggle')" >&2; exit 1 ;;
    esac
fi


mode="$(<"$MODE_FILE")"

gen_kitty() {
    local dir="$REPO_DIR/stow/kitty/.config/kitty"
    cat "$dir/kitty-base.conf" "$dir/kitty-theme-$mode.conf" > "$dir/kitty.conf"

    if command -v kitty >/dev/null 2>&1; then
        ( kitty @ set-colors --all --configured "$dir/kitty-theme-$mode.conf" 2>/dev/null & )
    fi
}

gen_waybar() {
    local dir="$REPO_DIR/stow/waybar/.config/waybar"
    cat "$dir/style-base.css" "$dir/style-theme-$mode.css" > "$dir/style.css"

    # Reload waybar's CSS live. SIGUSR2 tells a running waybar to reload
    # its config/style without a full restart (no visible flash). Falls
    # back to a kill+relaunch only if waybar isn't running yet.
    if pgrep -x waybar >/dev/null; then
        pkill -SIGUSR2 waybar
        pkill -SIGRTMIN+8 waybar
    else
        waybar >/dev/null 2>&1 &
        disown
    fi
}

gen_rofi() {
    local dir="$REPO_DIR/stow/rofi/.config/rofi"
    cat "$dir/theme-base.rasi" "$dir/theme-$mode.rasi" > "$dir/theme.rasi"
}

gen_wallpaper() {
    local wallpaper="$HOME/.local/share/wallpapers/wallpaper-$mode.png"

    if command -v awww >/dev/null 2>&1; then
        awww img "$wallpaper" \
            --transition-type wipe \
            --transition-duration 1
    fi
}

gen_nvim() {
    # Push a live reload into every currently-open nvim instance. Sockets
    # that no longer exist (nvim closed without cleanup, e.g. a crash)
    # are skipped rather than erroring the whole loop.
    shopt -s nullglob
    for sock in /tmp/nvim-socket-*; do
        nvim --server "$sock" --remote-expr 'v:lua.require("theme").load()' >/dev/null 2>&1 || true
    done
    shopt -u nullglob
}

gen_kitty
gen_waybar
gen_rofi
gen_nvim
gen_wallpaper

echo "Theme set to: $mode"
