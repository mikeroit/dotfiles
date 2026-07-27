#!/bin/sh
# Known upstream bug: xdg-desktop-portal-hyprland can enter a silent,
# undetectable-via-logs busy-loop shortly after startup, pinning a full
# CPU core (confirmed via `top`/dmesg on this machine — no error output,
# just sustained ~150-175% CPU). No root-cause fix exists upstream as of
# writing; this is the Hyprland project's own documented workaround —
# kill and cleanly relaunch both portal daemons early in the session,
# before anything depends on them.
sleep 1
killall -e xdg-desktop-portal-hyprland
killall xdg-desktop-portal
/usr/lib/xdg-desktop-portal-hyprland &
sleep 2
/usr/lib/xdg-desktop-portal &
