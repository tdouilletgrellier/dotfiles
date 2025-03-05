# Function to choose and play radio stations using ffplay
play_radio() {
  echo "Select a radio station to play:"
  echo "1) Radio Mille Patte"
  echo "2) FIP Reggae"
  read -p "Enter the number of your choice: " choice
  
  case $choice in
    1)
      echo "Playing Radio Mille Patte..."
      ffplay https://millepattes.ice.infomaniak.ch/millepattes-high.mp3 -nodisp -autoexit 
      ;;
    2)
      echo "Playing FIP Reggae..."
      ffplay http://direct.fipradio.fr/live/fip-webradio6.mp3 -nodisp -autoexit 
      ;;
    *)
      echo "Invalid choice. Please select 1 or 2."
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

