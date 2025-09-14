#!/bin/bash

MEDIA_CONTROL="/opt/homebrew/bin/media-control"

# Get the current media info as JSON
info=$($MEDIA_CONTROL get -h)

title=$(jq -r '.title // ""' <<< "$info")
artist=$(jq -r '.artist // ""' <<< "$info")
label="$title – $artist"

sketchybar --set "$NAME" label="$label" icon="􀑪"
