#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Pomo Reset
# @raycast.mode silent
#
# Optional parameters:
# @raycast.icon 🔄
# @raycast.packageName Raycast Scripts

bash "$HOME/.config/sketchybar/plugins/pomodoro-control.sh" reset > /dev/null 2>&1
