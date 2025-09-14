#!/bin/bash

# Get raw usage from top (user + sys total across all cores)
cpu_usage=$(ps -A -o %cpu | awk '{s+=$1} END {print s}')
cpu_usage_int=$(printf "%.0f" "$cpu_usage")

# Normalise to 0–100 like btop
cpu_norm=$(echo "$cpu_usage_int / 8" | bc)
cpu_int=$(printf "%.0f" "$cpu_norm")

sketchybar --set "$NAME" icon="􀫥" label="${cpu_int}%"
