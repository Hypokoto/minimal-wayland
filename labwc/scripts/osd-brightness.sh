#!/usr/bin/env bash
# Brightness OSD via Mako

ACTION=$1

if [ "$ACTION" == "up" ]; then
    brightnessctl set +5%
elif [ "$ACTION" == "down" ]; then
    brightnessctl set 5%-
fi

# Get current brightness
BRIGHTNESS=$(brightnessctl info | grep -oP "(?<=\()\d+(?=%\))")

notify-send -r 91111 -t 1500 -a "OSD" "Brightness: ${BRIGHTNESS}%"
