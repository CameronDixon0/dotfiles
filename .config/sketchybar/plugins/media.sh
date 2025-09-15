#!/bin/bash

truncate_text() {
  local text="$1"
  local max_length="$2"
  if [ ${#text} -le "$max_length" ]; then
    echo "$text"
  else
    echo "${text:0:max_length}" | sed -E 's/\s+[[:alnum:]]*$//' | awk '{$1=$1};1' | sed 's/$/.../'
  fi
}

MEDIA_CONTROL="/opt/homebrew/bin/media-control"

media-control stream | \
    while IFS= read -r line; do
        if [ "$(jq -r '.diff == false' <<< "$line")" = "true" ]; then
            raw_title=$(jq -r '.payload.title' <<< "$line")
            raw_artist=$(jq -r '.payload.artist' <<< "$line")

            title=$(truncate_text "$raw_title" 25)
            artist=$(truncate_text "$raw_artist" 15)

            label="$title – $artist"
            sketchybar --set media label="$label" icon="􀑪"
        fi
    done
