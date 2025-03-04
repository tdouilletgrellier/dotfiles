#!/bin/bash

# DIR="${HOME}/dotfiles/config/backgrounds/"
# PIC=$(find $DIR -maxdepth 1 -type f | shuf -n1)
# echo $PIC
# gsettings set org.gnome.desktop.background picture-uri file://"$PIC"

DIR="${HOME}/dotfiles/config/backgrounds/"

# Find a random image file safely
PIC=$(find "$DIR" -maxdepth 1 -type f -print0 | shuf -zn1 | tr -d '\0')

# Ensure a file was found
if [[ -n "$PIC" ]]; then
    echo "Setting wallpaper: $PIC"
    gsettings set org.gnome.desktop.background picture-uri "file://$PIC"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$PIC"
else
    echo "No wallpaper found in $DIR" >&2
    exit 1
fi
