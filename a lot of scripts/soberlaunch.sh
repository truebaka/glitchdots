#!/bin/bash

if pgrep rofi; then
pkill rofi

else
OPTIONS="Sober\nSober2"

CHOICE=$(echo -e $OPTIONS | rofi -dmenu)

if [ -z "$CHOICE" ]; then
exit

else
case $CHOICE in
"Sober")
	flatpak run org.vinegarhq.Sober
        ;;
"Sober2")
        $HOME/.local/bin/sober2
esac
fi
fi
