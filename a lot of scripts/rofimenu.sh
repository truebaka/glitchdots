#!/bin/bash

if pgrep rofi; then
pkill rofi

else
OPTIONS="Wallpaper Menu\nApp Menu"

CHOICE=$(echo -e $OPTIONS | rofi -dmenu)

if [ -z "$CHOICE" ]; then
exit

else
case $CHOICE in
"Wallpaper Menu")
        $HOME/Documents/glitchcore/waybar/scripts/change-wallpaper.sh;
        ;;
"App Menu")
        rofi -show drun;
esac
fi
fi
