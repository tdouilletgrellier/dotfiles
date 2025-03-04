#!/bin/bash

# Simple script to output a solid line in the terminal
# Useful for marking the end of a task in your bash log
# Inspired by @LuRsT's script of the same name
# Can be called directly, or source'd in *rc file
# Licensed under MIT, (C) Alicia Sykes 2022
# Enhanced

# Determine width of terminal
hr_col_count="$(tput cols)"
if [ -z "$hr_col_count" ] || [ "$hr_col_count" -lt 1 ]; then
    hr_col_count="${COLUMNS:-80}"
fi

# Colors
# hr_color=${hr_color:-$'\e[46;1m'}
hr_color=${hr_color:-$'\e[1m'}  # Only bold text, no background
hr_reset=$'\e[0m'

# Prints the HR line
hr_draw_char() {
    local CHAR="$1"
    local LINE
    LINE=$(printf "%*s" $((hr_col_count - 2)))
    LINE="${LINE// /${CHAR}}"
    printf "◀${hr_color}${LINE:0:$hr_col_count}${hr_reset}▶\n"
}

# Passes param and calls hr()
hr() {
    for WORD in "${@:--}"; do
        hr_draw_char "$WORD"
    done
}

# Determine if file is being run directly or sourced
([[ -n $ZSH_EVAL_CONTEXT && $ZSH_EVAL_CONTEXT =~ :file$ ]] || 
 [[ -n $KSH_VERSION && $(cd "$(dirname -- "$0")" &&
    printf '%s' "${PWD%/}/")$(basename -- "$0") != "${.sh.file}" ]] || 
 [[ -n $BASH_VERSION ]] && (return 0 2>/dev/null)) && sourced=1 || sourced=0

# Either instantiate immediately, or set alias for later
if [ $sourced -eq 0 ]; then
  [ "$0" == "$BASH_SOURCE" ] && hr "$@"
else
  alias hr='hr'
fi
