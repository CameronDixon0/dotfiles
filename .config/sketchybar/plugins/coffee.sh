#!/bin/bash

STATE_FILE="$TMPDIR/sketchybar_awake_state"
PID_FILE="$TMPDIR/sketchybar_caffeinate_pid"

if [[ -f "$STATE_FILE" ]]; then
  # Currently awake — stop caffeinate
  if [[ -f "$PID_FILE" ]]; then
    kill "$(cat "$PID_FILE")" 2>/dev/null
    rm "$PID_FILE"
  fi
  rm "$STATE_FILE"
  sketchybar --set coffee label="􀸘"
else
  # Not awake — start caffeinate
  caffeinate -dimsu &
  echo $! > "$PID_FILE"
  touch "$STATE_FILE"
  sketchybar --set coffee label="􀸙"
fi
