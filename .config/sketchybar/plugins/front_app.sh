#!/bin/sh
# minimal front app — just the name, muted
if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set "$NAME" label="$INFO"
fi
