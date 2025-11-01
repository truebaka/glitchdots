#!/bin/bash

if pgrep rofi; then
pkill rofi

else
OPTIONS="Reboot\nShutdown\nLogOut\nLock"

CHOICE=$(echo -e $OPTIONS | rofi -dmenu -p "Power Menu")

if [ -z "$CHOICE" ]; then
exit

else
case $CHOICE in
"Shutdown")
	shutdown now;
	;;
"Reboot")
	reboot;
	;;
"Lock")
	hyprlock 1> /dev/null;
	;;
"LogOut")
	hyprctl dispatch exit 1> /dev/null;
esac
fi
fi
