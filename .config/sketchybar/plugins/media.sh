#!/bin/bash

MEDIA_CONTROL="/opt/homebrew/bin/media-control"

media-control stream | \
    while IFS= read -r line; do
        if [ "$(jq -r '.diff == false' <<< "$line")" = "true" ]; then
            title=$(jq -r '.payload.title' <<< "$line")
            artist=$(jq -r '.payload.artist' <<< "$line")
            label="$title – $artist"
            sketchybar --set media label="$label" icon="􀑪"
        fi
    done
