#!/bin/bash

# Get all visible workspaces
current=$(aerospace list-workspaces --focused)

icons=("1" "2" "3" "4" "5")

for i in "${!icons[@]}"; do
  sid=$((i+1))
  if [[ "$sid" == "$current" ]]; then
    sketchybar --animate linear 10 \
               --set space."$sid" background.color=0x20ffffff background.border_color=0x55ffffff
  else
    sketchybar --animate linear 10 \
               --set space."$sid" background.color=0x00ffffff background.border_color=0x00ffffff
  fi
done
