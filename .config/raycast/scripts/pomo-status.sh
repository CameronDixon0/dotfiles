#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Pomo Status
# @raycast.mode fullOutput
#
# Optional parameters:
# @raycast.icon 📊
# @raycast.packageName Raycast Scripts

STATE_FILE="$HOME/.config/sketchybar/.pomodoro"

# Missing file → don't crash, show idle default (controller recreates on next write)
if [ ! -f "$STATE_FILE" ]; then
  echo "○ 25 idle"
  exit 0
fi

# shellcheck disable=SC1090
. "$STATE_FILE"

# Defaults in case sourced file is incomplete
STATUS="${STATUS:-idle}"
END="${END:-0}"
REMAINING="${REMAINING:-1500}"
FOCUS_LEN="${FOCUS_LEN:-1500}"

NOW=$(date +%s)

fmt() {
  # $1 = seconds -> MM:SS, clamped >= 0 (sleep/wake can make END < now)
  s=$1
  [ "$s" -lt 0 ] && s=0
  printf "%02d:%02d" $((s / 60)) $((s % 60))
}

case "$STATUS" in
  focus)
    LEFT=$((END - $(date +%s)))
    [ "$LEFT" -lt 0 ] && LEFT=0
    echo "● $(fmt "$LEFT") focus"
    ;;
  break)
    LEFT=$((END - $(date +%s)))
    [ "$LEFT" -lt 0 ] && LEFT=0
    echo "○ $(fmt "$LEFT") break"
    ;;
  paused-focus|paused-break)
    [ "$REMAINING" -lt 0 ] && REMAINING=0
    echo "‖ $(fmt "$REMAINING") paused"
    ;;
  idle|*)
    echo "○ $((FOCUS_LEN / 60)) idle"
    ;;
esac
