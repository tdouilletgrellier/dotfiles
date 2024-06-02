#!/bin/bash

DIR="${HOME}/dotfiles/config/backgrounds/"
PIC=$(find $DIR -maxdepth 1 -type f | shuf -n1)
echo $PIC
gsettings set org.gnome.desktop.background picture-uri file://"$PIC"