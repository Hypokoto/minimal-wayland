#!/usr/bin/env bash
# Volume OSD via Mako

set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <up|down|mute|mic-mute>"
    exit 1
fi
ACTION=$1

if command -v minosd >/dev/null 2>&1; then
    case "$ACTION" in
        up)       minosd V+5 && exit 0 ;;
        down)     minosd V-5 && exit 0 ;;
        mute)     minosd VM && exit 0 ;;
        mic-mute) minosd MM && exit 0 ;;
    esac
fi

case "$ACTION" in
    up)       wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ ;;
    down)     wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
    mute)     wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
    mic-mute) wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle ;;
esac

# Fallback volume notification
VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
notify-send -h string:x-canonical-private-synchronous:volume -t 1500 -a "OSD" "Volume: ${VOL}%"
