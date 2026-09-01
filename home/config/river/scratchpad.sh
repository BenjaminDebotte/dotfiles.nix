#!/bin/sh
# Scratchpad / Hover terminal toggle script for River

SCRATCH_TAG=$((1 << 31))

# Check if spterm is running (matching app-id or class)
if ! pgrep -f "kitty.*spterm" > /dev/null; then
    kitty --class spterm --app-id spterm -o initial_window_width=120c -o initial_window_height=35c &
    sleep 0.15
fi

# Toggle visibility of the scratchpad tag
riverctl toggle-focused-tags "$SCRATCH_TAG"
