#!/bin/sh

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item

if [[ "$SELECTED" == "true" ]]; then
  sketchybar --animate circ 10 --set "$NAME" icon.padding_right=10 icon.padding_left=10
else
  sketchybar --animate circ 10 --set "$NAME" icon.padding_right=1 icon.padding_left=1
fi
