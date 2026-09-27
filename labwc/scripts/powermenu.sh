#!/usr/bin/env bash
# Minimal Power Menu via Fuzzel

choice=$(echo -e "Lock\nLogout\nSuspend\nReboot\nShutdown" | fuzzel -d -p "Power: ")

case "$choice" in
    Lock)
        # Use swaylock or hyprlock
        swaylock
        ;;
    Logout)
        loginctl terminate-session "$XDG_SESSION_ID"
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
