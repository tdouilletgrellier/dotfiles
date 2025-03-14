#-------------------------------------------------------------
#  _____ _   _ _   _  ____ _____ ___ ___  _   _ ____
# |  ___| | | | \ | |/ ___|_   _|_ _/ _ \| \ | / ___|
# | |_  | | | |  \| | |     | |  | | | | |  \| \___ \
# |  _| | |_| | |\  | |___  | |  | | |_| | |\  |___) |
# |_|    \___/|_| \_|\____| |_| |___\___/|_| \_|____/
#
#-------------------------------------------------------------

#-------------------------------------------------------------
# Print time-based personalized message, using figlet & lolcat if available
function welcome_greeting() {
	# Help message
	if [[ $# -eq 1 && ("$1" == "-h" || "$1" == "--help") ]]; then
		echo -e "${BRIGHT_WHITE}welcome_greeting:${RESET} Greets the user based on the time of day"
		echo -e "You can make the greeting boring (without formatting) using the ${BRIGHT_CYAN}-b, --boring${RESET} option."
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}welcome_greeting${RESET} [${BRIGHT_YELLOW}OPTIONS${RESET}]"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_YELLOW}-b, --boring${RESET}  Display a simple greeting without extra formatting"
		echo -e "  ${BRIGHT_YELLOW}-h, --help${RESET}    Show this help message"
		echo -e "${BRIGHT_WHITE}Examples:${RESET}"
		echo -e "  ${BRIGHT_CYAN}welcome_greeting${RESET}        # Normal greeting with formatting"
		echo -e "  ${BRIGHT_CYAN}welcome_greeting -b${RESET}     # Simple greeting without formatting"
		return 0
	fi

	local boring=0

	# Parse options
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-b | --boring) boring=1 ;;
		-h | --help) # Show help message
			$0          # Calling itself with no arguments to display the help message
			return 0
			;;
		*)
			echo "Invalid option: $1" >&2
			return 1
			;;
		esac
		shift
	done

	# Get the current hour
	h=$(date +%H)
	h=$((10#$h))
	if [ $h -lt 4 ] || [ $h -gt 22 ]; then
		greeting="Good Night"
	elif [ $h -lt 12 ]; then
		greeting="Good morning"
	elif [ $h -lt 18 ]; then
		greeting="Good afternoon"
	elif [ $h -lt 22 ]; then
		greeting="Good evening"
	else
		greeting="Hello"
	fi
	WELCOME_MSG="$greeting $USER!"

	# Display greeting based on the '-b' option
	if ((boring)); then
		echo -e "$BRIGHT_GREEN${WELCOME_MSG}${RESET}\n"
	else
		if hascommand --strict lolcat && hascommand --strict figlet; then
			echo "${WELCOME_MSG}" | figlet | lolcat
		else
			echo -e "$BRIGHT_GREEN${WELCOME_MSG}${RESET}\n"
		fi
	fi
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Print system information with neofetch or fastfetch if it's installed
function welcome_sysinfo() {
	# Help message
	if [[ $# -eq 1 && ("$1" == "-h" || "$1" == "--help") ]]; then
		echo -e "${BRIGHT_WHITE}welcome_sysinfo:${RESET} Displays system information using ${BRIGHT_CYAN}fastfetch${RESET} or ${BRIGHT_CYAN}neofetch${RESET}"
		echo -e "The function automatically selects the best available tool (${BRIGHT_CYAN}fastfetch${RESET} or ${BRIGHT_CYAN}neofetch${RESET})"
		echo -e "You can override the selection using the options below."
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}welcome_sysinfo${RESET} [${BRIGHT_YELLOW}OPTIONS${RESET}]"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_YELLOW}-f, --fastfetch${RESET}  Force the use of fastfetch"
		echo -e "  ${BRIGHT_YELLOW}-n, --neofetch${RESET}   Force the use of neofetch"
		echo -e "  ${BRIGHT_YELLOW}-w, --welcome-today${RESET} Call the welcome_today function directly"
		echo -e "  ${BRIGHT_YELLOW}-b, --boring${RESET}        Directly call welcome_today with boring output"
		echo -e "  ${BRIGHT_YELLOW}-h, --help${RESET}       Show this help message"
		echo -e "${BRIGHT_WHITE}Examples:${RESET}"
		echo -e "  ${BRIGHT_CYAN}welcome_sysinfo${RESET}         # Automatically chooses fastfetch or neofetch"
		echo -e "  ${BRIGHT_CYAN}welcome_sysinfo -f${RESET}      # Force fastfetch"
		echo -e "  ${BRIGHT_CYAN}welcome_sysinfo --neofetch${RESET}  # Force neofetch"
		echo -e "  ${BRIGHT_CYAN}welcome_sysinfo --welcome-today${RESET}  # Directly call welcome_today"
		echo -e "  ${BRIGHT_CYAN}welcome_sysinfo --boring${RESET}     # Directly call welcome_today with boring output"
		return 0
	fi

	local use_fastfetch=0
	local use_neofetch=0
	local call_welcome_today=0

	# Loop through arguments
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-f | --fastfetch) use_fastfetch=1 ;;
		-n | --neofetch) use_neofetch=1 ;;
		-w | --welcome-today) call_welcome_today=1 ;;
		-b | --boring)
			# Directly call welcome_today with the -b option
			welcome_today -b
			return 0
			;;
		*)
			echo "Invalid option: $1" >&2
			return 1
			;;
		esac
		shift
	done

	# If welcome_today is called directly, just call it
	if ((call_welcome_today)); then
		welcome_today
		return 0
	fi

	# Fastfetch section
	if ((use_fastfetch)); then
		if hascommand --strict fastfetch; then
			if [[ -f "${HOME}/.config/fastfetch/fastfetch.jsonc" ]]; then
				fastfetch --config "${HOME}/.config/fastfetch/fastfetch.jsonc"
			else
				fastfetch --config archey
			fi
			return 0
		else
			welcome_today
			return 1
		fi
	# Neofetch section
	elif ((use_neofetch)); then
		if hascommand --strict neofetch; then
			if [[ -f "${HOME}/.config/neofetch/neofetch.conf" ]]; then
				neofetch --config "${HOME}/.config/neofetch/neofetch.conf"
			else
				neofetch --disable title separator underline bar gpu memory disk cpu users local_ip public_ip font wm_theme --os --host --kernel --uptime --packages --shell --resolution --de --wm --terminal
			fi
			return 0
		else
			welcome_today
			return 1
		fi
	fi

	# Default behavior: Try fastfetch, then neofetch, then fallback to welcome_today
	if hascommand --strict fastfetch; then
		if [[ -f "${HOME}/.config/fastfetch/fastfetch.jsonc" ]]; then
			fastfetch --config "${HOME}/.config/fastfetch/fastfetch.jsonc"
		else
			fastfetch --config archey
		fi
	elif hascommand --strict neofetch; then
		if [[ -f "${HOME}/.config/neofetch/neofetch.conf" ]]; then
			neofetch --config "${HOME}/.config/neofetch/neofetch.conf"
		else
			neofetch --disable title separator underline bar gpu memory disk cpu users local_ip public_ip font wm_theme --os --host --kernel --uptime --packages --shell --resolution --de --wm --terminal
		fi
	else
		welcome_today
	fi
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Print basic info : last login, date, hostname
function welcome_today() {
	# Help message
	if [[ $# -eq 1 && ("$1" == "-h" || "$1" == "--help") ]]; then
		echo -e "${BRIGHT_WHITE}welcome_today:${RESET} Displays information about the last login, current date/time, and hostname"
		echo -e "You can make the output boring (without color formatting) using the ${BRIGHT_CYAN}-b, --boring${RESET} option."
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}welcome_today${RESET} [${BRIGHT_YELLOW}OPTIONS${RESET}]"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_YELLOW}-b, --boring${RESET}  Display a simple output without extra formatting"
		echo -e "  ${BRIGHT_YELLOW}-l, --lolcat${RESET}  Display a simple output with lolcat formatting"
		echo -e "  ${BRIGHT_YELLOW}-h, --help${RESET}    Show this help message"
		echo -e "${BRIGHT_WHITE}Examples:${RESET}"
		echo -e "  ${BRIGHT_CYAN}welcome_today${RESET}        # Normal output with color formatting"
		echo -e "  ${BRIGHT_CYAN}welcome_today -b${RESET}     # Simple output without formatting"
		return 0
	fi

	local boring=0
	local lolcat=0

	# Parse options
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-b | --boring) boring=1 ;;
		-l | --lolcat) lolcat=1 ;;
		-h | --help) # Show help message
			$0          # Calling itself with no arguments to display the help message
			return 0
			;;
		*)
			echo "Invalid option: $1" >&2
			return 1
			;;
		esac
		shift
	done

	# Ensure reset before printing
	echo -e "${RESET}"

	# Get last login info (more efficient command)
	last_login=$(last | grep "^$USER " | head -1 | awk '{print $4, $5, $6, $7}')

	# Convert last login time to the desired format
	if date --version >/dev/null 2>&1; then
		# GNU date (Linux)
		formatted_last_login=$(date -d "$last_login" '+%a %d %b at %H:%M' 2>/dev/null)
	else
		# BSD date (macOS)
		formatted_last_login=$(date -j -f "%b %d %H:%M" "$last_login" "+%a %d %b at %H:%M" 2>/dev/null)
	fi

	# Get date and time with more reliable format specifiers
	current_date=$(date '+%a %d %b at %H:%M')

	# Get hostname
	host_info="$(hostname)"

	# Output with fallback for missing unicode symbols
	if ((boring)); then
		echo -e "${GREEN}⧗ ${formatted_last_login}${RESET}"
		echo -e "${GREEN}⏲ ${current_date}${RESET}"
		echo -e "${GREEN}⌂ ${host_info}${RESET}"
	else
		if ((lolcat)) && hascommand --strict lolcat; then
			# Colorful version with cleaner variable expansion
			echo -e "${GREEN}⧗ ${formatted_last_login}${RESET}" | lolcat
			echo -e "${GREEN}⏲ ${current_date}${RESET}" | lolcat
			echo -e "${GREEN}⌂ ${host_info}${RESET}" | lolcat
		else
			# Colorful version with cleaner variable expansion
			echo -e "${BRIGHT_GREEN}⧗${RESET} ${BRIGHT_GREEN}${formatted_last_login}"
			echo -e "${BRIGHT_YELLOW}⏲${RESET} ${BRIGHT_YELLOW}${current_date}"
			echo -e "${BRIGHT_RED}⌂${RESET} ${BRIGHT_RED}${host_info}"
		fi
	fi

	echo -e "${RESET}" # Reset colors at the end
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Display weather
function weather() {
	# Help message
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then
		echo -e "${BRIGHT_WHITE}weather:${RESET} Displays the current weather conditions."
		echo -e "Fetches weather data from wttr.in with a short timeout."
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}weather${RESET} ${BRIGHT_YELLOW}[OPTIONS]${RESET}"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_YELLOW}-h, --help${RESET}  Show this help message"
		echo -e "  ${BRIGHT_YELLOW}-t, --timeout <sec>${RESET}  Set a custom timeout for the request (default: 0.5s)"
		echo -e "${BRIGHT_WHITE}Examples:${RESET}"
		echo -e "  ${BRIGHT_CYAN}weather${RESET}        # Get the current weather with the default timeout"
		echo -e "  ${BRIGHT_CYAN}weather -t 1.5${RESET}  # Set a custom timeout of 1.5 seconds"
		return 0
	fi

	# Default timeout value
	local timeout=0.5

	# Parse options
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-t | --timeout)
			shift
			timeout="$1"
			;;
		*)
			echo "Invalid option: $1" >&2
			return 1
			;;
		esac
		shift
	done

	# Fetch weather with a timeout
	curl -s -m "$timeout" "https://wttr.in?format=%cWeather:+%C+%t,+%p+%w"

	echo -e "${RESET}"
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Display fortune
function display_fortune() {
	# Help message
	if [[ $# -eq 1 && ("$1" == "-h" || "$1" == "--help") ]]; then
		echo -e "${BRIGHT_WHITE}display_fortune:${RESET} Displays a fortune with an option for a boring (plain) version"
		echo -e "You can make the output boring (without formatting) using the ${BRIGHT_CYAN}-b, --boring${RESET} option."
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}display_fortune${RESET} [${BRIGHT_YELLOW}OPTIONS${RESET}]"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_YELLOW}-b, --boring${RESET}  Display a plain fortune without extra formatting"
		echo -e "  ${BRIGHT_YELLOW}-h, --help${RESET}    Show this help message"
		echo -e "${BRIGHT_WHITE}Examples:${RESET}"
		echo -e "  ${BRIGHT_CYAN}display_fortune${RESET}        # Fortune with formatting"
		echo -e "  ${BRIGHT_CYAN}display_fortune -b${RESET}     # Plain fortune without formatting"
		return 0
	fi

	local boring=0

	# Parse options
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-b | --boring) boring=1 ;;
		-h | --help) # Show help message
			$0          # Calling itself with no arguments to display the help message
			return 0
			;;
		*)
			echo "Invalid option: $1" >&2
			return 1
			;;
		esac
		shift
	done

	# Reset colors before output
	echo -e "${RESET}"

	# Check for the presence of the `lolcat` command
	if hascommand --strict lolcat; then
		if ((boring)); then
			# Plain fortune without any formatting
			[ -x /usr/games/fortune ] && echo -e "$GREEN$(/usr/games/fortune -s)${RESET}"
		else
			# Fortune with `lolcat` formatting
			[ -x /usr/games/fortune ] && /usr/games/fortune -s | lolcat
		fi
	else
		if ((boring)); then
			# Plain fortune without any formatting
			[ -x /usr/games/fortune ] && echo -e "$GREEN$(/usr/games/fortune -s)${RESET}"
		else
			# Fortune with `lolcat` formatting
			[ -x /usr/games/fortune ] && echo -e "$YELLOW$(/usr/games/fortune -s)${RESET}"
		fi
	fi
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Function to display sparkbars
function display_sparkbars() {
	# Help message
	if [[ $# -eq 1 && ("$1" == "-h" || "$1" == "--help") ]]; then
		echo -e "${BRIGHT_WHITE}display_sparkbars:${RESET} Displays sparkbars with an option for a boring (plain) version"
		echo -e "You can make the output boring (without formatting) using the ${BRIGHT_CYAN}-b, --boring${RESET} option."
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}display_sparkbars${RESET} [${BRIGHT_YELLOW}OPTIONS${RESET}]"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_YELLOW}-b, --boring${RESET}  Display sparkbars without extra formatting"
		echo -e "  ${BRIGHT_YELLOW}-h, --help${RESET}    Show this help message"
		echo -e "${BRIGHT_WHITE}Examples:${RESET}"
		echo -e "  ${BRIGHT_CYAN}display_sparkbars${RESET}        # Sparkbars with formatting"
		echo -e "  ${BRIGHT_CYAN}display_sparkbars -b${RESET}     # Plain sparkbars without formatting"
		return 0
	fi

	local boring=0

	# Parse options
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-b | --boring) boring=1 ;;
		-h | --help) # Show help message
			$0          # Calling itself with no arguments to display the help message
			return 0
			;;
		*)
			echo "Invalid option: $1" >&2
			return 1
			;;
		esac
		shift
	done

	# Reset colors before output
	echo -e "${RESET}"

	# Check for the presence of the `lolcat` command
	if hascommand --strict lolcat; then
		if ((boring)); then
			# Plain sparkbars without any formatting
			echo -e "$GREEN$(sparkbars)${RESET}"
		else
			# Sparkbars with `lolcat` formatting
			sparkbars | lolcat
		fi
	else
		# Fallback for when `lolcat` is not available
		[[ -z "${TMUX}" ]] && echo -e "$GREEN$(sparkbars)${RESET}"
	fi
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Main welcome function
function welcome() {
	# Help message
	if [[ $# -eq 1 && ("$1" == "-h" || "$1" == "--help") ]]; then
		echo -e "${BRIGHT_WHITE}welcome:${RESET} Displays a personalized greeting and system info"
		echo -e "You can choose a style for the greeting and output using the options below."
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}welcome${RESET} [${BRIGHT_YELLOW}OPTIONS${RESET}]"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_YELLOW}-s, --style${RESET}    Choose the style of output (1 or 2)"
		echo -e "  ${BRIGHT_YELLOW}-h, --help${RESET}       Show this help message"
		echo -e "${BRIGHT_WHITE}Examples:${RESET}"
		echo -e "  ${BRIGHT_CYAN}welcome --style n${RESET}   # Run style n "
		return 0
	fi

	local style=1

	# Parse arguments for style option
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-s | --style)
			style="$2"
			shift
			;;
		*)
			echo "Invalid option: $1" >&2
			return 1
			;;
		esac
		shift
	done

	# Only run if in a login shell (SHLVL < 2)
	if [[ "${SHLVL}" -lt 2 ]]; then
		[[ -z "${TMUX}" || -n "$SSH_CLIENT" ]] && {
			clear
			printf '\e[3J'
		}

		# Style 1
		if [[ "$style" -eq 1 ]]; then
			welcome_greeting -b
			welcome_sysinfo -b
			display_fortune -b

		# Style 2
		elif [[ "$style" -eq 2 ]]; then
			welcome_greeting
			welcome_today -l
			display_fortune
			display_sparkbars

		# Style 3
		elif [[ "$style" -eq 3 ]]; then
			welcome_greeting
			welcome_sysinfo
			display_fortune
			display_sparkbars

		# Style 4
		elif [[ "$style" -eq 4 ]]; then
			welcome_sysinfo -f
			display_fortune -b
			display_sparkbars -b

		# Style 5
		elif [[ "$style" -eq 5 ]]; then
			welcome_sysinfo -n
			display_fortune -b
			display_sparkbars -b

		# Style 6
		elif [[ "$style" -eq 6 ]]; then
			welcome_sysinfo -f

		# Style 7
		elif [[ "$style" -eq 7 ]]; then
			welcome_sysinfo -n
			display_fortune -b

		# Style 8
		elif [[ "$style" -eq 8 ]]; then
			welcome_greeting -b
			display_fortune -b

		else
			echo "Invalid style option: $style" >&2
			return 1
		fi
	fi
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Set EDF Proxy
function proxy() {
	# Help message
	if [[ $# -eq 1 && ("$1" == "-h" || "$1" == "--help") ]]; then
		echo -e "${BRIGHT_WHITE}proxy:${RESET} Sets HTTP/HTTPS proxy environment variables and runs a test with curl."
		echo -e "This function sets the HTTP/HTTPS proxy environment variables and tests connectivity."
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}proxy${RESET} [${BRIGHT_YELLOW}OPTIONS${RESET}]"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_YELLOW}-v, --verbose${RESET}      Show detailed output from the curl request"
		echo -e "  ${BRIGHT_YELLOW}-h, --help${RESET}         Show this help message"
		echo -e "${BRIGHT_WHITE}Examples:${RESET}"
		echo -e "  ${BRIGHT_CYAN}proxy${RESET}          # Set default proxy settings"
		echo -e "  ${BRIGHT_CYAN}proxy --verbose${RESET}  # Show verbose output"
		return 0
	fi

	# Default values
	local proxy_url='http://vip-users.proxy.edf.fr:3131/'
	local no_proxy_value='localhost,127.0.0.1,.edf.fr,.edf.com'
	local verbose=false

	# Parse arguments
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-v | --verbose) verbose=true ;;
		*)
			echo "Invalid option: $1" >&2
			return 1
			;;
		esac
		shift
	done

	# Check if curl is installed
	if ! hascommand --strict curl; then
		echo "${BRIGHT_YELLOW}curl${RESET} is not installed. Please install curl to proceed."
		return 1
	fi

	# Set proxy environment variables
	export http_proxy="$proxy_url"
	export https_proxy="$proxy_url"
	export HTTP_PROXY="$proxy_url"
	export HTTPS_PROXY="$proxy_url"
	export no_proxy="$no_proxy_value"

	# Run curl with silent mode, negotiate proxy, and display the result
	if $verbose; then
		curl --verbose --proxy-negotiate --user : http://www.gstatic.com/generate_204
	else
		curl --silent --proxy-negotiate --user : http://www.gstatic.com/generate_204
	fi
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Unset EDF proxy
function unset_proxy() {
	# Help message
	if [[ $# -eq 1 && ("$1" == "-h" || "$1" == "--help") ]]; then
		echo -e "${BRIGHT_WHITE}unset_proxy:${RESET} Unsets HTTP/HTTPS proxy environment variables and removes proxy settings from git."
		echo -e "This function unsets the HTTP/HTTPS proxy environment variables and removes any proxy settings from Git."
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}unset_proxy${RESET} [${BRIGHT_YELLOW}OPTIONS${RESET}]"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_YELLOW}-v, --verbose${RESET}      Show detailed output of the unset process"
		echo -e "  ${BRIGHT_YELLOW}-h, --help${RESET}         Show this help message"
		echo -e "${BRIGHT_WHITE}Examples:${RESET}"
		echo -e "  ${BRIGHT_CYAN}unset_proxy${RESET}          # Unsets the proxy settings"
		echo -e "  ${BRIGHT_CYAN}unset_proxy --verbose${RESET}  # Show verbose output"
		return 0
	fi

	local verbose=false

	# Parse arguments
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-v | --verbose) verbose=true ;;
		*)
			echo "Invalid option: $1" >&2
			return 1
			;;
		esac
		shift
	done

	# Check if proxy environment variables are set
	if [[ -z "$http_proxy" && -z "$https_proxy" && -z "$HTTP_PROXY" && -z "$HTTPS_PROXY" && -z "$no_proxy" ]]; then
		echo "No proxy environment variables are set."
	fi

	# Unset proxy environment variables
	unset http_proxy
	unset https_proxy
	unset HTTP_PROXY
	unset HTTPS_PROXY
	unset no_proxy

	# Check if git is installed
	if hascommand --strict git; then
		# Remove proxy settings from git config (for global, local, and system levels)
		git config --global --unset-all https.proxy
		git config --global --unset-all http.proxy
		git config --global --unset-all http.https://github.com.proxy
		git config --global --unset-all http.https://codev-tuleap.cea.fr.proxy
		git config --global --unset-all http.https://codev-tuleap.cea.fr.proxy
		git config --system --unset-all https.proxy
		git config --system --unset-all http.proxy
		git config --local --unset-all https.proxy
		git config --local --unset-all http.proxy
		git config --global --unset-all core.gitProxy

		# Display git proxy settings (optional)
		if $verbose; then
			echo -e "Current git proxy settings after unsetting:"
			git config --global -l | grep proxy
			git config --local -l | grep proxy
			git config --system -l | grep proxy
		fi

		# Confirmation message
		echo "Proxy environment variables and Git proxy settings have been unset."
	else
		# Confirmation message
		echo "Proxy environment variables have been unset."
	fi
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# EDF Load Intel
function my_load_intel() {
	# Help message
	if [[ $# -eq 1 && ("$1" == "-h" || "$1" == "--help") ]]; then
		echo -e "${BRIGHT_WHITE}load_intel:${RESET} Loads Intel compilers and runtime libraries."
		echo -e "This function automatically checks for the presence of Intel compilers (ifort, icc) and loads the necessary modules."
		echo -e "If no local Intel installation is found, it attempts to load modules from predefined directories."
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}load_intel${RESET} [${BRIGHT_YELLOW}OPTIONS${RESET}]"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_YELLOW}-h, --help${RESET}      Show this help message"
		echo -e "${BRIGHT_WHITE}Examples:${RESET}"
		echo -e "  ${BRIGHT_CYAN}load_intel${RESET}              # Attempt to load Intel compilers"
		return 0
	fi

	# Check if Intel compilers are available locally
	if hascommand --strict ifort; then
		echo "Intel local installation is already loaded..."
		echo $(which ifort)
		echo $(which icc)

	# Try loading modules from the predefined directories
	elif [ -d /projets/europlexus ]; then
		echo "GAIA - Loading Intel compilers from /projets/europlexus..."
		module load ifort/2018.1.038 icc/2018.1.038 mkl/2018.1.038 impi/2018.1.038

	elif [ -d /software/restricted ]; then
		echo "CRONOS - Loading Intel compilers from /software/restricted..."
		module load intel/2023

	# Try using environment variable INTEL_INSTALL_DIR
	elif [ -n "$INTEL_INSTALL_DIR" ]; then
		echo "Loading Intel compilers from ${INTEL_INSTALL_DIR}..."
		module use --append $(find "$INTEL_INSTALL_DIR" -name modulefiles)
		module load icc mkl mpi

	# Check the default installation directory
	elif [ -d /opt/intel ]; then
		echo "Loading Intel compilers from /opt/intel..."
		module use --append $(find /opt/intel -name modulefiles)
		module load icc mkl mpi

	# No Intel installation found
	else
		echo "Intel compilation and runtime are not available."
		echo "Please use GNU."
		return 4
	fi
	return 0
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# TheFuck wrapper function
function fuck() {

	if ! hascommand --strict thefuck; then
		echo -e "${BRIGHT_RED}Error:${RESET} TheFuck (${BRIGHT_YELLOW}thefuck${RESET}) is not installed or not in the PATH."
		return 1
	fi

	# Help message
	if [[ $# -eq 1 && ("$1" == "-h" || "$1" == "--help") ]]; then
		echo -e "${BRIGHT_WHITE}fuck:${RESET} A wrapper around ${BRIGHT_CYAN}TheFuck${RESET} to fix the previous command."
		echo -e "This function allows you to use ${BRIGHT_CYAN}TheFuck${RESET} to correct the last command you typed."
		echo -e "It sets up environment variables like ${BRIGHT_YELLOW}TF_SHELL, TF_ALIAS, TF_HISTORY${RESET} before calling ${BRIGHT_CYAN}TheFuck${RESET}."
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}fuck${RESET} [${BRIGHT_YELLOW}OPTIONS${RESET}]"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_YELLOW}-h, --help${RESET}      Show this help message"
		echo -e "${BRIGHT_WHITE}Examples:${RESET}"
		echo -e "  ${BRIGHT_CYAN}fuck${RESET}              # Fix the last command using ${BRIGHT_CYAN}TheFuck${RESET}"
		return 0
	fi

	# Save original environment variables
	local TF_PYTHONIOENCODING=$PYTHONIOENCODING

	# Set necessary environment variables for TheFuck
	export TF_SHELL=bash
	export TF_ALIAS=fuck
	export TF_SHELL_ALIASES=$(alias)
	export TF_HISTORY=$(fc -ln -10)
	export PYTHONIOENCODING=utf-8

	# Run TheFuck and evaluate the command returned
	TF_CMD=$(thefuck THEFUCK_ARGUMENT_PLACEHOLDER "$@")

	# Check if TheFuck returned a valid command
	if [[ $? -ne 0 || -z "$TF_CMD" ]]; then
		echo -e "${BRIGHT_RED}Error: TheFuck did not return a valid command.${RESET}"
		unset TF_HISTORY
		export PYTHONIOENCODING=$TF_PYTHONIOENCODING
		return 1
	fi

	# Execute the suggested command
	eval "$TF_CMD"

	# Reset environment variables and update shell history
	unset TF_HISTORY
	export PYTHONIOENCODING=$TF_PYTHONIOENCODING
	history -s "$TF_CMD"

	# Optionally, output the suggested command for the user
	echo -e "${BRIGHT_GREEN}Executed:${RESET} $TF_CMD"
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# cd with immediate ll afterwards
function cdll() {
	# Help message
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then
		echo -e "${BRIGHT_WHITE}cdll:${RESET} Customizes the behavior of the builtin ${BRIGHT_CYAN}cd${RESET} command."
		echo -e "The function changes the current directory and always lists the contents of the new directory."
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}cdll${RESET} ${BRIGHT_YELLOW}[OPTIONS]${RESET}"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_YELLOW}-h, --help${RESET} Show this help message"
		echo -e "${BRIGHT_WHITE}Examples:${RESET}"
		echo -e "  ${BRIGHT_CYAN}cdll${RESET}    # Changes the directory and lists contents"
		return 0
	fi

	if hascommand --strict zoxide; then
		# Issues with zoxide and tmux
		if [ -z "${TMUX}" ]; then
			# Use zoxide when not in tmux
			cd() {
				z "$@" # Use zoxide for directory navigation
				ls     # List contents of the new directory
			}
		else
			# Use regular cd when in tmux
			cd() {
				builtin cd "$@" # Use default cd command
				ls              # List contents of the new directory
			}
		fi
	else
		# Use regular cd if zoxide is not available
		cd() {
			builtin cd "$@" # Use default cd command
			ls              # List contents of the new directory
		}
	fi
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Exit message
function _exit() {
	# Help message
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then
		echo -e "${BRIGHT_WHITE}_exit:${RESET} Function to show a custom exit message when the shell exits."
		echo -e "The function displays a farewell message and a sparkbar graphic."
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}_exit${RESET} ${BRIGHT_YELLOW}[OPTIONS]${RESET}"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_YELLOW}-h, --help${RESET} Show this help message"
		echo -e "  ${BRIGHT_YELLOW}-m, --message${RESET} Customize the farewell message"
		echo -e "  ${BRIGHT_YELLOW}-s, --no-sparkbar${RESET} Disable the sparkbar graphic"
		echo -e "${BRIGHT_WHITE}Examples:${RESET}"
		echo -e "  ${BRIGHT_CYAN}_exit${RESET}    # Displays the default exit message"
		echo -e "  ${BRIGHT_CYAN}_exit -m 'Goodbye!'${RESET}  # Custom farewell message"
		return 0
	fi

	local message="${BRIGHT_RED}So long Space Cowboy...${RESET}"
	# local message="${BRIGHT_RED}Hasta la vista, baby${RESET}"
	local show_sparkbar=true

	# Parse options for customizing the exit message
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-m | --message)
			message="$2"
			shift 2
			;;
		-s | --no-sparkbar)
			show_sparkbar=false
			shift
			;;
		*)
			echo "Invalid option: $1" >&2
			return 1
			;;
		esac
	done

	# Display message and sparkbar
	echo -e '\e[m'
	echo -e "$message"
	echo -e '\e[m'
	if $show_sparkbar; then
		echo -e "$BRIGHT_RED$(sparkbars)${RESET}"
		echo -e '\e[m'
	fi
}

# If not running in a nested shell, show the exit message
if [[ "${SHLVL}" -lt 2 ]]; then
	trap _exit EXIT
fi
#-------------------------------------------------------------

#-------------------------------------------------------------
# Sync with cronos to back up my data
function sync2ssh() {
	if ! hascommand --strict rsync; then
		echo -e "${BRIGHT_RED}Error:${RESET} ${BRIGHT_YELLOW}rsync${RESET} is not installed or not in the PATH."
		return 1
	fi

	# Show help if no arguments or first argument isn't push/pull
	if [ $# -eq 0 ] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then

		echo -e "${BRIGHT_WHITE}sync2ssh:${RESET} Synchronize files between local and remote systems using ${BRIGHT_CYAN}rsync${RESET}"
		echo -e "Uses ${BRIGHT_CYAN}rsync${RESET} for efficient file transfer with ${BRIGHT_YELLOW}progress tracking${RESET} and ${BRIGHT_YELLOW}resume capability${RESET}."
		echo -e "Supports both ${BRIGHT_YELLOW}password authentication${RESET} and ${BRIGHT_YELLOW}SSH key-based${RESET} connections."
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}sync2ssh${RESET} ${BRIGHT_YELLOW}[direction] [local_dir] [user@host[:port]] [remote_dir]${RESET} ${BRIGHT_WHITE}[options]${RESET}"
		echo -e "${BRIGHT_WHITE}Direction:${RESET}"
		echo -e "  ${BRIGHT_YELLOW}push${RESET}            Transfer files from local to remote system"
		echo -e "  ${BRIGHT_YELLOW}pull${RESET}            Transfer files from remote to local system"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_YELLOW}-z, --compress${RESET}  Enable compression during transfer"
		echo -e "  ${BRIGHT_YELLOW}-d, --delete${RESET}    Enable deletion of extraneous files on the destination"
		echo -e "  ${BRIGHT_YELLOW}-h, --help${RESET}      Show this help message"
		echo -e "${BRIGHT_WHITE}Features:${RESET}"
		echo -e "                          ${BRIGHT_CYAN}Archive mode${RESET}     (Preserves permissions, times, links)"
		echo -e "                          ${BRIGHT_CYAN}Verbose output${RESET}   (Shows detailed transfer information)"
		echo -e "                          ${BRIGHT_CYAN}Progress bar${RESET}     (Displays transfer progress)"
		echo -e "                          ${BRIGHT_CYAN}Auto-resume${RESET}      (Continues interrupted transfers)"
		echo -e "                          ${BRIGHT_CYAN}Delta-transfer${RESET}   (Only sends changed parts of files)"
		echo -e "${BRIGHT_WHITE}Examples:${RESET}"
		echo -e "  ${BRIGHT_CYAN}sync2ssh${RESET} ${BRIGHT_YELLOW}push ~/Documents/project/ \${USER}@server.fr \${HOME}/project/ -d${RESET}"
		echo -e "  ${BRIGHT_CYAN}sync2ssh${RESET} ${BRIGHT_YELLOW}pull ~/backup/ \${USER}@10.0.0.1:2222 /var/www/data/ -z${RESET}"
		echo -e "  ${BRIGHT_CYAN}sync2ssh${RESET} ${BRIGHT_YELLOW}push ~/local/ \${USER}@example.fr /remote/ --compress mypassword${RESET}"
		echo -e "  ${BRIGHT_CYAN}sync2ssh${RESET} ${BRIGHT_YELLOW}push ~/Documents/ \${USER}@server.fr \${HOME}/\${USER}/${RESET}"
		echo -e "  ${BRIGHT_CYAN}sync2ssh${RESET} ${BRIGHT_YELLOW}pull ~/Documents/file.txt \${USER}@server.fr \${HOME}/\${USER}/file.txt${RESET}"
		echo -e "  ${BRIGHT_CYAN}sync2ssh${RESET} ${BRIGHT_YELLOW}push ~/Documents/folder/ \${USER}@server.fr \${HOME}/\${USER}/folder/${RESET}"
		return 1
	fi

	# Validate direction argument
	if [[ "$1" != "push" && "$1" != "pull" ]]; then
		echo -e "${BRIGHT_RED}Error: ${BRIGHT_CYAN}First argument must be either 'push' or 'pull'${RESET}"
		echo -e "Usage: ${BRIGHT_CYAN}sync2ssh${RESET} ${BRIGHT_YELLOW}[direction] [local_dir] [user@host[:port]] [remote_dir]${RESET} ${BRIGHT_WHITE}[options]${RESET}"
		return 1
	fi

	# Check if all required arguments are provided
	if [[ $# -lt 4 ]]; then
		echo -e "${BRIGHT_RED}Error: ${BRIGHT_CYAN}Missing required arguments${RESET}"
		echo -e "Usage: ${BRIGHT_CYAN}sync2ssh${RESET} ${BRIGHT_YELLOW}[direction] [local_dir] [user@host[:port]] [remote_dir]${RESET} ${BRIGHT_WHITE}[options]${RESET}"
		return 1
	fi

	# Set direction and shift arguments
	DIRECTION="$1"
	shift

	# Parse remaining arguments
	if [[ -d "$1" ]]; then
		[[ "${1: -1}" != "/" ]] && LOCAL_DIR="${1}/" || LOCAL_DIR="$1"
	else
		LOCAL_DIR="$1"
	fi
	SSH_USER_HOST_PORT="$2"
	REMOTE_DIR="$3"
	shift 3

	# Extract optional flags and password
	COMPRESSION=""
	DELETE_FLAG=""
	SSH_PASS=""
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-z | --compress)
			COMPRESSION="--compress"
			shift
			;;
		-d | --delete)
			DELETE_FLAG="--delete"
			shift
			;;
		*)
			SSH_PASS="$1"
			shift
			;;
		esac
	done

	# Extract the port (if present)
	SSH_PORT=$(echo "$SSH_USER_HOST_PORT" | awk -F: '{print $NF}')
	if [[ "$SSH_PORT" == "$SSH_USER_HOST_PORT" ]]; then
		SSH_PORT=22 # default SSH port
		SSH_USER_HOST=$SSH_USER_HOST_PORT
	else
		SSH_USER_HOST=$(echo "$SSH_USER_HOST_PORT" | awk -F: '{print $1}')
	fi

	# Base rsync options (-a implies -rlptgoD, including --links)
	RSYNC_OPTIONS="-avP ${DELETE_FLAG} ${COMPRESSION}"
	SSH_OPTIONS="-e 'ssh -o ConnectTimeout=10 -p ${SSH_PORT}'"

	# Prepare source and destination based on direction
	if [[ "$DIRECTION" == "push" ]]; then
		SOURCE="${LOCAL_DIR}"
		DEST="${SSH_USER_HOST}:${REMOTE_DIR}"
	else
		SOURCE="${SSH_USER_HOST}:${REMOTE_DIR}"
		DEST="${LOCAL_DIR}"
	fi

	# Print the command with matching syntax highlighting
	echo -e "${BRIGHT_WHITE}Rsync Command:${RESET}"
	if [[ -n "$SSH_PASS" ]]; then
		echo -e "  ${BRIGHT_MAGENTA}sshpass${RESET} ${BRIGHT_BLUE}-p${RESET} ${BRIGHT_YELLOW}'${SSH_PASS}'${RESET} ${BRIGHT_MAGENTA}rsync${RESET} ${BRIGHT_BLUE}${RSYNC_OPTIONS}${RESET} ${BRIGHT_BLUE}${SSH_OPTIONS}${RESET} ${BRIGHT_YELLOW}\"${SOURCE}\"${RESET} ${BRIGHT_YELLOW}\"${DEST}\"${RESET}"
	else
		echo -e "  ${BRIGHT_MAGENTA}rsync${RESET} ${BRIGHT_BLUE}${RSYNC_OPTIONS}${RESET} ${BRIGHT_BLUE}${SSH_OPTIONS}${RESET} ${BRIGHT_YELLOW}\"${SOURCE}\"${RESET} ${BRIGHT_YELLOW}\"${DEST}\"${RESET}"
	fi
	echo

	# Construct and execute the rsync command
	if [[ -n "$SSH_PASS" ]]; then
		# Ensure sshpass is installed
		if ! hascommand --strict sshpass; then
			echo -e "${BRIGHT_RED}Error: ${BRIGHT_CYAN}Install sshpass or use SSH keys instead${RESET}"
			return 1
		fi
		RSYNC_COMMAND="sshpass -p '${SSH_PASS}' rsync ${RSYNC_OPTIONS} ${SSH_OPTIONS}"
	else
		RSYNC_COMMAND="rsync ${RSYNC_OPTIONS} ${SSH_OPTIONS}"
	fi

	# Execute the rsync command
	eval "${RSYNC_COMMAND}" "${SOURCE}" "${DEST}"

	# Check the result of the rsync command
	if [[ $? -ne 0 ]]; then
		echo -e "${BRIGHT_RED}Error:${RESET} rsync command ${BRIGHT_RED}failed${RESET} to synchronize files"
		return 1
	fi
	echo -e "${BRIGHT_GREEN}Files synchronized successfully${RESET}"
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Reduce pdf size with gs
function compresspdf() {
	if ! hascommand --strict gs; then
		echo -e "${BRIGHT_RED}Error:${RESET} Ghostscript (${BRIGHT_YELLOW}gs${RESET}) is not installed or not in the PATH."
		return 1
	fi

	if [ -z "$1" ]; then
		echo -e "${BRIGHT_WHITE}compress_pdf:${RESET} Compresses a PDF while preserving hyperlinks"
		echo -e "Uses ${BRIGHT_CYAN}Ghostscript${RESET} to optimize the file size with high-quality settings."
		echo -e "Hyperlinks are ${BRIGHT_YELLOW}preserved${RESET} by default."
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}compress_pdf${RESET} ${BRIGHT_YELLOW}[input.pdf]${RESET} ${BRIGHT_WHITE}[options]${RESET}"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_YELLOW}-o, --output${RESET}     Output PDF file (default: output.pdf)"
		echo -e "  ${BRIGHT_YELLOW}-c, --compat${RESET}     PDF compatibility level (default: 1.4)"
		echo -e "  ${BRIGHT_YELLOW}                        Possible values:${RESET}"
		echo -e "                          ${BRIGHT_CYAN}1.2${RESET}  (Acrobat 3.0, old format)"
		echo -e "                          ${BRIGHT_CYAN}1.3${RESET}  (Acrobat 4.0, no transparency)"
		echo -e "                          ${BRIGHT_CYAN}1.4${RESET}  (Acrobat 5.0, supports transparency)"
		echo -e "                          ${BRIGHT_CYAN}1.5${RESET}  (Acrobat 6.0, object streams)"
		echo -e "                          ${BRIGHT_CYAN}1.6${RESET}  (Acrobat 7.0, JBIG2 compression)"
		echo -e "                          ${BRIGHT_CYAN}1.7${RESET}  (Acrobat 8.0+, latest standard)"
		echo -e "  ${BRIGHT_YELLOW}-s, --settings${RESET}   Compression level (default: prepress)"
		echo -e "  ${BRIGHT_YELLOW}                        Possible values:${RESET}"
		echo -e "                          ${BRIGHT_CYAN}screen${RESET}    (Lowest quality, smallest file size)"
		echo -e "                          ${BRIGHT_CYAN}ebook${RESET}     (Medium quality, smaller file size)"
		echo -e "                          ${BRIGHT_CYAN}printer${RESET}   (High quality, larger file size)"
		echo -e "                          ${BRIGHT_CYAN}prepress${RESET}  (Best quality, preserves color accuracy)"
		echo -e "  ${BRIGHT_YELLOW}-h, --help${RESET}       Show this help message"
		echo -e "${BRIGHT_WHITE}Examples:${RESET}"
		echo -e "  ${BRIGHT_CYAN}compress_pdf${RESET} ${BRIGHT_YELLOW}input.pdf${RESET}"
		echo -e "  ${BRIGHT_CYAN}compress_pdf${RESET} ${BRIGHT_YELLOW}input.pdf -o compressed.pdf -s printer -c 1.5${RESET}"
		return 1
	fi

	local input_file="$1"
	shift # remove the first argument (input file)
	local output_file="output.pdf"
	local compatibility="1.4"
	local pdf_settings="prepress"

	while [[ $# -gt 0 ]]; do
		case "$1" in
		-o | --output)
			output_file="$2"
			shift 2
			;;
		-c | --compat)
			compatibility="$2"
			shift 2
			;;
		-s | --settings)
			pdf_settings="$2"
			shift 2
			;;
		-h | --help)
			compress_pdf
			return 0
			;;
		*)
			echo -e "${BRIGHT_RED}Error:${RESET} Unknown option: $1"
			return 1
			;;
		esac
	done

	# Ensure the correct formatting for pdf_settings
	pdf_settings="/$pdf_settings"

	# Print the full gs command with nice syntax highlighting
	echo -e "${BRIGHT_WHITE}Ghostscript Command:${RESET}"
	echo -e "  ${BRIGHT_MAGENTA}gs${RESET} ${BRIGHT_BLUE}-sDEVICE=${RESET}${BRIGHT_YELLOW}pdfwrite${RESET} ${BRIGHT_BLUE}-dCompatibilityLevel=${RESET}${BRIGHT_YELLOW}\"$compatibility\"${RESET} ${BRIGHT_BLUE}-dPDFSETTINGS=${RESET}${BRIGHT_YELLOW}\"$pdf_settings\"${RESET} ${BRIGHT_BLUE}-dNOPAUSE${RESET} ${BRIGHT_BLUE}-dQUIET${RESET} ${BRIGHT_BLUE}-dBATCH${RESET} ${BRIGHT_BLUE}-dPreserveAnnots=true${RESET} ${BRIGHT_BLUE}-sOutputFile=${RESET}${BRIGHT_YELLOW}\"$output_file\"${RESET} ${BRIGHT_YELLOW}\"$input_file\"${RESET}"

	# Compress the PDF using Ghostscript
	gs -sDEVICE=pdfwrite -dCompatibilityLevel="$compatibility" -dPDFSETTINGS="$pdf_settings" \
		-dNOPAUSE -dQUIET -dBATCH -dPreserveAnnots=true -sOutputFile="$output_file" "$input_file"

	# Check if gs command was successful
	if [ $? -ne 0 ]; then
		echo -e "${BRIGHT_RED}Error:${RESET} Ghostscript ${BRIGHT_RED}failed${RESET} to compress the PDF."
		return 1
	fi

	echo -e "${BRIGHT_GREEN}Compressed PDF saved as:${RESET} $output_file"
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Find directories name
function finddirs() {
	if [ -z "$1" ]; then
		echo -e "${BRIGHT_WHITE}finddir:${RESET} Searches for directories recursively"
		echo -e "You can search for directories using ${BRIGHT_YELLOW}substring matches${RESET}"
		echo -e "The function automatically selects the best available tool (${BRIGHT_CYAN}fdfind, fd, find, grep, or rg${RESET})"
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}finddir${RESET} ${BRIGHT_YELLOW}[directory_name]${RESET}"
		echo -e "${BRIGHT_WHITE}Examples:${RESET}"
		echo -e "  ${BRIGHT_CYAN}finddir${RESET} ${BRIGHT_YELLOW}'verif'${RESET}"
		echo -e "  ${BRIGHT_CYAN}finddir${RESET} ${BRIGHT_YELLOW}'build'${RESET}"
		return 1
	fi

	# Determine the best search tool
	if hascommand --strict fdfind; then
		FINDER=(fdfind --type d --color=always "$1")
	elif hascommand --strict fd; then
		FINDER=(fd --type d --color=always "$1")
	else
		FINDER=(find . -name "*$1*" -type d)
	fi

	# Determine the best highlighter
	if hascommand --strict rg; then
		HIGHLIGHTER=(rg --color=always --passthru "$1")
	else
		HIGHLIGHTER=(grep --color=auto "$1")
	fi

	# Run the selected tools
	"${FINDER[@]}" | "${HIGHLIGHTER[@]}"
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Find pattern recursively in glob-selected files
function findstr() {
	local -r LINE_LENGTH_CUTOFF=1000
	local SUDO_PREFIX=""
	local case_sensitive=0
	local hidden_files=1
	local pattern=""
	local search_text=""

	# Parse options
	while [[ "$1" == --* ]]; do
		case "$1" in
		-s | --sudo) SUDO_PREFIX="sudo " ;;
		-c | --case-sensitive) case_sensitive=1 ;;
		-n | --no-hidden) hidden_files=0 ;;
		*)
			echo -e "Unknown option: $1"
			return 1
			;;
		esac
		shift
	done

	pattern="$1"
	search_text="$2"

	if [ -z "$pattern" ] || [ -z "$search_text" ]; then
		echo -e "${BRIGHT_WHITE}findstr:${RESET} Searches for text in specified file types recursively"
		echo -e "You can use both ${BRIGHT_YELLOW}plain text${RESET} and ${BRIGHT_YELLOW}regular expressions${RESET} for searching"
		echo -e "To use elevated permissions include the ${BRIGHT_YELLOW}--sudo${RESET} option"
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}findstr${RESET} ${BRIGHT_YELLOW}[options] <file_pattern> <search_text>${RESET}"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_GREEN}-s, --sudo${RESET}          Run with elevated permissions"
		echo -e "  ${BRIGHT_GREEN}-c, --case-sensitive${RESET}  Perform case-sensitive search"
		echo -e "  ${BRIGHT_GREEN}-n, --no-hidden${RESET}      Ignore hidden files and directories"
		echo -e "${BRIGHT_WHITE}Examples:${RESET}"
		echo -e "  ${BRIGHT_CYAN}findstr${RESET} ${BRIGHT_YELLOW}'*.epx' 'PASF'${RESET}"
		echo -e "  ${BRIGHT_CYAN}findstr${RESET} ${BRIGHT_GREEN}--sudo${RESET} ${BRIGHT_YELLOW}'*.epx' 'todo'${RESET}"
		return 1
	fi

	if hascommand --strict rg; then
		echo -e "${BRIGHT_CYAN}Searching with ${BRIGHT_YELLOW}ripgrep (rg)${BRIGHT_CYAN}:${RESET}"
		local rg_options=("--no-ignore" "--hidden" "--pretty" "--glob" "$pattern" "$search_text" ".")
		[[ $case_sensitive -eq 1 ]] && rg_options[0]="--case-sensitive"
		[[ $hidden_files -eq 0 ]] && rg_options=("${rg_options[@]/--hidden/}")
		${SUDO_PREFIX}rg "${rg_options[@]}" | awk -v len=$LINE_LENGTH_CUTOFF '{ $0=substr($0, 1, len); print $0 }' || echo "No matches found."
	else
		echo -e "${BRIGHT_CYAN}Searching with ${BRIGHT_YELLOW}grep${BRIGHT_CYAN}:${RESET}"
		local grep_options=("-Inr" "--include=$pattern" "$search_text" ".")
		[[ $case_sensitive -eq 1 ]] && grep_options[0]="-Inr --binary-files=without-match"
		[[ $hidden_files -eq 0 ]] && grep_options=("--exclude-dir=.*" "${grep_options[@]}")
		${SUDO_PREFIX}grep "${grep_options[@]}" | awk -v len=$LINE_LENGTH_CUTOFF '{ $0=substr($0, 1, len); print $0 }' || echo "No matches found."
	fi
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Find multiple patterns recursively in glob-selected files
function findall() {
	local -r LINE_LENGTH_CUTOFF=1000
	local SUDO_PREFIX=""
	local case_sensitive=0
	local hidden_files=1
	local show_match=0
	local file_pattern=""
	local -a search_patterns=()

	# Parse options
	while [[ "$1" == --* ]]; do
		case "$1" in
		-s | --sudo) SUDO_PREFIX="sudo " ;;
		-c | --case-sensitive) case_sensitive=1 ;;
		-n | --no-hidden) hidden_files=0 ;;
		-m | --show-match) show_match=1 ;;
		*)
			echo -e "Unknown option: $1"
			return 1
			;;
		esac
		shift
	done

	# Get file pattern and search patterns
	file_pattern="$1"
	shift

	# Store all remaining arguments as search patterns
	while [ "$#" -gt 0 ]; do
		search_patterns+=("$1")
		shift
	done

	if [ -z "$file_pattern" ] || [ ${#search_patterns[@]} -eq 0 ]; then
		echo -e "${BRIGHT_WHITE}findall:${RESET} Searches for multiple patterns in specified file types recursively"
		echo -e "Files must contain ${BRIGHT_YELLOW}ALL${RESET} specified search patterns"
		echo -e "You can use both ${BRIGHT_YELLOW}plain text${RESET} and ${BRIGHT_YELLOW}regular expressions${RESET} for searching"
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}findall${RESET} ${BRIGHT_YELLOW}[options] <file_pattern> <pattern1> [pattern2] [pattern3...]${RESET}"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_GREEN}-s, --sudo${RESET}          Run with elevated permissions"
		echo -e "  ${BRIGHT_GREEN}-c, --case-sensitive${RESET}  Perform case-sensitive search"
		echo -e "  ${BRIGHT_GREEN}-n, --no-hidden${RESET}      Ignore hidden files and directories"
		echo -e "  ${BRIGHT_GREEN}-m, --show-match${RESET}      Show all pattern matches"
		echo -e "${BRIGHT_WHITE}Examples:${RESET}"
		echo -e "  ${BRIGHT_CYAN}findall${RESET} ${BRIGHT_YELLOW}'*.txt' 'error' 'critical' 'failed'${RESET}"
		echo -e "  ${BRIGHT_CYAN}findall${RESET} ${BRIGHT_GREEN}--sudo${RESET} ${BRIGHT_YELLOW}'*.log' 'WARNING' 'memory'${RESET}"
		return 1
	fi

	if hascommand --strict rg; then
		echo -e "${BRIGHT_CYAN}Searching with ${BRIGHT_YELLOW}ripgrep (rg)${BRIGHT_CYAN}:${RESET}"
		local temp_file
		temp_file=$(mktemp)

		# First find all matching files
		local rg_base_options=()
		[[ $case_sensitive -eq 1 ]] && rg_base_options+=("--case-sensitive")
		[[ $hidden_files -eq 1 ]] && rg_base_options+=("--hidden")

		${SUDO_PREFIX}rg "${rg_base_options[@]}" \
			--files \
			--glob "$file_pattern" \
			2>/dev/null | while read -r file; do
			# Check if file contains all patterns
			all_found=1
			for pattern in "${search_patterns[@]}"; do
				if ! ${SUDO_PREFIX}rg -q "${rg_base_options[@]}" "$pattern" "$file" 2>/dev/null; then
					all_found=0
					break
				fi
			done
			# If all patterns found, save the file
			if [ $all_found -eq 1 ]; then
				echo "$file" >>"$temp_file"
			fi
		done

		# Display results for matching files
		if [ -s "$temp_file" ]; then
			while IFS= read -r file; do
				if [[ $show_match -eq 0 ]]; then
					echo -e "${MAGENTA}$file${RESET}"
				elif [[ $show_match -eq 1 ]]; then
					echo -e "${BRIGHT_WHITE}File: $file${RESET}"
					for pattern in "${search_patterns[@]}"; do
						echo -e "${BRIGHT_YELLOW}Pattern: $pattern${RESET}"
						${SUDO_PREFIX}rg "${rg_base_options[@]}" --pretty "$pattern" "$file" 2>/dev/null |
							awk -v len=$LINE_LENGTH_CUTOFF '{ $0=substr($0, 1, len); print $0 }'
						echo
					done
				fi
			done <"$temp_file"
		else
			echo "No files found containing all patterns."
		fi

		rm -f "$temp_file"
	else
		echo -e "${BRIGHT_CYAN}Searching with ${BRIGHT_YELLOW}grep${BRIGHT_CYAN}:${RESET}"
		local temp_file
		temp_file=$(mktemp)

		# Find all matching files first
		if hascommand --strict fdfind; then
			FIND_CMD="${SUDO_PREFIX}fdfind -t f -g \"$file_pattern\""
		elif hascommand --strict fd; then
			FIND_CMD="${SUDO_PREFIX}fd -t f -g \"$file_pattern\""
		else
			FIND_CMD="${SUDO_PREFIX}find . -type f -name \"$file_pattern\""
		fi
		eval "$FIND_CMD" 2>/dev/null | while read -r file; do

			# Check if file contains all patterns
			all_found=1
			for pattern in "${search_patterns[@]}"; do
				if ! ${SUDO_PREFIX}grep -q ${case_sensitive:+-i} "$pattern" "$file" 2>/dev/null; then
					all_found=0
					break
				fi
			done
			# If all patterns found, save the file
			if [ $all_found -eq 1 ]; then
				echo "$file" >>"$temp_file"
			fi
		done

		# Display results for matching files
		if [ -s "$temp_file" ]; then
			while IFS= read -r file; do
				if [[ $show_match -eq 0 ]]; then
					echo -e "${MAGENTA}$file${RESET}"
				elif [[ $show_match -eq 1 ]]; then
					echo -e "${BRIGHT_WHITE}File: $file${RESET}"
					for pattern in "${search_patterns[@]}"; do
						echo -e "${BRIGHT_YELLOW}Pattern: $pattern${RESET}"
						${SUDO_PREFIX}grep ${case_sensitive:+-i} --color=always -n "$pattern" "$file" 2>/dev/null |
							awk -v len=$LINE_LENGTH_CUTOFF '{ $0=substr($0, 1, len); print $0 }'
						echo
					done
				fi
			done <"$temp_file"
		else
			echo "No files found containing all patterns."
		fi

		rm -f "$temp_file"
	fi
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Overrides existing tm function in bashrc to prevent exiting
# ssh when leaving tmux
function tm() {

	# Get the passed in or default session name
	if [[ -n "${@}" ]]; then
		local SESSION_NAME="${@}"
	elif [[ -n "${_TMUX_LOAD_SESSION_NAME}" ]]; then
		local SESSION_NAME="${_TMUX_LOAD_SESSION_NAME}"
	elif [[ "$(tmux list-sessions 2>/dev/null | wc -l)" -gt 0 ]]; then
		local SESSION_NAME="$(tmux ls -F "#{session_name}" | createmenu)"
	else
		local SESSION_NAME="$(whoami)"
	fi

	# Create the session if it doesn't exist
	TMUX='' tmux -u new-session -d -s "${SESSION_NAME}" 2>/dev/null

	# Attach if outside of TMUX
	if [[ -z "$TMUX" ]]; then
		tmux -u attach -t "${SESSION_NAME}" 2>/dev/null

	# Switch if we are already inside of TMUX
	else
		tmux -u switch-client -t "${SESSION_NAME}" 2>/dev/null
	fi
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Git checkout based on date/time
function ggcd() {
	# Show help if no argument or -h/--help is provided
	if [ -z "$1" ] || [[ "$1" == "-h" || "$1" == "--help" ]]; then
		echo -e "${BRIGHT_WHITE}ggcd:${RESET} Checks out a commit based on the provided date."
		echo -e "This function allows you to find the latest commit before a specific date and checkout that commit."
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}ggcd${RESET} ${BRIGHT_YELLOW}[YYYY-MM-DD or 'YYYY-MM-DD HH:MM:SS']${RESET}      # Checkout latest commit before a date"
		echo -e "  ${BRIGHT_CYAN}ggcd${RESET} ${BRIGHT_YELLOW}-r [start-date] [end-date]${RESET}                 # Show commits in the range"
		echo -e "  ${BRIGHT_CYAN}ggcd${RESET} ${BRIGHT_YELLOW}-n N [date]${RESET}                               # Show the N last commits before the given date"
		echo -e "  ${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_YELLOW}-b, --branch${RESET}   Specify a branch to search the commit on."
		echo -e "  ${BRIGHT_YELLOW}-r, --range${RESET}     Show commits within the date range (doesn't checkout)."
		echo -e "  ${BRIGHT_YELLOW}-n, --number${RESET}    Show the N last commits before the given date."
		return 0
	fi

	# Initialize variables
	local branch=""
	local range=false
	local number=false
	local num_commits=""
	local start_date=""
	local end_date=""
	local args=("$@") # Store all arguments in an array
	local i=0
	local arg_count=${#args[@]}

	# Parse options with a standard index-based approach instead of shift
	while [ $i -lt $arg_count ]; do
		case "${args[$i]}" in
		-b | --branch)
			if [ $((i + 1)) -lt $arg_count ]; then
				branch="${args[$((i + 1))]}"
				i=$((i + 2))
			else
				echo -e "${BRIGHT_RED}Error:${RESET} Branch option requires a value."
				return 1
			fi
			;;
		-r | --range)
			range=true
			if [ $((i + 2)) -lt $arg_count ]; then
				start_date="${args[$((i + 1))]}"
				end_date="${args[$((i + 2))]}"
				i=$((i + 3))
			else
				echo -e "${BRIGHT_RED}Error:${RESET} Range option requires start and end dates."
				return 1
			fi
			;;
		-n | --number)
			number=true
			if [ $((i + 1)) -lt $arg_count ]; then
				num_commits="${args[$((i + 1))]}"
				i=$((i + 2))
			else
				echo -e "${BRIGHT_RED}Error:${RESET} Number option requires a value."
				return 1
			fi
			;;
		*)
			if [ -z "$start_date" ]; then
				start_date="${args[$i]}"
			fi
			i=$((i + 1))
			;;
		esac
	done

	# If more than one argument is provided without -r, throw an error
	if [ "$#" -ge 2 ] && ! $range && ! $number; then
		echo -e "${BRIGHT_RED}Error:${RESET} Too many arguments."
		return 1
	fi

	# If no date or option, show help
	if [ -z "$start_date" ] && [ -z "$num_commits" ]; then
		echo -e "${BRIGHT_RED}Error:${RESET} Date is required."
		return 1
	fi

	# Get the current branch name if no branch specified
	if [ -z "$branch" ]; then
		# Use process substitution instead of command substitution
		if ! branch=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null); then
			branch="main" # fallback to main if no default branch is set
		else
			branch=${branch#origin/}
		fi
	fi

	# Show commits within a date range without checking out
	if $range; then
		echo -e "${BRIGHT_WHITE}Commits in the date range:${RESET}"
		git log --color --oneline --after="$start_date" --before="$end_date" --date=format-local:'%d/%m/%Y %Hh%Mm%Ss' --pretty=format:"%C(magenta)%h%C(reset) - %C(green)(%ad)%C(reset) %s%C(auto)%d%C(reset) %C(bold brightblue)<%an>%C(reset)" "origin/$branch"
		return 0
	fi

	# Show the last N commits before the given date
	if $number; then
		echo -e "${BRIGHT_WHITE}Last $num_commits commits before $start_date:${RESET}"
		git log --color --oneline -n "$num_commits" --before="$start_date" --date=format-local:'%d/%m/%Y %Hh%Mm%Ss' --pretty=format:"%C(magenta)%h%C(reset) - %C(green)(%ad)%C(reset) %s%C(auto)%d%C(reset) %C(bold brightblue)<%an>%C(reset)" "origin/$branch"
		return 0
	fi

	# Get the commit hash for the given date
	local commit_hash=""
	commit_hash=$(git rev-list -n 1 --before="$start_date" "origin/$branch")
	if [ -z "$commit_hash" ]; then
		echo -e "${BRIGHT_RED}Error:${RESET} No commit found for the given date."
		return 1
	fi

	# Show commit info using git log for consistency
	echo -e "${BRIGHT_WHITE}Commit Info:${RESET}"
	git log --color --oneline -n 1 "$commit_hash" --date=format-local:'%d/%m/%Y %Hh%Mm%Ss' --pretty=format:"%C(magenta)%h%C(reset) - %C(green)(%ad)%C(reset) %s%C(auto)%d%C(reset) %C(bold brightblue)<%an>%C(reset)"

	# Check for uncommitted changes before attempting checkout
	if ! git diff-index --quiet HEAD --; then
		echo -e "${BRIGHT_RED}Error:${RESET} You have uncommitted changes in your working directory."
		echo -e "Please commit or stash your changes before checking out a different commit."
		echo -e "You can use:"
		echo -e "  ${BRIGHT_CYAN}git stash${RESET} to temporarily save your changes"
		echo -e "  ${BRIGHT_CYAN}git commit -m \"your message\"${RESET} to commit your changes"
		return 1
	fi

	# Try to checkout the commit
	local checkout_output=""
	checkout_output=$(git checkout "$commit_hash" 2>&1)
	local checkout_status=$?

	# Handle checkout errors
	if [ $checkout_status -ne 0 ]; then
		echo -e "${BRIGHT_RED}Error:${RESET} Failed to checkout the commit."

		# Check for specific error conditions in the output
		if echo "$checkout_output" | grep -q "Your local changes to the following files would be overwritten"; then
			echo -e "Your local changes would be overwritten by checkout."
			echo -e "Please commit or stash your changes before proceeding."
			echo -e "You can use:"
			echo -e "  ${BRIGHT_CYAN}git stash${RESET} to temporarily save your changes"
			echo -e "  ${BRIGHT_CYAN}git commit -m \"your message\"${RESET} to commit your changes"
		elif echo "$checkout_output" | grep -q "conflict"; then
			echo -e "There are conflicts preventing the checkout."
			echo -e "Please resolve any conflicts and try again."
			echo -e "You might want to:"
			echo -e "  1. ${BRIGHT_CYAN}git status${RESET} to see the conflicting files"
			echo -e "  2. Resolve the conflicts in your editor"
			echo -e "  3. ${BRIGHT_CYAN}git add <files>${RESET} to mark conflicts as resolved"
		else
			# Show the actual git error message for unexpected issues
			echo -e "Git error message: $checkout_output"
		fi
		return 1
	fi

	echo -e "${BRIGHT_GREEN}Checked out commit:${RESET} $commit_hash"
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Replace a string by another in globbed files
function replacestr() {

	# Initialize variables
	local SUDO_PREFIX=""
	local case_sensitive=0
	local hidden_files=1
	local backup=0
	local pattern=""
	local old_text=""
	local new_text=""
	local total_replacements=0
	local total_files=0
	local files_processed=0
	local finder_cmd=""
	local preview=0

	# Determine available commands upfront
	if hascommand --strict fd; then
		finder_cmd="fd"
	elif hascommand --strict fdfind; then
		finder_cmd="fdfind"
	else
		finder_cmd="find"
	fi

	# Help function
	show_help() {
		echo -e "${BRIGHT_WHITE}replacestr:${RESET} Replaces text in specified file types recursively"
		echo -e "You can use both ${BRIGHT_YELLOW}plain text${RESET} and ${BRIGHT_YELLOW}regular expressions${RESET} for search and replace"
		echo -e "To use elevated permissions include the ${BRIGHT_YELLOW}--sudo${RESET} option"
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}replacestr${RESET} ${BRIGHT_YELLOW}[options] <file_pattern> <old_text> <new_text>${RESET}"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_GREEN}-s, --sudo${RESET}          Run with elevated permissions"
		echo -e "  ${BRIGHT_GREEN}-c, --case-sensitive${RESET}  Perform case-sensitive search"
		echo -e "  ${BRIGHT_GREEN}-n, --no-hidden${RESET}      Ignore hidden files and directories"
		echo -e "  ${BRIGHT_GREEN}-b, --backup${RESET}         Create backup files (.bak)"
		echo -e "  ${BRIGHT_GREEN}-p, --preview${RESET}         Show lines matching old_text before replacement"
		echo -e "  ${BRIGHT_GREEN}-h, --help${RESET}           Show this help message"
		echo -e "${BRIGHT_WHITE}Examples:${RESET}"
		echo -e "  ${BRIGHT_CYAN}replacestr${RESET} ${BRIGHT_YELLOW}'*.lua' 'oldFunction' 'newFunction'${RESET}"
		echo -e "  ${BRIGHT_CYAN}replacestr${RESET} ${BRIGHT_GREEN}-s${RESET} ${BRIGHT_YELLOW}'*.conf' 'port=8080' 'port=9090'${RESET}"
		echo -e "  ${BRIGHT_CYAN}replacestr${RESET} ${BRIGHT_GREEN}-p${RESET} ${BRIGHT_YELLOW}'*.txt' 'oldText' 'newText'${RESET}"
		return 1
	}

	# Show help if no arguments or help option
	if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		show_help
		return
	fi

	# Parse options
	while [[ "$1" == -* ]]; do
		case "$1" in
		--sudo | -s) SUDO_PREFIX="sudo " ;;
		--case-sensitive | -c) case_sensitive=1 ;;
		--no-hidden | -n) hidden_files=0 ;;
		--backup | -b) backup=1 ;;
		--preview | -p) preview=1 ;;
		--help | -h)
			show_help
			return
			;;
		*)
			echo -e "${BRIGHT_RED}Error:${RESET} Unknown option: $1"
			return 1
			;;
		esac
		shift
	done

	# Determine available commands upfront
	if hascommand --strict rg; then
		grep_cmd="rg --count-matches"
		[[ $case_sensitive -eq 0 ]] && grep_cmd="rg -i --count-matches"
	else
		grep_cmd="grep -c"
		[[ $case_sensitive -eq 0 ]] && grep_cmd="grep -ci"
	fi

	# Determine the sed command based on OS
	sed_cmd="sed -i"
	[ "$(uname)" == "Darwin" ] && sed_cmd="sed -i ''"

	# Validate and assign required parameters
	pattern="$1"
	old_text="$2"
	new_text="$3"

	if [ -z "$pattern" ] || [ -z "$old_text" ] || [ -z "$new_text" ]; then
		show_help
		return 1
	fi

	if [ $preview -eq 1 ]; then
		local options=""
		if [ $case_sensitive -eq 1 ]; then
			options="--case-sensitive"
		fi
		if [ $hidden_files -eq 0 ]; then
			options="$options --no-hidden"
		fi
		if [ -n "$SUDO_PREFIX" ]; then
			options="$options --sudo"
		fi
		echo -e "${BRIGHT_CYAN}Showing lines matching \"${BRIGHT_YELLOW}$old_text${BRIGHT_CYAN}\" in files matching pattern \"${BRIGHT_YELLOW}$pattern${BRIGHT_CYAN}\":${RESET}"
		findstr $options "$pattern" "$old_text"
		echo -e "${BRIGHT_CYAN}Remove the \"${BRIGHT_YELLOW}-p${BRIGHT_CYAN}\" or \"${BRIGHT_YELLOW}--preview${BRIGHT_CYAN}\" option to perform the replacement(s).${RESET}"
		return 0
	fi

	# Find files based on the determined command
	local files_array=()
	echo -e "${BRIGHT_CYAN}Finding files with ${BRIGHT_YELLOW}$finder_cmd${BRIGHT_CYAN}:${RESET}"

	if [ "$finder_cmd" = "fd" ] || [ "$finder_cmd" = "fdfind" ]; then
		local fd_options=("--type" "f" "--glob" "$pattern")
		[[ $hidden_files -eq 1 ]] && fd_options=("--hidden" "--no-ignore" "${fd_options[@]}")

		while IFS= read -r file; do
			[ -n "$file" ] && files_array+=("$file")
		done < <(${SUDO_PREFIX}$finder_cmd "${fd_options[@]}" 2>/dev/null)
	else
		local find_cmd="find . -type f -name \"$pattern\""
		[[ $hidden_files -eq 0 ]] && find_cmd="$find_cmd -not -path \"*/\\.*\""

		while IFS= read -r -d '' file; do
			files_array+=("$file")
		done < <(${SUDO_PREFIX}$finder_cmd "${fd_options[@]}" -print0 2>/dev/null)

	fi

	local file_count=${#files_array[@]}

	if [ $file_count -eq 0 ]; then
		echo -e "${BRIGHT_YELLOW}No files matching pattern found.${RESET}"
		return 0
	fi

	echo -e "${BRIGHT_CYAN}Replacing ${BRIGHT_YELLOW}\"$old_text\"${BRIGHT_CYAN} with ${BRIGHT_YELLOW}\"$new_text\"${BRIGHT_CYAN} in ${BRIGHT_YELLOW}${file_count}${RESET} ${BRIGHT_CYAN}matching files:${RESET}"

	# Prepare sed options
	local sed_options="s/$old_text/$new_text/g"
	[[ $case_sensitive -eq 0 ]] && sed_options="s/$old_text/$new_text/gi" # If case-sensitive is not set, make it case-insensitive

	# Process each file without pipe to allow variable updating
	for ((i = 0; i < file_count; i++)); do
		local file="${files_array[$i]}"
		if [ ! -f "$file" ]; then
			continue
		fi

		files_processed=$((files_processed + 1))

		# Improved progress bar with hidden cursor
		if [ $file_count -gt 0 ]; then
			local percent=$((files_processed * 100 / file_count))
			local bar_size=50
			local filled_size=$((percent * bar_size / 100))

			# Build progress bar in a single printf to prevent flickering
			printf "\r${BRIGHT_WHITE}Progress: [${BRIGHT_GREEN}%-${bar_size}s${BRIGHT_WHITE}] %3d%%${RESET}" "$(printf '%0.s#' $(seq 1 $filled_size))" "$percent"
		fi

		# Count occurrences before replacement using rg if available, otherwise grep
		local count=0
		if [ -n "$grep_cmd" ]; then
			count=$(${SUDO_PREFIX}$grep_cmd "$old_text" "$file" 2>/dev/null || echo 0)
		fi

		# Only process files with matches
		if [ "$count" -gt 0 ]; then
			# Create backup only for files that will be modified and if backup option is enabled
			if [ $backup -eq 1 ]; then
				${SUDO_PREFIX}cp "$file" "$file.bak"
			fi

			# Perform replacement
			${SUDO_PREFIX}$sed_cmd "$sed_options" "$file"

			total_replacements=$((total_replacements + count))
			total_files=$((total_files + 1))

			# Clear progress line and show file info
			printf "\r%-80s\r" "" # Clear the line
			echo -e "Processing: ${BRIGHT_YELLOW}$file${RESET}"
			echo -e "  ${BRIGHT_GREEN}Replacements: $count${RESET}"
		fi
	done

	# Clear progress line
	printf "\r%-80s\r" ""

	# Print summary with the original format
	if [ "$total_replacements" -gt 0 ]; then
		echo -e "${BRIGHT_CYAN}${total_replacements} replacement(s) done in ${total_files} file(s).${RESET}"
	else
		echo -e "${BRIGHT_CYAN}No replacements made.${RESET}"
	fi
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Various actions on PNG files : crop, transparent ...
function pngfix() {
	local pattern="*.png"
	local trim=0
	local transparent=0
	local fuzz="5%"
	local backup=0
	local recursive=0
	local finder_cmd=""

	if ! hascommand --strict convert; then
		echo -e "${BRIGHT_RED}Error:${RESET} ImageMagick (${BRIGHT_YELLOW}convert${RESET}) is not installed or not in the PATH."
		return 1
	fi

	# Determine best finder command
	if hascommand --strict fd; then
		finder_cmd="fd"
	elif hascommand --strict fdfind; then
		finder_cmd="fdfind"
	else
		finder_cmd="find"
	fi

	# Help function
	show_help() {
		echo -e "${BRIGHT_WHITE}pngfix:${RESET} Batch process PNG images with ImageMagick"
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}pngfix${RESET} ${BRIGHT_YELLOW}[options]${RESET}"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_GREEN}-t, --trim${RESET}            Trim images"
		echo -e "  ${BRIGHT_GREEN}-x, --transparent${RESET}      Make white pixels transparent"
		echo -e "  ${BRIGHT_GREEN}-f, --fuzz <value>${RESET}    Set fuzz percentage for transparency (default: 5%)"
		echo -e "  ${BRIGHT_GREEN}-p, --pattern <glob>${RESET}  File pattern (default: *.png)"
		echo -e "  ${BRIGHT_GREEN}-b, --backup${RESET}          Create backup (.bak) before modification"
		echo -e "  ${BRIGHT_GREEN}-r, --recursive${RESET}       Process files recursively"
		echo -e "  ${BRIGHT_GREEN}-h, --help${RESET}            Show this help message"
		return 1
	}

	# Show help if no arguments
	if [ $# -eq 0 ]; then
		show_help
		return
	fi

	# Parse options
	while [[ "$1" == -* ]]; do
		case "$1" in
		--trim | -t) trim=1 ;;
		--transparent | -x) transparent=1 ;;
		--fuzz | -f)
			fuzz="$2"
			shift
			;;
		--pattern | -p)
			pattern="$2"
			shift
			;;
		--backup | -b) backup=1 ;;
		--recursive | -r) recursive=1 ;;
		--help | -h)
			show_help
			return
			;;
		*)
			echo -e "${BRIGHT_RED}Error:${RESET} Unknown option: $1"
			return 1
			;;
		esac
		shift
	done

	if [ $trim -eq 0 ] && [ $transparent -eq 0 ]; then
		echo -e "${BRIGHT_RED}Error:${RESET} At least one of --trim or --transparent must be specified."
		return 1
	fi

	# Find files
	local files_array=()
	echo -e "${BRIGHT_CYAN}Finding files with ${BRIGHT_YELLOW}$finder_cmd${BRIGHT_CYAN}:${RESET}"

	if [ "$finder_cmd" = "fd" ] || [ "$finder_cmd" = "fdfind" ]; then
		local fd_options=("--type" "f" "--glob" "$pattern")
		[[ $recursive -eq 1 ]] || fd_options+=("--max-depth" "1")
		while IFS= read -r file; do
			files_array+=("$file")
		done < <($finder_cmd "${fd_options[@]}" 2>/dev/null)
	else
		local find_cmd="find . -type f -name '$pattern'"
		[[ $recursive -eq 0 ]] && find_cmd="$find_cmd -maxdepth 1"
		while IFS= read -r file; do
			files_array+=("$file")
		done < <(eval "$find_cmd" 2>/dev/null)
	fi

	local file_count=${#files_array[@]}
	if [ $file_count -eq 0 ]; then
		echo -e "${BRIGHT_YELLOW}No matching files found.${RESET}"
		return 0
	fi

	echo -e "${BRIGHT_CYAN}Processing ${BRIGHT_YELLOW}$file_count${BRIGHT_CYAN} file(s)...${RESET}"
	for file in "${files_array[@]}"; do
		echo -e "Processing: ${BRIGHT_YELLOW}$file${RESET}"
		[ $backup -eq 1 ] && cp "$file" "$file.bak"

		if [ $trim -eq 1 ]; then
			convert "$file" -trim "$file"
		fi

		if [ $transparent -eq 1 ]; then
			output_file="${file/.png/""}.png"
			convert "$file" -fuzz "$fuzz" -transparent white "$output_file"
		fi
	done

	echo -e "${BRIGHT_CYAN}Processing completed.${RESET}"
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Automatic latex reindentation
function texindent {
	local pattern="*.tex"
	local backup=0
	local recursive=0
	local finder_cmd=""

	if ! hascommand --strict latexindent; then
		echo -e "${BRIGHT_RED}Error:${RESET} ${BRIGHT_YELLOW}latexindent${RESET} is not installed or not in the PATH."
		return 1
	fi

	# Determine best finder command
	if hascommand --strict fd; then
		finder_cmd="fd"
	elif hascommand --strict fdfind; then
		finder_cmd="fdfind"
	else
		finder_cmd="find"
	fi

	# Help function
	show_help() {
		echo -e "${BRIGHT_WHITE}texindent:${RESET} Batch indent LaTeX files using ${BRIGHT_CYAN}latexindent${RESET}"
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}texindent${RESET} ${BRIGHT_YELLOW}[options]${RESET}"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_GREEN}-p, --pattern <glob>${RESET}  File pattern (default: *.tex)"
		echo -e "  ${BRIGHT_GREEN}-b, --backup${RESET}          Create backup (.bak) before modification"
		echo -e "  ${BRIGHT_GREEN}-r, --recursive${RESET}       Process files recursively"
		echo -e "  ${BRIGHT_GREEN}-h, --help${RESET}            Show this help message"
		return 1
	}

	# Show help if no arguments
	if [ $# -eq 0 ]; then
		show_help
		return
	fi

	# Parse options
	while [[ "$1" == -* ]]; do
		case "$1" in
		--pattern | -p)
			pattern="$2"
			shift
			;;
		--backup | -b) backup=1 ;;
		--recursive | -r) recursive=1 ;;
		--help | -h)
			show_help
			return
			;;
		*)
			echo -e "${BRIGHT_RED}Error:${RESET} Unknown option: $1"
			return 1
			;;
		esac
		shift
	done

	# Find files
	local files_array=()
	echo -e "${BRIGHT_CYAN}Finding files with ${BRIGHT_YELLOW}$finder_cmd${BRIGHT_CYAN}:${RESET}"

	if [ "$finder_cmd" = "fd" ] || [ "$finder_cmd" = "fdfind" ]; then
		local fd_options=("--type" "f" "--glob" "$pattern")
		[[ $recursive -eq 1 ]] || fd_options+=("--max-depth" "1")
		while IFS= read -r file; do
			files_array+=("$file")
		done < <($finder_cmd "${fd_options[@]}" 2>/dev/null)
	else
		local find_cmd="find . -type f -name '$pattern'"
		[[ $recursive -eq 0 ]] && find_cmd="$find_cmd -maxdepth 1"
		while IFS= read -r file; do
			files_array+=("$file")
		done < <(eval "$find_cmd" 2>/dev/null)
	fi

	local file_count=${#files_array[@]}
	if [ $file_count -eq 0 ]; then
		echo -e "${BRIGHT_YELLOW}No matching files found.${RESET}"
		return 0
	fi

	echo -e "${BRIGHT_CYAN}Processing ${BRIGHT_YELLOW}$file_count${BRIGHT_CYAN} file(s)...${RESET}"
	for file in "${files_array[@]}"; do
		echo -e "Processing: ${BRIGHT_YELLOW}$file${RESET}"
		[ $backup -eq 1 ] && cp "$file" "$file.bak"
		latexindent -w -s "$file"
	done

	echo -e "${BRIGHT_CYAN}Processing completed.${RESET}"
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Convert a gif to PNG files usable in a .tex file
function gif2tex() {

	# Initialize variables
	local output_dir=""
	local gif_file=""
	local frame_count=0
	local first_frame=0
	local last_frame=0

	if ! hascommand --strict convert; then
		echo -e "${BRIGHT_RED}Error:${RESET} ImageMagick (${BRIGHT_YELLOW}convert${RESET}) is not installed or not in the PATH."
		return 1
	fi

	# Help function
	show_help() {
		echo -e "${BRIGHT_WHITE}gif2tex:${RESET} Extracts frames from a GIF into PNG images"
		echo -e "Uses ImageMagick's convert command to extract and save frames."
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}gif2tex${RESET} ${BRIGHT_YELLOW}<gif_file>${RESET}"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_GREEN}-o, --output <dir>${RESET}   Specify output directory (default: same as GIF name)"
		echo -e "  ${BRIGHT_GREEN}-h, --help${RESET}           Show this help message"
		echo -e "${BRIGHT_WHITE}Example:${RESET}"
		echo -e "  ${BRIGHT_CYAN}gif2tex${RESET} ${BRIGHT_YELLOW}animation.gif${RESET}"
		return 1
	}

	# Show help if no arguments or help option
	if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		show_help
		return
	fi

	# Parse options
	while [[ "$1" == -* ]]; do
		case "$1" in
		--output | -o)
			shift
			output_dir="$1"
			;;
		*)
			echo -e "${BRIGHT_RED}Error:${RESET} Unknown option: $1"
			return 1
			;;
		esac
		shift
	done

	# Validate and assign required parameter
	gif_file="$1"
	if [ -z "$gif_file" ]; then
		echo -e "${BRIGHT_RED}Error:${RESET} No GIF file specified."
		show_help
		return 1
	fi

	# Check if file exists
	if [ ! -f "$gif_file" ]; then
		echo -e "${BRIGHT_RED}Error:${RESET} File '$gif_file' not found."
		return 1
	fi

	# Determine output directory name if not specified
	if [ -z "$output_dir" ]; then
		output_dir="${gif_file%.*}"
	fi

	# Create output directory if it doesn't exist
	mkdir -p "$output_dir"

	echo -e "${BRIGHT_CYAN}Extracting frames to '${BRIGHT_YELLOW}$output_dir${BRIGHT_CYAN}'...${RESET}"

	# Extract frames using ImageMagick convert
	convert -coalesce "$gif_file" "$output_dir/${gif_file%.*}.png"

	# Count the number of frames extracted
	frame_count=$(ls "$output_dir" | grep -E "${gif_file%.*}-[0-9]+\.png" | wc -l)
	if [ "$frame_count" -eq 0 ]; then
		echo -e "${BRIGHT_RED}Error:${RESET} No frames extracted. Check if ImageMagick is installed."
		return 1
	fi

	# Determine first and last frame index
	first_frame=0
	last_frame=$((frame_count - 1))

	# Display summary
	fps=$(identify -format "%T\n" "$gif_file" | awk '{sum += 100/$1; count++} END {if (count > 0) print int(sum/count); else print 25}')
	echo -e "${BRIGHT_CYAN}Extraction complete: ${BRIGHT_YELLOW}$frame_count${BRIGHT_CYAN} frames (${BRIGHT_YELLOW}$first_frame to $last_frame${BRIGHT_CYAN}).${RESET}"
	echo -e "${BRIGHT_CYAN}In your .tex file, use : ${BRIGHT_WHITE}\\\\animategraphics[autoplay,loop,width=1.0\\\\textwidth]{$fps}{./$output_dir/${gif_file%.*}-}{$first_frame}{$last_frame}${RESET}"
}
#-------------------------------------------------------------

#-------------------------------------------------------------
function avi2gif() {
	local pattern="*.avi"
	local fps=10
	local width=1080
	local backup=0
	local recursive=0
	local finder_cmd=""

	if ! hascommand --strict ffmpeg; then
		echo -e "${BRIGHT_RED}Error:${RESET} FFmpeg (${BRIGHT_YELLOW}ffmpeg${RESET}) is not installed or not in the PATH."
		return 1
	fi

	if ! hascommand --strict convert; then
		echo -e "${BRIGHT_RED}Error:${RESET} ImageMagick (${BRIGHT_YELLOW}convert${RESET}) is not installed or not in the PATH."
		return 1
	fi

	# Determine best finder command
	if hascommand --strict fd; then
		finder_cmd="fd"
	elif hascommand --strict fdfind; then
		finder_cmd="fdfind"
	else
		finder_cmd="find"
	fi

	# Help function
	show_help() {
		echo -e "${BRIGHT_WHITE}avi2gif:${RESET} Convert AVI videos to optimized GIFs using ${BRIGHT_CYAN}FFmpeg${RESET} and ${BRIGHT_CYAN}ImageMagick${RESET}"
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}avi2gif${RESET} ${BRIGHT_YELLOW}[options]${RESET}"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_GREEN}-f, --fps <value>${RESET}       Set frame rate (default: 10)"
		echo -e "  ${BRIGHT_GREEN}-w, --width <pixels>${RESET}    Set GIF width (default: 1080, -1 keeps aspect ratio)"
		echo -e "  ${BRIGHT_GREEN}-p, --pattern <glob>${RESET}   File pattern (default: *.avi)"
		echo -e "  ${BRIGHT_GREEN}-b, --backup${RESET}           Create backup (.bak) before modification"
		echo -e "  ${BRIGHT_GREEN}-r, --recursive${RESET}        Process files recursively"
		echo -e "  ${BRIGHT_GREEN}-h, --help${RESET}             Show this help message"
		return 1
	}

	# Show help if no arguments
	if [ $# -eq 0 ]; then
		show_help
		return
	fi

	# Parse options
	while [[ "$1" == -* ]]; do
		case "$1" in
		--fps | -f)
			fps="$2"
			shift
			;;
		--width | -w)
			width="$2"
			shift
			;;
		--pattern | -p)
			pattern="$2"
			shift
			;;
		--backup | -b) backup=1 ;;
		--recursive | -r) recursive=1 ;;
		--help | -h)
			show_help
			return
			;;
		*)
			echo -e "${BRIGHT_RED}Error:${RESET} Unknown option: $1"
			return 1
			;;
		esac
		shift
	done

	# Find files
	local files_array=()
	echo -e "${BRIGHT_CYAN}Finding files with ${BRIGHT_YELLOW}$finder_cmd${BRIGHT_CYAN}:${RESET}"

	if [ "$finder_cmd" = "fd" ] || [ "$finder_cmd" = "fdfind" ]; then
		local fd_options=("--type" "f" "--glob" "$pattern")
		[[ $recursive -eq 1 ]] || fd_options+=("--max-depth" "1")
		while IFS= read -r file; do
			files_array+=("$file")
		done < <($finder_cmd "${fd_options[@]}" 2>/dev/null)
	else
		local find_cmd="find . -type f -name '$pattern'"
		[[ $recursive -eq 0 ]] && find_cmd="$find_cmd -maxdepth 1"
		while IFS= read -r file; do
			files_array+=("$file")
		done < <(eval "$find_cmd" 2>/dev/null)
	fi

	local file_count=${#files_array[@]}
	if [ $file_count -eq 0 ]; then
		echo -e "${BRIGHT_YELLOW}No matching files found.${RESET}"
		return 0
	fi

	echo -e "${BRIGHT_CYAN}Processing ${BRIGHT_YELLOW}$file_count${BRIGHT_CYAN} file(s)...${RESET}"
	for file in "${files_array[@]}"; do
		echo -e "Processing: ${BRIGHT_YELLOW}$file${RESET}"
		[ $backup -eq 1 ] && cp "$file" "$file.bak"

		local filename="${file%.*}"
		ffmpeg -i "$file" -vf "fps=$fps,scale=$width:-1:flags=lanczos" -c:v pam \
			-f image2pipe - |
			convert -delay "$((100 / fps))" - -loop 0 -layers optimize "$filename.gif"
	done

	echo -e "${BRIGHT_CYAN}Processing completed.${RESET}"
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# salloc wrapper
function getnode() {
	local time=30
	local nodes=1
	local wckey="P121K:EUROPLEXUS"
	local partition=""
	local job_name=""
	local auto_ssh=0 # Default to not auto-connecting

	if ! hascommand --strict salloc; then
		echo -e "${BRIGHT_RED}Error:${RESET} SLURM's ${BRIGHT_YELLOW}salloc${RESET} command is not installed or not in the PATH."
		return 1
	fi

	# Help function
	show_help() {
		echo -e "${BRIGHT_WHITE}getnode:${RESET} Request an exclusive job allocation using SLURM's ${BRIGHT_CYAN}salloc${RESET}"
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}getnode${RESET} ${BRIGHT_YELLOW}[options]${RESET}"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_GREEN}-t, --time <minutes>${RESET}   Set job duration (default: 30 minutes)"
		echo -e "  ${BRIGHT_GREEN}-n, --nodes <count>${RESET}    Set number of nodes (default: 1)"
		echo -e "  ${BRIGHT_GREEN}-w, --wckey <key>${RESET}     Set workload key (default: P121K:EUROPLEXUS)"
		echo -e "  ${BRIGHT_GREEN}-p, --partition <name>${RESET} Set SLURM partition (optional)"
		echo -e "  ${BRIGHT_GREEN}-j, --job-name <name>${RESET} Set job name (optional)"
		echo -e "  ${BRIGHT_GREEN}-s, --ssh${RESET}             Auto-connect to the first allocated node"
		echo -e "  ${BRIGHT_GREEN}-h, --help${RESET}            Show this help message"
		return 1
	}

	# Parse options
	while [[ "$1" == -* ]]; do
		case "$1" in
		--time | -t)
			time="$2"
			shift
			;;
		--nodes | -n)
			nodes="$2"
			shift
			;;
		--wckey | -w)
			wckey="$2"
			shift
			;;
		--partition | -p)
			partition="$2"
			shift
			;;
		--job-name | -j)
			job_name="$2"
			shift
			;;
		--ssh | -s)
			auto_ssh=1 # Set to 1 if -s or --ssh is provided
			;;
		--help | -h)
			show_help
			return
			;;
		*)
			echo -e "${BRIGHT_RED}Error:${RESET} Unknown option: $1"
			return 1
			;;
		esac
		shift
	done

	echo -e "${BRIGHT_CYAN}Requesting an exclusive job allocation...${RESET}"
	echo -e "  Time: ${BRIGHT_YELLOW}${time} minutes${RESET}"
	echo -e "  Nodes: ${BRIGHT_YELLOW}${nodes}${RESET}"
	echo -e "  Workload Key: ${BRIGHT_YELLOW}${wckey}${RESET}"
	[[ -n "$partition" ]] && echo -e "  Partition: ${BRIGHT_YELLOW}${partition}${RESET}"
	[[ -n "$job_name" ]] && echo -e "  Job Name: ${BRIGHT_YELLOW}${job_name}${RESET}"

	# Create a small helper script instead of using declare -f
	local temp_script
	temp_script=$(mktemp)

	# Write the job handler function to the temporary script
	cat >"$temp_script" <<'EOF'
#!/bin/bash
# Function to handle job allocation information
get_node_info() {
	# Load color variables
	local BRIGHT_CYAN="\033[1;36m"
	local BRIGHT_GREEN="\033[1;32m"
	local BRIGHT_YELLOW="\033[1;33m"
	local BRIGHT_WHITE="\033[1;37m"
	local RESET="\033[0m"

	# Read auto_ssh and job_name from environment variables
	local auto_ssh="${AUTO_SSH}"
	local job_name="${JOB_NAME}"

	if [ -n "$SLURM_JOB_ID" ]; then
		# Get node list using squeue, filtering by job ID
		local node_info
		node_info=$(squeue -j "$SLURM_JOB_ID" -o "%N" -h)

		# Clean up any whitespace
		local node_list
		node_list=$(echo "$node_info" | tr -d ' \n')

		echo -e "${BRIGHT_GREEN}Success:${RESET} Job allocated successfully."
		echo -e "  Job ID: ${BRIGHT_YELLOW}${SLURM_JOB_ID}${RESET}"
		echo -e "  Allocated nodes: ${BRIGHT_YELLOW}${node_list}${RESET}"

		# Automatically connect to the first node if the -s/--ssh option was provided
		local first_node
		first_node=$(echo "$node_list" | cut -d',' -f1)

		if [ "$auto_ssh" -eq 1 ]; then
			echo -e "${BRIGHT_CYAN}Auto-connecting to the first node...${RESET}"
			ssh "$first_node"
		fi
	else
		# If SLURM_JOB_ID is not set, try to find the job by name/user
		local job_name_to_match="${job_name:-interact}"
		local user_name=$(whoami)

		# Get job info using squeue, filtering by job name and username
		local job_info
		job_info=$(squeue -n "$job_name_to_match" -u "$user_name" -o "%i|%N" -h | head -1)

		if [ -n "$job_info" ]; then
			local found_job_id=$(echo "$job_info" | cut -d'|' -f1)
			local found_node_list=$(echo "$job_info" | cut -d'|' -f2 | tr -d ' \n')

			echo -e "${BRIGHT_GREEN}Success:${RESET} Job allocated successfully."
			echo -e "  Job ID: ${BRIGHT_YELLOW}${found_job_id}${RESET}"
			echo -e "  Allocated nodes: ${BRIGHT_YELLOW}${found_node_list}${RESET}"

			# Automatically connect to the first node if the -s/--ssh option was provided
			local first_node
			first_node=$(echo "$found_node_list" | cut -d',' -f1)

			if [ "$auto_ssh" -eq 1 ]; then
				echo -e "${BRIGHT_CYAN}Auto-connecting to the first node...${RESET}"
				ssh "$first_node"
			fi
		else
			echo -e "${BRIGHT_YELLOW}Warning:${RESET} Unable to determine job information."
		fi
	fi
}

# Run the node info function and then open a shell
get_node_info
exec bash
EOF

	# Make the script executable
	chmod +x "$temp_script"

	# Set the environment variables for job_name and auto_ssh
	export JOB_NAME="$job_name"
	export AUTO_SSH="$auto_ssh"

	# Build salloc command
	local salloc_cmd=(salloc --exclusive --time="$time" --nodes="$nodes" --wckey="$wckey")
	[[ -n "$partition" ]] && salloc_cmd+=(--partition="$partition")
	[[ -n "$job_name" ]] && salloc_cmd+=(--job-name="$job_name")

	# Run salloc with the script as the command
	"${salloc_cmd[@]}" "$temp_script"

	local status=$?

	# Clean up the temporary script
	rm -f "$temp_script"

	if [ $status -ne 0 ]; then
		echo -e "${BRIGHT_RED}Error:${RESET} Job allocation failed. Please check SLURM settings."
		return $status
	fi

	# Unset environment variables after they're used
	unset JOB_NAME
	unset AUTO_SSH
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# scancel wrapper
function sc() {

	if ! hascommand --strict scancel; then
		echo -e "${BRIGHT_RED}Error:${RESET} SLURM's ${BRIGHT_YELLOW}scancel${RESET} command is not installed or not in the PATH."
		return 1
	fi

	# Help function
	show_help() {
		echo -e "${BRIGHT_WHITE}sc:${RESET} Cancel one or more jobs using SLURM's ${BRIGHT_CYAN}scancel${RESET}"
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}sc${RESET} ${BRIGHT_YELLOW}[options]${RESET}"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_GREEN}-h, --help${RESET}      Show this help message"
	}

	# Check if fzf is available
	if ! hascommand --strict fzf; then
		use_select=true
	else
		use_select=false
	fi

	# Parse options
	while [[ "$1" == -* ]]; do
		case "$1" in
		--help | -h)
			show_help
			return
			;;
		*)
			echo -e "${BRIGHT_RED}Error:${RESET} Unknown option: $1"
			return 1
			;;
		esac
		shift
	done

	# Function to display jobs and select one
	select_job() {
		# Get the list of jobs to cancel with additional details
		local jobs
		jobs=$(squeue -u $(whoami) --format="%i %j %T %N %D %P %M %l" | tail -n +2)

		if [ -z "$jobs" ]; then
			echo -e "${BRIGHT_YELLOW}No jobs found to cancel.${RESET}"
			return 1
		fi

		# Format headers
		if [ "$use_select" = true ]; then
			local formatted_jobs
			formatted_jobs=$(echo "$jobs" | awk '{print "\033[1;32m"$1"\033[0m \033[1;34m"$2"\033[0m \033[1;33m"$3"\033[0m \033[1;35m"$4"\033[0m \033[1;36m"$5"\033[0m \033[1;37m"$6"\033[0m \033[1;31m"$7"\033[0m \033[1;37m"$8"\033[0m"}')
			mapfile -t job_options < <(echo "$formatted_jobs")

			# Display all jobs with numbers
			echo -e "${BRIGHT_CYAN}Select jobs to cancel (comma-separated numbers, e.g., 1,3,5 or 'all' for all jobs):${RESET}"
			for i in "${!job_options[@]}"; do
				echo -e "$((i + 1))) ${job_options[$i]}"
			done

			# Read user input
			echo -e "${BRIGHT_CYAN}Enter job numbers:${RESET}"
			echo -n "❯ "
			read -r selection

			# Process selection
			if [[ "$selection" == "all" ]]; then
				# Cancel all jobs
				for i in "${!job_options[@]}"; do
					job_id=$(echo "$jobs" | sed -n "$((i + 1))p" | awk '{print $1}')
					scancel "$job_id"
					echo -e "${BRIGHT_GREEN}Job ${BRIGHT_YELLOW}$job_id${RESET} cancelled successfully."
				done
			else
				# Process comma-separated selection
				IFS=',' read -ra selected_indices <<<"$selection"
				for index in "${selected_indices[@]}"; do
					if [[ "$index" =~ ^[0-9]+$ ]] && [ "$index" -ge 1 ] && [ "$index" -le "${#job_options[@]}" ]; then
						job_id=$(echo "$jobs" | sed -n "${index}p" | awk '{print $1}')
						scancel "$job_id"
						echo -e "${BRIGHT_GREEN}Job ${BRIGHT_YELLOW}$job_id${RESET} cancelled successfully."
					else
						echo -e "${BRIGHT_RED}Invalid selection: $index${RESET}"
					fi
				done
			fi
		else
			# Use fzf for job selection
			echo -e "${BRIGHT_CYAN}Select jobs to cancel (use Ctrl+Space to select multiple):${RESET}"
			local selected_jobs
			selected_jobs=$(echo "$jobs" | fzf --ansi --multi --preview "printf \"\033[1;32mJob ID:\033[0m \033[1;36m{1}\033[0m\n\033[1;34mJob Name:\033[0m \033[1;34m{2}\033[0m\n\033[1;33mStatus:\033[0m \033[1;33m{3}\033[0m\n\033[1;35mNodes:\033[0m \033[1;35m{4}\033[0m\n\033[1;36mNumber of Nodes:\033[0m \033[1;36m{5}\033[0m\n\033[1;37mPartition:\033[0m \033[1;37m{6}\033[0m\n\033[1;31mTime:\033[0m \033[1;31m{7}\033[0m\n\033[1;37mTime Limit:\033[0m \033[1;37m{8}\033[0m\"" | awk '{print $1}')
			if [ -n "$selected_jobs" ]; then
				for selected_job in $selected_jobs; do
					scancel "$selected_job"
					echo -e "${BRIGHT_GREEN}Job ${BRIGHT_YELLOW}$selected_job${RESET} cancelled successfully."
				done
			else
				echo -e "${BRIGHT_RED}No job selected.${RESET}"
			fi
		fi
	}

	# Run the select job function
	select_job
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# squeue wrapper
function sq() {
	if ! hascommand --strict squeue; then
		echo -e "${BRIGHT_RED}Error:${RESET} SLURM's ${BRIGHT_YELLOW}squeue${RESET} command is not installed or not in the PATH."
		return 1
	fi

	# Help function
	show_help() {
		echo -e "${BRIGHT_WHITE}sq:${RESET} Enhanced SLURM queue display"
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}sq${RESET} ${BRIGHT_YELLOW}[options]${RESET}"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_GREEN}-h, --help${RESET}       Show this help message"
		echo -e "  ${BRIGHT_GREEN}-f, --full${RESET}        Show full job details"
	}

	# Define color variables (easy to modify)
	C_JOBID="${CYAN}"
	C_PARTITION="${MAGENTA}"
	C_QOS="${GREEN}"
	C_NAME="${YELLOW}"
	C_TIME_LEFT="${BLUE}"
	C_TIME="${RED}"
	C_NODES="${MAGENTA}"
	C_CPUS="${GREEN}"
	C_NODELIST="${YELLOW}"
	C_EXEC_HOST="${BLUE}"
	C_WORK_DIR="${RED}"
	C_HEADER="${BRIGHT_WHITE}"

	# Define state colors
	C_STATE_PENDING="${YELLOW}"
	C_STATE_RUNNING="${GREEN}"
	C_STATE_SUSPENDED="${YELLOW}"
	C_STATE_COMPLETING="${BLUE}"
	C_STATE_COMPLETED="${BLUE}"
	C_STATE_DEFAULT="${RED}"

	# Field width parameters
	WIDTH_JOBID=10
	WIDTH_PARTITION=9
	WIDTH_QOS=16
	WIDTH_NAME=12
	WIDTH_STATE=8
	WIDTH_TIME_LEFT=9
	WIDTH_TIME=6
	WIDTH_NODES=4
	WIDTH_CPUS=4
	WIDTH_NODELIST=18
	WIDTH_EXEC_HOST=12
	WIDTH_WORK_DIR=40

	# Track if we're using full format
	is_full=0

	# Default format
	format="%${WIDTH_JOBID}i %${WIDTH_PARTITION}P %${WIDTH_NAME}j %${WIDTH_STATE}T %${WIDTH_TIME_LEFT}L %${WIDTH_TIME}M %${WIDTH_NODES}D %${WIDTH_CPUS}C %${WIDTH_NODELIST}R"

	# Parse options
	while [[ "$1" == -* ]]; do
		case "$1" in
		--help | -h)
			show_help
			return
			;;
		--full | -f)
			format="%${WIDTH_JOBID}i %${WIDTH_PARTITION}P %${WIDTH_QOS}q %${WIDTH_NAME}j %${WIDTH_STATE}T %${WIDTH_TIME_LEFT}L %${WIDTH_TIME}M %${WIDTH_NODES}D %${WIDTH_CPUS}C %${WIDTH_NODELIST}R %${WIDTH_EXEC_HOST}B %${WIDTH_WORK_DIR}Z"
			is_full=1
			;;
		*)
			echo -e "${BRIGHT_RED}Error:${RESET} Unknown option: $1"
			return 1
			;;
		esac
		shift
	done

	# Field width parameters
	POS_JOBID=1
	POS_PARTITION=2
	if [[ "$is_full" -eq 1 ]]; then
		POS_QOS=3
		POS_NAME=4
		POS_STATE=5
		POS_TIME_LEFT=6
		POS_TIME=7
		POS_NODES=8
		POS_CPUS=9
		POS_NODELIST=10
		POS_EXEC_HOST=11
		POS_WORK_DIR=12
	else
		POS_QOS=0
		POS_NAME=3
		POS_STATE=4
		POS_TIME_LEFT=5
		POS_TIME=6
		POS_NODES=7
		POS_CPUS=8
		POS_NODELIST=9
		POS_EXEC_HOST=0
		POS_WORK_DIR=0
	fi

	# Run squeue and process with awk for proper alignment
	squeue --me --format="$format" | awk \
		-v C_RESET="$RESET" -v C_HEADER="$C_HEADER" \
		-v C_JOBID="$C_JOBID" -v C_PARTITION="$C_PARTITION" -v C_QOS="$C_QOS" -v C_NAME="$C_NAME" \
		-v C_TIME_LEFT="$C_TIME_LEFT" -v C_TIME="$C_TIME" -v C_NODES="$C_NODES" \
		-v C_CPUS="$C_CPUS" -v C_NODELIST="$C_NODELIST" -v C_EXEC_HOST="$C_EXEC_HOST" -v C_WORK_DIR="$C_WORK_DIR" \
		-v C_STATE_PENDING="$C_STATE_PENDING" -v C_STATE_RUNNING="$C_STATE_RUNNING" \
		-v C_STATE_SUSPENDED="$C_STATE_SUSPENDED" -v C_STATE_COMPLETING="$C_STATE_COMPLETING" \
		-v C_STATE_COMPLETED="$C_STATE_COMPLETED" -v C_STATE_DEFAULT="$C_STATE_DEFAULT" \
		-v WIDTH_JOBID="$WIDTH_JOBID" -v WIDTH_PARTITION="$WIDTH_PARTITION" -v WIDTH_QOS="$WIDTH_QOS" \
		-v WIDTH_NAME="$WIDTH_NAME" -v WIDTH_STATE="$WIDTH_STATE" -v WIDTH_TIME_LEFT="$WIDTH_TIME_LEFT" \
		-v WIDTH_TIME="$WIDTH_TIME" -v WIDTH_NODES="$WIDTH_NODES" -v WIDTH_CPUS="$WIDTH_CPUS" \
		-v WIDTH_NODELIST="$WIDTH_NODELIST" -v WIDTH_EXEC_HOST="$WIDTH_EXEC_HOST" -v WIDTH_WORK_DIR="$WIDTH_WORK_DIR" \
		-v is_full="$is_full" -v POS_JOBID="$POS_JOBID" -v POS_PARTITION="$POS_PARTITION" -v POS_QOS="$POS_QOS" \
		-v POS_NAME="$POS_NAME" -v POS_STATE="$POS_STATE" -v POS_TIME_LEFT="$POS_TIME_LEFT" -v POS_TIME="$POS_TIME" \
		-v POS_NODES="$POS_NODES" -v POS_CPUS="$POS_CPUS" -v POS_NODELIST="$POS_NODELIST" -v POS_EXEC_HOST="$POS_EXEC_HOST" \
		-v POS_WORK_DIR="$POS_WORK_DIR" '
    BEGIN {
        FS=" ";
        OFS=" ";
    }
    NR == 1 {
        print C_HEADER $0 C_RESET;
        next;
    }
    {
        n = split($0, fields, " ");
        state = fields[POS_STATE];
        state_color = C_STATE_DEFAULT;

        if (state == "PENDING") state_color = C_STATE_PENDING;
        else if (state == "RUNNING") state_color = C_STATE_RUNNING;
        else if (state == "SUSPENDED") state_color = C_STATE_SUSPENDED;
        else if (state == "COMPLETING") state_color = C_STATE_COMPLETING;
        else if (state == "COMPLETED") state_color = C_STATE_COMPLETED;

        printf C_JOBID "%-" WIDTH_JOBID "s" C_RESET " ", fields[POS_JOBID];
        printf C_PARTITION "%-" WIDTH_PARTITION "s" C_RESET " ", fields[POS_PARTITION];
        if (is_full == 1) printf C_QOS "%-" WIDTH_QOS "s" C_RESET " ", fields[POS_QOS];
        printf C_NAME "%-" WIDTH_NAME "s" C_RESET " ", fields[POS_NAME];
        printf state_color "%-" WIDTH_STATE "s" C_RESET " ", state;
        printf C_TIME_LEFT "%-" WIDTH_TIME_LEFT "s" C_RESET " ", fields[POS_TIME_LEFT];
        printf C_TIME "%-" WIDTH_TIME "s" C_RESET " ", fields[POS_TIME];
        printf C_NODES "%-" WIDTH_NODES "s" C_RESET " ", fields[POS_NODES];
        printf C_CPUS "%-" WIDTH_CPUS "s" C_RESET " ", fields[POS_CPUS];
        printf C_NODELIST "%-" WIDTH_NODELIST "s" C_RESET " ", fields[POS_NODELIST];

        if (is_full == 1) {
            printf C_EXEC_HOST "%-" WIDTH_EXEC_HOST "s" C_RESET " ", fields[POS_EXEC_HOST];
            printf C_WORK_DIR "%-" WIDTH_WORK_DIR "s" C_RESET "\n", fields[POS_WORK_DIR];
        } else {
            printf "\n";
        }
    }'
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Git branch auto-completion setup
_gitbranch_autocomplete() {
	local cur=${COMP_WORDS[COMP_CWORD]}
	local branches=$(git branch --format='%(refname:short)' 2>/dev/null)

	# Add remote branches if they exist
	if git remote -v 2>/dev/null | grep -q 'origin'; then
		remote_branches=$(git ls-remote --refs --heads origin 2>/dev/null | awk '{sub("refs/heads/", ""); print $2}')
		branches="$branches $remote_branches"
	fi

	COMPREPLY=($(compgen -W "$branches" -- "$cur"))
}
# Register the auto-completion function
complete -F _gitbranch_autocomplete gitbranch
#-------------------------------------------------------------

#-------------------------------------------------------------
# Change the git branch
function gitbranch() {

# Help function for gitbranch
show_help() {
	echo -e "${BRIGHT_WHITE}gitbranch:${RESET} Interactive Git branch switching utility"
	echo -e "${BRIGHT_WHITE}Usage:${RESET}"
	echo -e "  ${BRIGHT_CYAN}gitbranch${RESET} ${BRIGHT_YELLOW}[branch_name]${RESET} ${BRIGHT_YELLOW}[options]${RESET}"
	echo -e "${BRIGHT_WHITE}Options:${RESET}"
	echo -e "  ${BRIGHT_YELLOW}-h, --help${RESET}   Show this help message"
	echo -e "${BRIGHT_WHITE}Behavior:${RESET}"
	echo -e "  ${BRIGHT_BLUE}• No arguments:${RESET} Interactive menu to select a branch"
	echo -e "  ${BRIGHT_BLUE}• With argument:${RESET} Directly switch to specified branch"
	echo -e "${BRIGHT_WHITE}Examples:${RESET}"
	echo -e "  ${BRIGHT_CYAN}gitbranch${RESET}                ${BRIGHT_BLUE}# Interactive branch selection${RESET}"
	echo -e "  ${BRIGHT_CYAN}gitbranch${RESET} ${BRIGHT_GREEN}feature/login${RESET}   ${BRIGHT_BLUE}# Switch to feature/login branch${RESET}"
}

	# Display help if requested
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then
		show_help
		return 0
	fi

	# Check if the current directory is a Git repository
	if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		# No arguments passed
		if [[ $# -eq 0 ]]; then
			# Check if there is a remote server
			if git remote -v | grep -q 'origin'; then
				# Prompt the user for action
				if ask "${BRIGHT_WHITE}Download ${BRIGHT_YELLOW}remote${BRIGHT_WHITE} branch names?${BRIGHT_RED} Could be slow for large repos.${RESET}" N; then
					# Fetch latest remote branches; handle errors
					git fetch origin 2>/dev/null || {
						echo -e "${BRIGHT_RED}Error: Could not fetch from remote${RESET}"
						return 1
					}

					# Get remote branches, sorted by commit date
					REMOTE_BRANCHES=$(git for-each-ref --sort=-committerdate refs/remotes/origin/ --format='%(refname:short)' | sed 's|origin/||')

					if [[ -z "$REMOTE_BRANCHES" ]]; then
						echo -e "${BRIGHT_RED}Error: No remote branches found${RESET}"
						return 1
					fi

					# Use createmenu for selection
					local selected_branch=$(echo "$REMOTE_BRANCHES" | createmenu)

					# Check if the branch exists locally before checkout
					if git show-ref --verify --quiet refs/heads/"$selected_branch"; then
						git checkout "$selected_branch"
					else
						git checkout -b "$selected_branch" origin/"$selected_branch"
					fi
				else
					# Use local branches for selection via createmenu
					git checkout "$(git branch --sort=-committerdate | cut -c 3- | createmenu)"
				fi
			else
				# No remote server, use local branches only
				git checkout "$(git branch --sort=-committerdate | cut -c 3- | createmenu)"
			fi
		else
			# Argument passed, just switch to that branch
			git checkout "${@}"
		fi
	else
		# Not a Git repo
		echo -e "${BRIGHT_RED}ERROR: ${BRIGHT_CYAN}Current directory is not a Git repository${RESET}"
	fi
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Find files recursively with glob patterns
function findfile() {

	# Help function
	show_help() {
		echo -e "${BRIGHT_WHITE}findfile:${RESET} Searches for filenames recursively"
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}findfile${RESET} ${BRIGHT_YELLOW}[options]${RESET} ${BRIGHT_GREEN}pattern${RESET}"
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_YELLOW}-s, --sudo${RESET}   Use sudo for searching"
		echo -e "  ${BRIGHT_YELLOW}-h, --help${RESET}   Show this help message"
		echo -e "${BRIGHT_WHITE}Examples:${RESET}"
		echo -e "  ${BRIGHT_CYAN}findfile${RESET} ${BRIGHT_GREEN}'*.cpp'${RESET}           ${BRIGHT_BLUE}# Find all .cpp files${RESET}"
		echo -e "  ${BRIGHT_CYAN}findfile${RESET} ${BRIGHT_GREEN}\"*post*.h\"${RESET}        ${BRIGHT_BLUE}# Find .h files with 'post' in name${RESET}"
		echo -e "  ${BRIGHT_CYAN}findfile${RESET} ${BRIGHT_YELLOW}-s${RESET} ${BRIGHT_GREEN}'conf*'${RESET}          ${BRIGHT_BLUE}# Find with sudo${RESET}"
	}

	# Initialize the sudo prefix for running commands with elevated permissions
	local SUDO_PREFIX=""
	local PATTERN=""

	# Process options
	while [[ "$#" -gt 0 ]]; do
		case "$1" in
		--sudo | -s)
			SUDO_PREFIX="sudo "
			shift
			;;
		--help | -h)
			# Show help and exit
			show_help
			return 0
			;;
		-*)
			echo -e "${BRIGHT_RED}Error:${RESET} Unknown option $1"
			echo -e "Use ${BRIGHT_CYAN}findfile --help${RESET} for usage information"
			return 1
			;;
		*)
			# Set pattern
			PATTERN="$1"
			shift
			# If there are more arguments, show error
			if [[ "$#" -gt 0 ]]; then
				echo -e "${BRIGHT_RED}Error:${RESET} Too many arguments"
				echo -e "Use ${BRIGHT_CYAN}findfile --help${RESET} for usage information"
				return 1
			fi
			;;
		esac
	done

	# Check if pattern is specified
	if [[ -z "$PATTERN" ]]; then
		show_help
		return 0
	fi

	# Use fdfind if installed, else use fd or find as fallback
	if hascommand --strict fdfind; then
		# Construct command
		local FD_CMD="${SUDO_PREFIX}fdfind --type file --ignore-case --no-ignore --hidden --glob"

		# Count files and display results
		local COUNT=$(${SUDO_PREFIX}fdfind --type file --ignore-case --no-ignore --hidden --glob "$PATTERN" . | wc -l)

		# Execute the command
		eval "$FD_CMD \"$PATTERN\" ."

		# Display count
		echo -e "${BRIGHT_WHITE}$COUNT files found${RESET}"

	elif hascommand --strict fd; then
		# Construct command
		local FD_CMD="${SUDO_PREFIX}fd --type file --ignore-case --no-ignore --hidden --glob"

		# Count files and display results
		local COUNT=$(${SUDO_PREFIX}fd --type file --ignore-case --no-ignore --hidden --glob "$PATTERN" . | wc -l)

		# Execute the command
		eval "$FD_CMD \"$PATTERN\" ."

		# Display count
		echo -e "${BRIGHT_WHITE}$COUNT files found${RESET}"

	else # Use find command as a last resort
		# Construct find command
		local FIND_CMD="${SUDO_PREFIX}find . -type f"

		# Add name pattern
		if [[ "$PATTERN" == *\** || "$PATTERN" == *\?* || "$PATTERN" == *\[* ]]; then
			# Pattern already has glob characters
			FIND_CMD+=" -iname \"$PATTERN\""
		else
			# No glob characters, add wildcards for substring matching
			FIND_CMD+=" -iname \"*$PATTERN*\""
		fi

		# Add follow symlinks
		FIND_CMD+=" -follow 2>/dev/null"

		# Count files and display results
		local COUNT=$(eval "$FIND_CMD" | wc -l)

		# Execute the command
		eval "$FIND_CMD"

		# Display count
		echo -e "${BRIGHT_WHITE}$COUNT files found${RESET}"
	fi

	# Return success
	return 0
}
#-------------------------------------------------------------

#-------------------------------------------------------------
#  _____ __________
# |  ___|__  /  ___|
# | |_    / /| |_
# |  _|  / /_|  _|
# |_|   /____|_|
#
#-------------------------------------------------------------

#-------------------------------------------------------------
# Fzf config
if hascommand --strict fzf; then
	if hascommand --strict fdfind; then
		export FZF_DEFAULT_COMMAND="fdfind --hidden --exclude '.git' --exclude 'node_modules' --exclude '.cache' --exclude '.local' --exclude 'target'"
	elif hascommand --strict fd; then
		export FZF_DEFAULT_COMMAND="fd --hidden --exclude '.git' --exclude 'node_modules' --exclude '.cache' --exclude '.local' --exclude 'target'"
	fi
	if hascommand --strict bat; then
		export FZF_PREVIEW_COMMAND_FILE='bat -n --color=always -r :500 {}'
	elif hascommand --strict batcat; then
		export FZF_PREVIEW_COMMAND_FILE='batcat -n --color=always -r :500 {}'
	else
		export FZF_PREVIEW_COMMAND_FILE='cat -n {}'
	fi
	if hascommand --strict eza; then
		export FZF_PREVIEW_COMMAND_DIR='eza --tree --level 1 --color=always --icons {}'
	else
		export FZF_PREVIEW_COMMAND_DIR='tree -C {}'
	fi
	if [[ $TERM = xterm-kitty ]]; then
		export FZF_PREVIEW_COMMAND_IMG='kitty icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {}'
		export FZF_PREVIEW_COMMAND_IMG_CLEAR='printf "\x1b_Ga=d,d=A\x1b\\" &&'
	else
		export FZF_PREVIEW_COMMAND_IMG='echo image: {}'
		export FZF_PREVIEW_COMMAND_IMG_CLEAR=""
	fi
	if hascommand --strict pbcopy; then
		CLIP_COMMAND="pbcopy"
	elif hascommand --strict xclip; then
		CLIP_COMMAND="xclip -selection clipboard"
	elif hascommand --strict xsel; then
		CLIP_COMMAND="xsel --clipboard"
	else
		CLIP_COMMAND=${FZF_PREVIEW_COMMAND_FILE}
	fi
	if hascommand --strict xdg-open; then
		OPEN_COMMAND="xdg-open"
	elif hascommand --strict open; then
		OPEN_COMMAND="open"
	else
		OPEN_COMMAND="echo Opening not supported" # Fallback
	fi
	export FZF_PREVIEW_COMMAND_DEFAULT='echo {}'
	export FZF_PREVIEW_COMMAND_FILE=''${FZF_PREVIEW_COMMAND_IMG_CLEAR}' [[ $(file --mime {}) =~ image ]] && '${FZF_PREVIEW_COMMAND_IMG}' || ([[ $(file --mime {}) =~ binary ]] && '${FZF_PREVIEW_COMMAND_DEFAULT}'is binary file  || '${FZF_PREVIEW_COMMAND_FILE}')'
	# export FZF_PREVIEW_COMMAND='[[ $(file --mime {}) =~ directory ]] && '${FZF_PREVIEW_COMMAND_DIR}' || ([[ $(file --mime {}) =~ binary ]] && '${FZF_PREVIEW_COMMAND_DEFAULT}'is binary file  || '${FZF_PREVIEW_COMMAND_FILE}')'
	export FZF_PREVIEW_COMMAND='('${FZF_PREVIEW_COMMAND_IMG}' || '${FZF_PREVIEW_COMMAND_FILE}' || '${FZF_PREVIEW_COMMAND_DIR}' || '${FZF_PREVIEW_COMMAND_DEFAULT}') 2> /dev/null'
	if hascommand --strict fdfind || hascommand --strict fd; then
		export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND} --type f"
	fi
	export FZF_CTRL_T_OPTS="
  	--walker-skip .git,node_modules,target
  	--border-label='╢ Ctrl-T:Files ╟'
  	--preview '${FZF_PREVIEW_COMMAND_FILE}'
  	--preview-window 'right:50%:wrap'
  	--bind 'ctrl-/:change-preview-window(down,50%,border-top|hidden|)'
  	--bind 'ctrl-u:preview-half-page-up'
  	--bind 'ctrl-d:preview-half-page-down'
  	--bind 'ctrl-x:reload("$FZF_CTRL_T_COMMAND")'
  	--bind 'ctrl-w:reload("$FZF_CTRL_T_COMMAND" --max-depth 1)'
  	--bind 'ctrl-y:execute-silent(echo -n {} | $CLIP_COMMAND)+abort'
  	--bind 'ctrl-o:execute($OPEN_COMMAND {})'
  	--header 'C-x:reload│C-w:depth│C-/:prev│C-y:copy│C-u/d:scroll│C-⎵:sel│C-o:open'"
	if hascommand --strict fdfind || hascommand --strict fd; then
		export FZF_ALT_C_COMMAND="${FZF_DEFAULT_COMMAND} --type d"
	fi
	export FZF_ALT_C_OPTS="
  	--walker-skip .git,node_modules,target
  	--preview '${FZF_PREVIEW_COMMAND_DIR}'
  	--preview-window 'right:50%:wrap'
  	--border-label='╢ Alt-C:Dirs ╟'
  	--bind 'ctrl-/:change-preview-window(down,50%,border-top|hidden|)'
  	--bind 'ctrl-u:preview-half-page-up'
  	--bind 'ctrl-d:preview-half-page-down'
  	--bind 'ctrl-x:reload("$FZF_ALT_C_COMMAND")'
  	--bind 'ctrl-w:reload("$FZF_ALT_C_COMMAND" --max-depth 1)'
  	--bind 'ctrl-o:execute($OPEN_COMMAND {})'
    --header 'C-x:reload│C-w:depth│C-/:prev│C-y:copy│C-u/d:scroll│C-⎵:sel│C-o:open'"
	export FZF_CTRL_R_OPTS="
    --preview 'echo {}'
    --border-label='╢ Ctrl-R:History ╟'
    --preview-window down:3:hidden:wrap
    --bind 'ctrl-/:toggle-preview'
    --bind 'ctrl-y:execute-silent(echo -n {2..} | $CLIP_COMMAND)+abort'
    --header 'C-/:prev│C-y:copy'"
	export FZF_DEFAULT_OPTS="--bind=tab:down,shift-tab:up --cycle
	--history='${HOME}/.fzf_history'
    --history-size=100000
    --no-mouse
    --bind='ctrl-space:toggle'
    --multi"
	# --- setup fzf theme ---
	export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS}
  	--color=fg:10,fg+:3,bg:0,bg+:0
  	--color=hl:4,hl+:12,info:6,marker:11
  	--color=prompt:1,spinner:13,pointer:5,header:8
  	--color=border:8,label:7,query:10
  	--color=header:italic"
	# --- setup fzf default options ---
	export FZF_DEFAULT_OPTS=${FZF_DEFAULT_OPTS}'
	--border="rounded" --border-label=""
	--prompt="  " --pointer="❯" --marker=" "'
	# --- setup fzf completions options ---
	if [[ -f "${HOME}/fzf-tab-completion/bash/fzf-bash-completion.sh" ]]; then
		export FZF_TAB_COMPLETION_PROMPT='  '
	fi
fi
#-------------------------------------------------------------

#-------------------------------------------------------------
# Fzf-git
if hascommand --strict fzf; then
	if [[ -f "$HOME/dotfiles/config/fzf-git/fzf-git.sh" ]]; then
		source "$HOME/dotfiles/config/fzf-git/fzf-git.sh"
		_fzf_git_fzf() {
			fzf --height=50% --tmux 90%,70% \
				--layout=reverse --multi --min-height=20 --border \
				--border-label-pos=2 \
				--color='header:italic:underline,label:blue' \
				--preview-window='right,50%,border-left' \
				--bind='ctrl-/:change-preview-window(down,50%,border-top|hidden|)' "$@"
		}
	fi
fi
#-------------------------------------------------------------

#-------------------------------------------------------------
#  ____   _  _____ _   _
# |  _ \ / \|_   _| | | |
# | |_) / _ \ | | | |_| |
# |  __/ ___ \| | |  _  |
# |_| /_/   \_\_| |_| |_|
#
#-------------------------------------------------------------

#-------------------------------------------------------------
# Path prepend
pathprepend "/opt/nvim/bin/" "${HOME}/CASTEM2022/bin" "/opt/cmake/bin" "/opt/tmux/"
# For Mac
if [ -d /usr/local/opt/grep/libexec/gnubin ]; then
	pathprepend "/usr/local/opt/grep/libexec/gnubin"
fi
if [ -d /usr/local/opt/coreutils/libexec/gnubin ]; then
	pathprepend "/usr/local/opt/coreutils/libexec/gnubin"
fi
if [ -d /usr/local/opt/gnu-sed/libexec/gnubin ]; then
	pathprepend "/usr/local/opt/gnu-sed/libexec/gnubin"
fi
#-------------------------------------------------------------

#-------------------------------------------------------------
#  _______  ______   ___  ____ _____ ____
# | ____\ \/ /  _ \ / _ \|  _ \_   _/ ___|
# |  _|  \  /| |_) | | | | |_) || | \___ \
# | |___ /  \|  __/| |_| |  _ < | |  ___) |
# |_____/_/\_\_|    \___/|_| \_\|_| |____/
#
#-------------------------------------------------------------

#-------------------------------------------------------------
# License file for ArmForge DDT (i think)
export LM_LICENSE_FILE=27000@noeyyr5y.noe.edf.fr
#-------------------------------------------------------------

#-------------------------------------------------------------
# Some formatting
export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTIGNORE="&:bg:fg:ll:h"
export HISTTIMEFORMAT="$(echo -e ${BRIGHT_CYAN})[%d/%m %H:%M:%S]$(echo -e ${RESET}) "
export HISTCONTROL=ignoredups
export HOSTFILE=$HOME/.hosts # Put a list of remote hosts in ~/.hosts
#-------------------------------------------------------------

#-------------------------------------------------------------
# Bat theme
export BAT_THEME=base16
export BAT_STYLE=plain
#-------------------------------------------------------------

#-------------------------------------------------------------
# Default editor in ranger
export SELECTED_EDITOR=$EDITOR
#-------------------------------------------------------------

#-------------------------------------------------------------
#     _    _     ___    _    ____  _____ ____
#    / \  | |   |_ _|  / \  / ___|| ____/ ___|
#   / _ \ | |    | |  / _ \ \___ \|  _| \___ \
#  / ___ \| |___ | | / ___ \ ___) | |___ ___) |
# /_/   \_\_____|___/_/   \_\____/|_____|____/
#
#-------------------------------------------------------------

#-------------------------------------------------------------
# Custom aliases
if [[ -f "/opt/sublime_text/sublime_text" ]]; then
	alias sublime_text='/opt/sublime_text/sublime_text'
fi
if [[ -f "${HOME}/paraview/bin/paraview" ]]; then
	alias paraview="${HOME}/paraview/bin/paraview &"
	export PATH=${HOME}/paraview/bin/:${PATH}
fi
if [[ -f "${HOME}/dev/epx/devtools/env.sh" ]]; then
	# Define a function instead of an alias to ensure immediate availability
	function epxenv { source "${HOME}/dev/epx/devtools/env.sh"; }
	if [[ "${SHLVL}" -lt 2 ]]; then
		if [ -z "${TMUX}" ]; then
			epxenv 1>/dev/null
		fi
	fi
fi
if [[ -f "${HOME}/dev/manta/dev-tools/env.sh" ]]; then
	function mantaenv { source "${HOME}/dev/manta/dev-tools/env.sh"; }
	if [[ "${SHLVL}" -lt 2 ]]; then
		if [ -z "${TMUX}" ]; then
			mantaenv 1>/dev/null
		fi
	fi
fi
if [[ -f "${HOME}/arm/forge/22.1.2/bin/ddt" ]]; then
	alias ddt="${HOME}/arm/forge/22.1.2/bin/ddt &"
fi
alias c='clear'         # c:            Clear terminal display
alias which='type -all' # which:        Find executables
if hascommand --strict eza; then
	unalias ldir
	alias ldir="eza -lD"
	unalias lfile
	alias lfile="eza -lf --color=always | grep -v /"
	alias lsh="eza ${_EZA_COMMON_FLAGS} --group-directories-first --hyperlink"
	alias llh="eza ${_EZA_LONG_FLAGS} --hyperlink"
fi
if hascommand --strict nvim; then
	alias {v,vi,vim}='nvim'
	alias svi='sudo nvim'
	alias vis='nvim "+set si"'
elif hascommand --strict vim; then
	alias {v,vi}='vim'
	alias svi='sudo vim'
	alias vis='vim "+set si"'
elif hascommand --strict vi; then
	alias v='vi'
	alias svi='sudo vi'
fi
if hascommand --strict batcat; then
	alias bat='batcat --color=always'
fi
if hascommand --strict bat; then
	alias bat='bat --color=always'
fi
alias fk='fuck'
#-------------------------------------------------------------

#-------------------------------------------------------------
# Change ssh alias if kitty otherwise $TERM is unknown
if [ ! -n "$SSH_CLIENT" ]; then
	if [[ $TERM = xterm-kitty ]]; then
		alias ssh='kitten ssh'
		alias icat="kitten icat"
		alias hg="kitten hyperlinked-grep --smart-case --no-ignore --hidden --pretty"
	fi
fi
#-------------------------------------------------------------

#-------------------------------------------------------------
#   ____    _    _     _     ____
#  / ___|  / \  | |   | |   / ___|
# | |     / _ \ | |   | |   \___ \
# | |___ / ___ \| |___| |___ ___) |
#  \____/_/   \_\_____|_____|____/
#
#-------------------------------------------------------------

#-------------------------------------------------------------
# Automatically set up the custom 'cd' function : cd && ll
cdll
#-------------------------------------------------------------

#-------------------------------------------------------------
# Run welcome message at login
# Random
# welcome -s $(( RANDOM % 8 + 1 ))
# Fixed
welcome -s 8
#-------------------------------------------------------------
