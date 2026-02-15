#!/bin/bash

LOGOS="/home/aleksik/Documents/glitchcore/dlyaconfig/logos/"

CHOICE=$(ls $LOGOS | rofi -dmenu)

if [ -z "$CHOICE" ]; then
exit

else
	sed -i "2s|.*|    set -g my_logo $LOGOS$CHOICE|" ~/.config/fish/config.fish
echo -e
fi
