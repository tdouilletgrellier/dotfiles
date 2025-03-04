#!/bin/bash

# if [ $(wmctrl -xl | grep -c "$2") != 0 ]; then
# 	wmctrl -xa "$2"
# else
# 	$1 &
# fi

# Check if the window exists
if wmctrl -xl | grep -qi "$2"; then
    wmctrl -xa "$2" && wmctrl -i -R "$(wmctrl -xl | grep -i "$2" | awk '{print $1}')"
else
    # If the process is not already running, launch it
    if ! pgrep -fx "$1" >/dev/null; then
        nohup "$1" >/dev/null 2>&1 &
    fi
fi
