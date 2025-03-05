#!/bin/bash

DIR="${HOME}/dotfiles/config/backgrounds/"

usage() {
    echo "Usage: $0 [-r|--random] [-c|--choice]"
    exit 1
}

set_wallpaper() {
    local PIC="$1"
    echo "Setting wallpaper: $PIC"
    gsettings set org.gnome.desktop.background picture-uri "file://$PIC"
    # gsettings set org.gnome.desktop.background picture-uri-dark "file://$PIC"
}

if [[ $# -eq 0 ]]; then
    usage
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        -r|--random)
            PIC=$(find "$DIR" -maxdepth 1 -type f -print0 | shuf -zn1 | tr -d '\0')
            [[ -n "$PIC" ]] && set_wallpaper "$PIC" || { echo "No wallpaper found in $DIR" >&2; exit 1; }
            exit 0
            ;;
        -c|--choice)
            FILES=("$(find "$DIR" -maxdepth 1 -type f)")
            [[ ${#FILES[@]} -eq 0 ]] && { echo "No wallpapers found in $DIR" >&2; exit 1; }
            if command -v fzf >/dev/null; then
                PIC=$(printf "%s\n" "${FILES[@]}" | fzf)
            else
                echo "fzf not found, using basic selection"
                select PIC in "${FILES[@]}"; do
                    [[ -n "$PIC" ]] && break
                done
            fi
            [[ -n "$PIC" ]] && set_wallpaper "$PIC"
            exit 0
            ;;
        *)
            usage
            ;;
    esac
    shift
done
