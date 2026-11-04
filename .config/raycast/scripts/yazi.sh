#!/bin/bash

# Raycast Script Command Template
#
# Duplicate this file and remove ".template." from the filename to get started.
# See full documentation here: https://github.com/raycast/script-commands
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Yazi
# @raycast.mode silent
#
# Optional parameters:
# @raycast.icon 📁
# @raycast.packageName Raycast Scripts

/Applications/WezTerm.app/Contents/MacOS/wezterm start -- yazi ~ > /dev/null 2>&1
