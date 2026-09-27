#!/usr/bin/env bash
# Volume OSD via Mako

set -euo pipefail
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <up|down|mute|micmute>"
    exit 1
fi
ACTION=$1

if [ "$ACTION" = "up" ]; then
    wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
elif [ "$ACTION" == "down" ]; then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
elif [ "$ACTION" = "mute" ]; then
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
elif [ "$ACTION" = "mic-mute" ]; then
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    MIC_MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | grep -i MUTED || true)
    if [ -n "$MIC_MUTED" ]; then
        notify-send -r 91112 -t 1500 -a "OSD" "Mic Muted"
    else
        notify-send -r 91112 -t 1500 -a "OSD" "Mic Unmuted"
    fi
    exit 0
fi

# Get current volume
VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{print $2 * 100}' || echo "0")
MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | grep -i MUTED || true)

if [ -n "$MUTED" ]; then
    notify-send -r 91110 -t 1500 -a "OSD" "Volume: Muted"
else
    notify-send -r 91110 -t 1500 -a "OSD" "Volume: ${VOL%.*}%"
fi
