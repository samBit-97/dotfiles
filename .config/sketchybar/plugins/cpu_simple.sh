#!/bin/bash

source "$CONFIG_DIR/colors.sh"

CPU=$(top -l 1 -s 0 | awk '/CPU usage/ {print int($3) + int($5)}')

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
