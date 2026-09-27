#!/usr/bin/env bash
set -euo pipefail

# Minimal Power Menu via Fuzzel
entries="Lock\nLogout\nSuspend\nReboot\nShutdown"
choice=$(printf '%b' "$entries" | fuzzel --dmenu --prompt "Power: ")

case "$choice" in
    Lock)
        if command -v swaylock >/dev/null 2>&1; then
            swaylock -f -C "${XDG_CONFIG_HOME:-$HOME/.config}/swaylock/config" 2>/dev/null || swaylock -f
        fi
        ;;
    Logout)
        loginctl terminate-session "${XDG_SESSION_ID:-}" 2>/dev/null \
            || labwc --exit 2>/dev/null \
            || pkill -u "$USER" -x labwc
        ;;
    Suspend)
        systemctl suspend
        ;;
    Reboot)
        systemctl reboot
        ;;
    Shutdown)
        systemctl poweroff
        ;;
esac
