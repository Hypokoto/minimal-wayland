#!/usr/bin/env bash
# Minimal Power Menu via Fuzzel

choice=$(echo -e "Lock\nLogout\nSuspend\nReboot\nShutdown" | fuzzel -d -p "Power: ")

case "$choice" in
    Lock)
        # Use swaylock or hyprlock
        hyprlock || swaylock
        ;;
    Logout)
        labwc -e
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
