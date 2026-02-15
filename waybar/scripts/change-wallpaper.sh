#!/usr/bin/bash

MONITOR="HDMI-A-1"

choice=$(echo -e "Pictures\nVideo" | rofi -dmenu)
[ -z "$choice" ] && exit
if [ "$choice" = "Pictures" ]; then
    file=$(ls "$HOME/Documents/glitchcore/wallpapers/pictures/" | rofi -dmenu)
    [ -z "$file" ] && exit
    
    FULLPATH="$HOME/Documents/glitchcore/wallpapers/pictures/$file"

    pkill -f gslapper

    gslapper -o "fill" "*" "$FULLPATH"

    echo "gslapper -o \"fill\" \"*\" \"$FULLPATH\"" > ~/Documents/glitchcore/last_wallpaper.sh

elif [ "$choice" = "Video" ]; then
    file=$(ls $HOME/Documents/glitchcore/wallpapers/videos/ | rofi -dmenu)
    [ -z "$file" ] && exit

    FULLPATH="$HOME/Documents/glitchcore/wallpapers/videos/$file"

    pkill -f gslapper

    gslapper -o "loop" "*" "$FULLPATH"

    echo "gslapper -o \"loop\" \"*\" \"$FULLPATH\"" > ~/Documents/glitchcore/last_wallpaper.sh

fi
