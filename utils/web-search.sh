
#!/bin/bash

##############################################
# Bash functions for launching a web search  #
#                                            #
# Usage:                                     #
# -Either source this file, or run directly  #
# -Run with --help for full list of options  #
#                                            #
# Licensed under MIT, (C) Alicia Sykes 2022  #
##############################################

# URL encodes the users search string
ws_url_encode() {
  local length="${#1}"
  for i in $(seq 0 $((length-1))); do
    local c="${1:$i:1}"
    case $c in
      [a-zA-Z0-9.~_-]) printf '%s' "$c" ;;
      *) printf '%%%02X' "'$c" ;;
    esac
  done
}

# Determines which opening method/ browser to use, and opens URL
ws_launch_url() {
  command_exists () {
    hash "$1" 2> /dev/null
  }
  if [[ $OSTYPE == 'darwin'* ]]; then
    open $1
  elif command_exists xdg-open; then
    xdg-open $1
    echo -e "\033[0;32m🌐 Launching \033[4;32m$1\033[0;90m\nPress [Enter] to exit\e[0m"
  elif command_exists lynx; then
    lynx -vikeys -accept_all_cookies $1
  elif command_exists browsh; then
    browsh $1
  elif command_exists links2; then
    links2 -g $1
  elif command_exists links; then
    links $1
  else
    echo -e "\033[0;33mUnable to launch browser, open manually instead"
    echo -e "\033[1;96m🌐 URL: \033[0;96m\e[4m$1\e[0m"
    return;
  fi
}

# Combines URL with encoded search term. Prompts user if search term missing
ws_make_search() {
  search_term=${@:2}
  if [ -z $1 ]; then # Check first parameter is present
    echo -e "\033[0;93mError, no search engine URL provided\e[0m"
    web_search
    return
  fi
  if [ -z $2 ]; then # Check second parameter, prompt user if missing
    echo "Enter Search Term: "
    read search_term
  fi
  # Encode search term, append to URL, and call launch function
  search_term=$(ws_url_encode $search_term)
  web_address="$1$search_term"
  ws_launch_url $web_address
}

# Functions that call make search, with search engines URL
ws_duckduckgo() {
  ws_make_search 'https://duckduckgo.com/?q=' "$@"
}
ws_wikipedia() {
  ws_make_search 'https://en.wikipedia.org/w/index.php?search=' "$@"
}
ws_google() {
  ws_make_search 'https://www.google.com/search?q=' "$@"
}
ws_github() {
  ws_make_search 'https://github.com/search?q=' "$@"
}
ws_stackoverflow() {
  ws_make_search 'https://stackoverflow.com/search?q=' "$@"
}
ws_wolframalpha() {
  ws_make_search 'https://www.wolframalpha.com/input?i=' "$@"
}
ws_reddit() {
  ws_make_search 'https://www.reddit.com/search/?q=' "$@"
}
ws_maps() {
  ws_make_search 'https://www.google.com/maps/search/' "$@"
}
ws_grepapp() {
  ws_make_search 'https://grep.app/search?q=' "$@"
}

ws_youtube() { 
  ws_make_search 'https://www.youtube.com/results?search_query=' "$@"
}

ws_chatgpt() { 
  ws_make_search 'https://chat.openai.com/?q=' "$@"
}

# Lists available search options
web_search() {
  # Define colors
  COLOR_TITLE="\033[1;36m"  # Cyan, bold
  COLOR_WARNING="\033[0;33m"  # Yellow
  COLOR_ERROR="\033[0;91m"  # Light Red
  COLOR_GOODBYE="\033[0;93m"  # Light Yellow
  COLOR_RESET="\033[0m"  # Reset

  # If help flag specified, show help
  [[ $@ == *"--help"* || $@ == "help" ]] && show_ws_help && return
  # If user specified search engine, jump strait to that function
  if [ -n "${1+set}" ]; then
    [[ $@ == "duckduckgo"* ]] && ws_duckduckgo "${@/duckduckgo/}" && return
    [[ $@ == "wikipedia"* ]] && ws_wikipedia "${@/wikipedia/}" && return
    [[ $@ == "github"* ]] && ws_github "${@/github/}" && return
    [[ $@ == "stackoverflow"* ]] && ws_stackoverflow "${@/stackoverflow/}" && return
    [[ $@ == "wolframalpha"* ]] && ws_wolframalpha "${@/wolframalpha/}" && return
    [[ $@ == "reddit"* ]] && ws_reddit "${@/reddit/}" && return
    [[ $@ == "maps"* ]] && ws_maps "${@/maps/}" && return
    [[ $@ == "google"* ]] && ws_google "${@/google/}" && return
    [[ $@ == "grepapp"* ]] && ws_grepapp "${@/grepapp/}" && return
    [[ $@ == "youtube"* ]] && ws_youtube "${@/youtube/}" && return
    [[ $@ == "chatgpt"* ]] && ws_chatgpt "${@/chatgpt/}" && return
  fi
  # Otherwise show menu input for search engines
  choices=(
    duckduckgo wikipedia google github stackoverflow
    wolframalpha reddit maps grepapp youtube chatgpt 'help' quit
    )
  PS3='❯ '
  echo -e "${COLOR_TITLE}Select a Search Option${COLOR_RESET}"
  select opt in ${choices[@]}; do
    case $opt in
      duckduckgo) ws_duckduckgo $@; return;;
      wikipedia) ws_wikipedia $@; return;;
      google) ws_google $@; return;;
      github) ws_github $@; return;;
      stackoverflow) ws_stackoverflow $@; return;;
      wolframalpha) ws_wolframalpha $@; return;;
      reddit) ws_reddit $@; return;;
      maps) ws_maps $@; return;;
      grepapp) ws_grepapp $@; return;;
      youtube) ws_youtube $@; return;;
      chatgpt) ws_chatgpt $@; return;;
      help) show_ws_help; break;;
      quit) echo -e "${COLOR_GOODBYE}Bye 👋${COLOR_RESET}"; break ;;
      *)
        echo -e "${COLOR_ERROR}Invalid option: '$REPLY'${COLOR_RESET}"
        echo -e "${COLOR_WARNING}Enter the number corresponding to one of the above options${COLOR_RESET}"
        break
      ;;
    esac
  done
}



# Set up some shorthand aliases
alias web-search='web_search'
alias wsddg='ws_duckduckgo'
alias wswiki='ws_wikipedia'
alias wsgh='ws_github'
alias wsso='ws_stackoverflow'
alias wswa='ws_wolframalpha'
alias wsrdt='ws_reddit'
alias wsmap='ws_maps'
alias wsggl='ws_google'
alias wsgra='ws_grepapp'
alias wsyt='ws_youtube'
alias wsgpt='ws_chatgpt'

# Set ws alias, only if not used by another program
if ! hash ws 2> /dev/null; then
  alias ws='web_search'
fi

# Prints usage options
show_ws_help() {
  # Define color variables
  local CYAN='\033[1;36m'
  local LIGHT_CYAN='\033[0;36m'
  local GREEN='\033[0;32m'
  local YELLOW='\033[0;33m'
  local MAGENTA='\033[1;35m'
  local LIGHT_MAGENTA='\033[0;35m'
  local RESET='\e[0m'
  local BOLD='\033[1m'
  local UNDERLINE='\033[4m'

  echo -e "${CYAN}CLI Web Search${RESET}"
  echo -e "${LIGHT_CYAN}\x1b[2mA set of functions for searching the web from the command line.${RESET}"
  echo
  echo -e "${LIGHT_CYAN}${UNDERLINE}Example Usage:${RESET}"
  echo -e "  (1) View menu, select search engine by index, then enter a search term"
  echo -e "    $ ${BOLD}web-search${RESET}"
  echo -e "  (2) Enter a search term, and be prompted for which search engine to use"
  echo -e "    $ ${BOLD}web-search Hello World!${RESET}"
  echo -e "  (3) Enter a search engine followed by search term"
  echo -e "    $ ${BOLD}web-search wikipedia Matrix Defense${RESET}"
  echo -e "  (4) Enter a search engine, and be prompted for the search term"
  echo -e "    $ ${BOLD}web-search duckduckgo${RESET}"
  echo
  echo -e "${LIGHT_CYAN}${UNDERLINE}Shorthand${GREEN}"
  echo -e "  You can also use the ${YELLOW}ws${RESET} alias instead of typing ${BOLD}web-search${RESET}"
  echo
  echo -e "${LIGHT_CYAN}${UNDERLINE}Supported Search Engines:${GREEN}"
  echo -e "  ${YELLOW}DuckDuckGo: \x1b[2m$ ws duckduckgo (or $ wsddg)${RESET}"
  echo -e "  ${YELLOW}Wikipedia: \x1b[2m$ ws wikipedia or ($ wswiki)${RESET}"
  echo -e "  ${YELLOW}GitHub: \x1b[2m$ ws github or ($ wsgh)${RESET}"
  echo -e "  ${YELLOW}StackOverflow: \x1b[2m$ ws stackoverflow or ($ wsso)${RESET}"
  echo -e "  ${YELLOW}Wolframalpha: \x1b[2m$ ws wolframalpha or ($ wswa)${RESET}"
  echo -e "  ${YELLOW}Reddit: \x1b[2m$ ws reddit or ($ wsrdt)${RESET}"
  echo -e "  ${YELLOW}Maps: \x1b[2m$ ws maps or ($ wsmap)${RESET}"
  echo -e "  ${YELLOW}Google: \x1b[2m$ ws google or ($ wsggl)${RESET}"
  echo -e "  ${YELLOW}Grep.App: \x1b[2m$ ws grepapp or ($ wsgra)${RESET}"
  echo -e "  ${YELLOW}Youtube: \x1b[2m$ ws youtube or ($ wsyt)${RESET}"
  echo -e "  ${YELLOW}ChatGPT: \x1b[2m$ ws chatgpt or ($ wsgpt)${RESET}"
  echo -e "${RESET}"
}

# Determine if file is being run directly or sourced
([[ -n $ZSH_EVAL_CONTEXT && $ZSH_EVAL_CONTEXT =~ :file$ ]] || 
  [[ -n $KSH_VERSION && $(cd "$(dirname -- "$0")" &&
    printf '%s' "${PWD%/}/")$(basename -- "$0") != "${.sh.file}" ]] || 
  [[ -n $BASH_VERSION ]] && (return 0 2>/dev/null)) && sourced=1 || sourced=0

# If running directly, then show menu, or help
if [ $sourced -eq 0 ]; then
  if [[ $@ == *"--help"* ]]; then
    show_ws_help
  else
    web_search "$@"
  fi
fi
