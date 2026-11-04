#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Pomo Pause/Resume
# @raycast.mode silent
#
# Optional parameters:
# @raycast.icon ⏸️
# @raycast.packageName Raycast Scripts

bash "$HOME/.config/sketchybar/plugins/pomodoro-control.sh" toggle > /dev/null 2>&1
