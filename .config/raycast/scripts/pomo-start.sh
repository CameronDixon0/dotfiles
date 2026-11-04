#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Pomo Start
# @raycast.mode silent
#
# Optional parameters:
# @raycast.icon ⏱️
# @raycast.packageName Raycast Scripts
# @raycast.argument1 {"type": "text", "placeholder": "minutes (default 25)", "optional": true}

bash "$HOME/.config/sketchybar/plugins/pomodoro-control.sh" start "${1:-25}" > /dev/null 2>&1
