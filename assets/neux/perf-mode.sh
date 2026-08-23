#!/usr/bin/env bash
# neux perf mode toggle - sway cant script
STATE="$HOME/.cache/neux-sway-perf"

if [ -f "$STATE" ]; then
    rm -f "$STATE"
    swaymsg "gaps inner all set 5"
    swaymsg "gaps outer all set 10"
    swaymsg "corner_radius 10"
    swaymsg "blur enable"
    swaymsg "shadows enable"
    swaymsg "default_dim_inactive 0.2"
    notify-send "NEUX" "Effects restored"
else
    touch "$STATE"
    swaymsg "gaps inner all set 0"
    swaymsg "gaps outer all set 0"
    swaymsg "corner_radius 0"
    swaymsg "blur disable"
    swaymsg "shadows disable"
    swaymsg "default_dim_inactive 0"
    notify-send "NEUX" "Perf mode: effects disabled"
fi
