#!/usr/bin/env bash
# Volume OSD via Mako (Zero-awk, single-subshell optimized)

set -euo pipefail
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <up|down|mute|micmute>"
    exit 1
fi
ACTION=$1

if [ "$ACTION" = "up" ]; then
    wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
elif [ "$ACTION" = "down" ]; then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
elif [ "$ACTION" = "mute" ]; then
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
elif [ "$ACTION" = "mic-mute" ]; then
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    MIC_RAW=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null || echo "")
    if [[ "$MIC_RAW" == *"[MUTED]"* ]]; then
        notify-send -r 91112 -t 1500 -a "OSD" "Mic Muted"
    else
        notify-send -r 91112 -t 1500 -a "OSD" "Mic Unmuted"
    fi
    exit 0
fi

# Get current volume in a single execution
RAW=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null || echo "Volume: 0.00")

if [[ "$RAW" == *"[MUTED]"* ]]; then
    notify-send -r 91110 -t 1500 -a "OSD" "Volume: Muted"
else
    VOL_STR="${RAW#Volume: }"
    VOL_STR="${VOL_STR%% *}"
    if [[ "$VOL_STR" =~ ^([0-9]+)\.([0-9]{1,2})$ ]]; then
        int_part="${BASH_REMATCH[1]}"
        frac_part="${BASH_REMATCH[2]}"
        [ "${#frac_part}" -eq 1 ] && frac_part="${frac_part}0"
        vol_pct=$(( 10#$int_part * 100 + 10#$frac_part ))
    else
        vol_pct=0
    fi
    notify-send -r 91110 -t 1500 -a "OSD" "Volume: ${vol_pct}%"
fi
