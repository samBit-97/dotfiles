#!/bin/bash

source "$CONFIG_DIR/colors.sh"

FREE=$(memory_pressure | awk '/free percentage/ {print $5}' | tr -d '%')
USED=$((100 - FREE))

if [ -z "$USED" ]; then
  USED=0
fi

COLOR=$GREEN
if [ "$USED" -ge 70 ]; then
  COLOR=$YELLOW
fi
if [ "$USED" -ge 90 ]; then
  COLOR=$RED
fi

sketchybar --set $NAME label="${USED}%" icon.color=$COLOR
