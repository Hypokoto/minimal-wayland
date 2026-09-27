#!/usr/bin/env bash
ACTION="${1:-}"
if [ "$ACTION" = "off" ]; then
    wlr-randr | grep '^[A-Za-z0-9-]\+' -o | while read -r output; do
        wlr-randr --output "$output" --off
    done
elif [ "$ACTION" = "on" ]; then
    wlr-randr | grep '^[A-Za-z0-9-]\+' -o | while read -r output; do
        wlr-randr --output "$output" --on
    done
fi
