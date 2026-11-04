#!/bin/sh
# minimal clock — icon "Thu 05 Nov" + label "08:35" (gap matches item gap)
sketchybar --set "$NAME" icon="$(date '+%a %d %b')" label="$(date '+%H:%M')"
