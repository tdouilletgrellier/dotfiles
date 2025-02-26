#-------------------------------------------------------------
# List of packages to be installed
debian_apps=(
	# Essentials
	'git'        # Version controll
	'neovim'     # Text editor
	'ranger'     # Directory browser
	'tmux'       # Term multiplexer
	'terminator' # Terminal emulator
	'wget'       # Download files

	# CLI Power Basics
	'aria2'         # Resuming download util (better wget)
	'bat'           # Output highlighting (better cat)
	'broot'         # Interactive directory navigation
	'ctags'         # Indexing of file info + headers
	'diff-so-fancy' # Readable file compares (better diff)
	'grc'           # Colorized lots basic CLI tools
	'duf'           # Get info on mounted disks (better df)
	'eza'           # Listing files with info (better ls)
	'fd-find'       # Fuzzy file finder and filtering
	'fzf'           # Fuzzy file finder and filtering
	'hyperfine'     # Benchmarking for arbitrary commands
	'just'          # Powerful command runner (better make)
	'jq'            # JSON parser, output and query files
	'most'          # Multi-window scroll pager (better less)
	'procs'         # Advanced process viewer (better ps)
	'ripgrep'       # Searching within files (better grep)
	'scrot'         # Screenshots programmatically via CLI
	'sd'            # RegEx find and replace (better sed)
	'thefuck'       # Auto-correct miss-typed commands
	'tealdeer'      # Reader for command docs (better man)
	'tree'          # Directory listings as tree structure
	'tokei'         # Count lines of code (better cloc)
	'trash-cli'     # Record and restore removed files
	'xsel'          # Copy paste access to the X clipboard
	'zoxide'        # Auto-learning navigation (better cd)
	'delta'         # git-delta
	'lazygit'       # lazygit
	'micro'         # micro
	'tree-sitter'   # syntax hl
	'xdotools'      # keys
	'grc'           # color
	'zellij'        # term multiplexer
	'ble.sh'        # bash syntax hl
	'wmctrl'        # Window management

	# Languages, compilers, runtimes, etc
	'gcc'
	'g++'
	'gfortran'
	'python'
	'LateX'
	'zathura'

	# Monitoring, management and stats
	'bpytop'    # Live system resource monitoring
	'conky-all' # Command line speed test utility

	# CLI Fun
	'cowsay'   # Outputs message with ASCII art cow
	'figlet'   # Outputs text as 3D ASCII word art
	'lolcat'   # Rainbow colored terminal output
	'neofetch' # Show off distro and system info
)

#-------------------------------------------------------------
# Welcome message
BORING=true
# Print time-based personalized message, using figlet & lolcat if availible
function welcome_greeting() {
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
	if [[ $BORING = true ]]; then
		echo -e "$BRIGHT_GREEN${WELCOME_MSG}${RESET}\n"
	else
		if hascommand --strict lolcat && hascommand --strict figlet; then
			echo "${WELCOME_MSG}" | figlet | lolcat
		else
			echo -e "$BRIGHT_GREEN${WELCOME_MSG}${RESET}\n"
		fi
	fi
}

# Print system information with neofetch, if it's installed
function welcome_sysinfo() {
	if hascommand --strict fastfetch; then
		if [[ -f "${HOME}/.config/fastfetch/fastfetch.jsonc" ]]; then
			fastfetch --config ${HOME}/.config/fastfetch/fastfetch.jsonc
		else
			fastfetch --config archey
		fi
	else
		if hascommand --strict neofetch; then
			if [[ -f "${HOME}/.config/neofetch/neofetch.conf" ]]; then
				neofetch --config ${HOME}/.config/neofetch/neofetch.conf
			else
				neofetch --disable title separator underline bar gpu memory disk cpu users local_ip public_ip font wm_theme --os --host --kernel --uptime --packages --shell --resolution --de --wm --terminal
			fi
		fi
	fi
}

# Print todays info: Date, IP, weather, etc
function welcome_today() {
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
	if [[ $BORING = true ]]; then
		echo -e "${GREEN}⧗ ${formatted_last_login}${RESET}"
		echo -e "${GREEN}⏲ ${current_date}${RESET}"
		echo -e "${GREEN}⌂ ${host_info}${RESET}"
	else
		# Colorful version with cleaner variable expansion
		echo -e "${BRIGHT_GREEN}⧗${RESET} ${BRIGHT_GREEN}${formatted_last_login}"
		echo -e "${BRIGHT_YELLOW}⏲${RESET} ${BRIGHT_YELLOW}${current_date}"
		echo -e "${BRIGHT_RED}⌂${RESET} ${BRIGHT_RED}${host_info}"
	fi

	echo -e "${RESET}" # Reset colors at the end
}

function weather() {
	timeout=0.5
	curl -s -m $timeout "https://wttr.in?format=%cWeather:+%C+%t,+%p+%w"
	echo -e "${RESET}"
}

function display_fortune() {
	echo -e "${RESET}" # Reset colors once

	if hascommand --strict lolcat; then
		if [[ $BORING = true ]]; then
			[ -x /usr/games/fortune ] && echo -e "$GREEN$(/usr/games/fortune -s)${RESET}"
		else
			[ -x /usr/games/fortune ] && /usr/games/fortune -s | lolcat
		fi
	fi
}

function display_sparkbars() {
	echo -e "${RESET}" # Reset colors once

	if hascommand --strict lolcat; then
		if [[ $BORING = true ]]; then
			echo -e "$GREEN$(sparkbars)${RESET}"
		else
			sparkbars | lolcat
		fi
	else
		[[ -z "${TMUX}" ]] && echo -e "$GREEN$(sparkbars)${RESET}"
	fi
}

# Main welcome function
function welcome() {
	# Only run if in a login shell (SHLVL < 2)
	if [[ "${SHLVL}" -lt 2 ]]; then
		[[ -z "${TMUX}" || -n "$SSH_CLIENT" ]] && {
			clear
			printf '\e[3J'
		}
		# if hascommand --strict neofetch || hascommand --strict fastfetch; then
			# welcome_sysinfo
			# display_fortune
		# else
			welcome_greeting
			welcome_today
			# weather
			display_fortune
			# display_sparkbars
		# fi
	fi
}

# Run welcome message at login
welcome

#-------------------------------------------------------------

#-------------------------------------------------------------
# License file for ArmForge DDT (i think)
export LM_LICENSE_FILE=27000@noeyyr5y.noe.edf.fr
#-------------------------------------------------------------

#-------------------------------------------------------------
# EDF Proxy
function proxy() {
	export http_proxy='http://vip-users.proxy.edf.fr:3131/'
	export https_proxy='http://vip-users.proxy.edf.fr:3131/'
	export HTTP_PROXY='http://vip-users.proxy.edf.fr:3131/'
	export HTTPS_PROXY='http://vip-users.proxy.edf.fr:3131/'
	export no_proxy='localhost,127.0.0.1,.edf.fr,.edf.com'
	curl --silent --proxy-negotiate --user : http://www.gstatic.com/generate_204
}
function unset_proxy() {
	unset http_proxy
	unset https_proxy
	unset HTTP_PROXY
	unset HTTPS_PROXY
	unset no_proxy
	git config --global --unset-all https.proxy
	git config --global --unset-all http.proxy
	git config --global --unset-all http.https://github.com.proxy
	git config --global --unset-all http.https://codev-tuleap.cea.fr.proxy
	git config --global --unset-all http.https://codev-tuleap.cea.fr.proxy
	git config --global -l | grep proxy
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# EDF Load Intel
function load_intel() {

	if [ $(which ifort) ]; then
		echo "Intel local installation is loaded..."
		echo $(which ifort)
		echo $(which icc)
	elif [ -d /projets/europlexus ]; then
		module load ifort/2018.1.038 icc/2018.1.038 mkl/2018.1.038 impi/2018.1.038
	elif [ -d /software/restricted ]; then
		module load intel/2023
	elif [ $INTEL_INSTALL_DIR ]; then
		module use --append $(find $INTEL_INSTALL_DIR -name modulefiles)
		module load icc mkl mpi
	elif [ -d /opt/intel ]; then
		module use --append $(find /opt/intel -name modulefiles)
		module load icc mkl mpi
	else
		echo "Intel compilation and runtime are only available on the calculation clusters"
		echo "Please use the gnu version..."
		return 4
	fi
	return 0
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Fuck
function fuck() {
	TF_PYTHONIOENCODING=$PYTHONIOENCODING
	export TF_SHELL=bash
	export TF_ALIAS=fuck
	export TF_SHELL_ALIASES=$(alias)
	export TF_HISTORY=$(fc -ln -10)
	export PYTHONIOENCODING=utf-8
	TF_CMD=$(
		thefuck THEFUCK_ARGUMENT_PLACEHOLDER "$@"
	) && eval "$TF_CMD"
	unset TF_HISTORY
	export PYTHONIOENCODING=$TF_PYTHONIOENCODING
	history -s $TF_CMD
}
alias fk='fuck'
#-------------------------------------------------------------

#-------------------------------------------------------------
# cd with immediate ll afterwards
if hascommand --strict zoxide; then
	# Issues with zoxide and tmux
	if [ -z "${TMUX}" ]; then
		# echo "not in tmux"
		cd() {
			z "$@"
			ls
		} # Always list directory contents upon 'cd'
	else
		# echo "in tmux"
		cd() {
			builtin cd "$@"
			ls
		} # Always list directory contents upon 'cd'
	fi
else
	cd() {
		builtin cd "$@"
		ls
	} # Always list directory contents upon 'cd'
fi
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
if [[ -f "${HOME}/dev/manta/devtools/env.sh" ]]; then
	function mantaenv { source "${HOME}/dev/manta/devtools/env.sh"; }
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
#-------------------------------------------------------------

#-------------------------------------------------------------
# Exit message
function _exit() { # Function to run upon exit of shell.
	#echo -e "${BRIGHT_RED}Hasta la vista, baby${RESET}"
	echo -e '\e[m'
	echo -e "${BRIGHT_RED}So long Space Cowboy...${RESET}"
	echo -e '\e[m'
	echo -e "$BRIGHT_RED$(sparkbars)${RESET}"
	echo -e '\e[m'
}
# If not running in nested shell, then show exit message :)
if [[ "${SHLVL}" -lt 2 ]]; then
	trap _exit EXIT
fi
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

# Path prepend
pathprepend "/opt/nvim/bin/" "${HOME}/CASTEM2022/bin" "/opt/cmake/bin" "/opt/tmux/"

#-------------------------------------------------------------
# Sync with cronos to back up my data
function sync2ssh() {
	if ! hascommand --strict rsync; then
		echo -e "${BRIGHT_RED}Error:${RESET} rsync is not installed or not in the PATH."
		return 1
	fi

	# Show help if no arguments or first argument isn't push/pull
	if [ $# -eq 0 ] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then

		echo -e "${BRIGHT_WHITE}sync2ssh:${RESET} Synchronize files between local and remote systems using rsync"
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
# Fancy clear
# if [[ -f "${HOME}/dotfiles/config/ExtremeUltimateBashrc/bashrc.d/clear_color_spark" ]]; then
# source ${HOME}/dotfiles/config/ExtremeUltimateBashrc/bashrc.d/clear_color_spark
# fi
# TTY Terminal colors
# if [[ -f "${HOME}/dotfiles/config/ExtremeUltimateBashrc/bashrc.d/tty_terminal_color_scheme" ]]; then
# 	source ${HOME}/dotfiles/config/ExtremeUltimateBashrc/bashrc.d/tty_terminal_color_scheme
# fi
#-------------------------------------------------------------

#-------------------------------------------------------------
# Reduce pdf size with gs
function compresspdf() {
	if ! hascommand --strict gs; then
		echo -e "${BRIGHT_RED}Error:${RESET} Ghostscript (gs) is not installed or not in the PATH."
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
		--sudo) SUDO_PREFIX="sudo " ;;
		--case-sensitive) case_sensitive=1 ;;
		--no-hidden) hidden_files=0 ;;
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
		echo -e "  ${BRIGHT_GREEN}--sudo${RESET}          Run with elevated permissions"
		echo -e "  ${BRIGHT_GREEN}--case-sensitive${RESET}  Perform case-sensitive search"
		echo -e "  ${BRIGHT_GREEN}--no-hidden${RESET}      Ignore hidden files and directories"
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
		--sudo) SUDO_PREFIX="sudo " ;;
		--case-sensitive) case_sensitive=1 ;;
		--no-hidden) hidden_files=0 ;;
		--show-match) show_match=1 ;;
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
		echo -e "  ${BRIGHT_GREEN}--sudo${RESET}          Run with elevated permissions"
		echo -e "  ${BRIGHT_GREEN}--case-sensitive${RESET}  Perform case-sensitive search"
		echo -e "  ${BRIGHT_GREEN}--no-hidden${RESET}      Ignore hidden files and directories"
		echo -e "  ${BRIGHT_GREEN}--show-match${RESET}      Show all pattern matches"
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

#--------------------------------------------------------
