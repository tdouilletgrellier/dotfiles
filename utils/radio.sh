#!/usr/bin/env bash

# Define color variables
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

url_rmp='https://millepattes.ice.infomaniak.ch/millepattes-high.mp3'
url_fip='http://direct.fipradio.fr/live/fip-webradio6.mp3'



# Function to choose and play radio stations using ffplay
play_radio() {
  echo -e "${GREEN}Select a radio station to play:${NC}"
  echo -e "${YELLOW}1) ${GREEN}Radio ${YELLOW}Mille ${RED}Patte${NC}"
  echo -e "${YELLOW}2) ${GREEN}F${YELLOW}I${RED}P ${YELLOW}Reggae${NC}"
  read -p "Enter the number of your choice: " choice

  # Check for available players in the specified order
  if command_exists mplayer; then
    PLAYER="mplayer"
  elif command_exists ffplay; then
    PLAYER="ffplay"
  elif command_exists vlc; then
    PLAYER="vlc"
  else
    echo -e "${RED}Error: No compatible media player (mplayer, ffplay, or vlc) found.${NC}"
    return 1
  fi
  
case $choice in
    1)
      echo -e "${GREEN}Playing Radio ${YELLOW}Mille ${RED}Patte with $PLAYER...${NC}"
      echo -e "${YELLOW}Press 'Ctrl+C' to stop the radio${NC}"
      if [ "$PLAYER" == "mplayer" ]; then
        mplayer $url_rmp
      elif [ "$PLAYER" == "ffplay" ]; then
        ffplay $url_rmp -nodisp -autoexit
      elif [ "$PLAYER" == "vlc" ]; then
        vlc $url_rmp
      fi
      ;;
    2)
      echo -e "${GREEN}Playing FIP Reggae with $PLAYER...${NC}"
      echo -e "${YELLOW}Press 'Ctrl+C' to stop the radio${NC}"
      if [ "$PLAYER" == "mplayer" ]; then
        mplayer $url_fip
      elif [ "$PLAYER" == "ffplay" ]; then
        ffplay $url_fip -nodisp -autoexit
      elif [ "$PLAYER" == "vlc" ]; then
        vlc $url_fip
      fi
      ;;
    *)
      echo -e "${RED}Invalid choice. Please select 1 or 2.${NC}"
      ;;
  esac
}

# Detect if script is sourced or executed directly
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    sourced=1
else
    sourced=0
fi

# Run or register aliases
if [[ $sourced -eq 0 ]]; then
    play_radio
else
    alias play-radio='play_radio'
fi

