#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Pomo Break
# @raycast.mode silent
#
# Optional parameters:
# @raycast.icon ☕
# @raycast.packageName Raycast Scripts
# @raycast.argument1 {"type": "text", "placeholder": "minutes (default 5)", "optional": true}

bash "$HOME/.config/sketchybar/plugins/pomodoro-control.sh" break "${1:-5}" > /dev/null 2>&1
