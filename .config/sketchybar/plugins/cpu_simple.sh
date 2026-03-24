#!/bin/bash

source "$CONFIG_DIR/colors.sh"

CPU=$(top -l 2 -s 1 | awk '/CPU usage/ {print int($3) + int($5)}' | tail -1)

if [ "$CPU" -ge 80 ]; then
  COLOR=$RED
elif [ "$CPU" -ge 50 ]; then
  COLOR=$ORANGE
elif [ "$CPU" -ge 25 ]; then
  COLOR=$YELLOW
else
  COLOR=$GREEN
fi

sketchybar --set cpu_simple label="${CPU}%" label.color=$COLOR icon.color=$COLOR
