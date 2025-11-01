#!/bin/bash

WALLPAPERS="/home/aleksik/Pictures/wallpaper/"

CHOICE=$(ls $WALLPAPERS | rofi -dmenu)

if [ -z "$CHOICE"]; then
exit

else
hyprctl hyprpaper reload ,$WALLPAPERS$CHOICE -q
fi
