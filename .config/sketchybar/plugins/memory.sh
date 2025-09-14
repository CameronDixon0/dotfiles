#!/bin/bash

# Page size (bytes per memory page)
page_size=$(vm_stat | head -1 | awk '{print $8}')
page_size=${page_size%\.} # strip trailing '.'

# Get memory pages
free=$(vm_stat | awk '/Pages free/ {print $3}' | tr -d '.')
inactive=$(vm_stat | awk '/Pages inactive/ {print $3}' | tr -d '.')
speculative=$(vm_stat | awk '/Pages speculative/ {print $3}' | tr -d '.')
wired=$(vm_stat | awk '/Pages wired down/ {print $4}' | tr -d '.')
active=$(vm_stat | awk '/Pages active/ {print $3}' | tr -d '.')

used=$(( (active + wired) * page_size ))

gb_used=$(echo "scale=1; $used/1024/1024/1024" | bc)

# Update SketchyBar item
sketchybar --set "$NAME" icon="􀫦" label="${gb_used}GB"
