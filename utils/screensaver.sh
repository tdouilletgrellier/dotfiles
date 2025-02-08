#!/bin/bash

export TERM=xterm-256color

# Declare an array for available screensavers
screensavers=()

# Check if cmatrix exists and add it to the list
if command -v neo.sh &>/dev/null; then
    screensavers+=("neo.sh")
fi

# Check if cmatrix exists and add it to the list
if command -v cmatrix &>/dev/null; then
    screensavers+=("cmatrix -s")
elif command -v matrix.sh &>/dev/null; then
    screensavers+=("matrix.sh")
fi

# Check if pipes.sh exists and add it to the list
if command -v pipes.sh &>/dev/null; then
      screensavers+=("pipes.sh")
fi

# If at least one screensaver is available, pick one randomly
if [ ${#screensavers[@]} -gt 0 ]; then
    random_index=$((RANDOM % ${#screensavers[@]}))
    selected_screensaver="${screensavers[$random_index]}"
    exec $selected_screensaver
fi
