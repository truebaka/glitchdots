#!/bin/bash

if pgrep rofi; then
pkill rofi

else
OPTIONS="App Menu\nWallpaper Menu"

CHOICE=$(echo -e $OPTIONS | rofi -dmenu)

if [ -z "$CHOICE" ]; then
exit

else
case $CHOICE in
("App Menu")
    rofi -show drun;
      ;;
("Wallpaper Menu")
        $HOME/Documents/glitchcore/waybar/scripts/change-wallpaper.sh --choose;

esac
fi
fi
