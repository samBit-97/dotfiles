#!/bin/bash

source "$CONFIG_DIR/colors.sh"

PERCENTAGE=$(df -H / | awk 'NR==2 {gsub(/%/,""); print $5}')
USED=$(df -H / | awk 'NR==2 {print $3}')
FREE=$(df -H / | awk 'NR==2 {print $4}')

if [ "$PERCENTAGE" -ge 50 ]; then
  COLOR=$YELLOW
  [ "$PERCENTAGE" -ge 80 ] && COLOR=$RED
  sketchybar --set $NAME label="${USED}/${FREE}" icon.color=$COLOR drawing=on
else
  sketchybar --set $NAME drawing=off
fi
