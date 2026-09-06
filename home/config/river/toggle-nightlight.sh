#!/usr/bin/env bash

# State file to track whether night light is currently enabled or paused
STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/gammastep-${UID:-$USER}.state"

# If gammastep is not running at all, start it
if ! pgrep -x gammastep > /dev/null 2>&1; then
    gammastep &
    echo "enabled" > "$STATE_FILE"
    notify-send -r 2593 -t 2000 -u low "Night Light" "Enabled (Automatic evening red & dimming)"
    exit 0
fi

# Determine current state (default to enabled if state file is missing)
CURRENT_STATE="enabled"
if [[ -f "$STATE_FILE" ]]; then
    CURRENT_STATE=$(cat "$STATE_FILE")
fi

if [[ "$CURRENT_STATE" == "enabled" ]]; then
    # Pause Gammastep (resets gamma to standard daylight)
    pkill -USR1 -x gammastep
    echo "disabled" > "$STATE_FILE"
    notify-send -r 2593 -t 2000 -u low "Night Light" "Disabled (Standard daylight)"
else
    # Resume Gammastep (applies automatic evening red & dimming)
    pkill -USR1 -x gammastep
    echo "enabled" > "$STATE_FILE"
    notify-send -r 2593 -t 2000 -u low "Night Light" "Enabled (Automatic evening red & dimming)"
fi
