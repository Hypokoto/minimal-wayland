#!/usr/bin/env bash
# Cage Kiosk Wrapper
# Change this to whatever single app you want to run (e.g., 'steam -tenfoot', 'kodi', 'firefox')
KIOSK_APP="kitty"

exec cage -- $KIOSK_APP
