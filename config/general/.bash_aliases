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
	'wmctrl'        # Window management

	# Languages, compilers, runtimes, etc
	'gcc'
	'g++'
	'gfortran'
	'python'

	# Monitoring, management and stats
	'btop'          # Live system resource monitoring
	'bpytop'        # Live system resource monitoring
	'bmon'          # Bandwidth utilization monitor
	'ctop'          # Container metrics and monitoring
	'gping'         # Interactive ping tool, with graph
	'glances'       # Resource monitor + web and API
	'goaccess'      # Web log analyzer and viewer
	'speedtest-cli' # Command line speed test utility

	# CLI Fun
	'cowsay'   # Outputs message with ASCII art cow
	'figlet'   # Outputs text as 3D ASCII word art
	'lolcat'   # Rainbow colored terminal output
	'neofetch' # Show off distro and system info
)

#-------------------------------------------------------------
# Welcome message
# Formatting variables
COLOR_P='\033[1;36m'
COLOR_S='\033[0;36m'
RESET='\033[0m'

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
	if hash lolcat 2>/dev/null && hash figlet 2>/dev/null; then
		echo "${WELCOME_MSG}" | figlet | lolcat
	else
		echo -e "$COLOR_P${WELCOME_MSG}${RESET}\n"
	fi
}

# Print system information with neofetch, if it's installed
function welcome_sysinfo() {
	if hash neofetch 2>/dev/null; then
		neofetch --shell_version off \
			--disable kernel distro shell resolution de wm wm_theme theme icons term packages gpu \
			--backend off \
			--colors 4 8 4 4 8 6 \
			--color_blocks off \
			--memory_display info
	fi
}

# Print todays info: Date, IP, weather, etc
function welcome_today() {
	timeout=0.5
	#echo -e "\033[1;34mToday\n------"

	# Print last login in the format: "Last Login: Day Month Date HH:MM on tty"
	last_login=$(last | grep "^$USER " | head -1 | awk '{print "⏲️  Last Login: "$4" "$5" "$6" "$7" on "$2}')
	echo -e "${COLOR_S}${last_login}"

	# Print date time
	echo -e "$COLOR_S$(date '+🗓️  Date: %A, %B %d, %Y at %H:%M')"

	# Print local weather
	curl -s -m $timeout "https://wttr.in?format=%cWeather:+%C+%t,+%p+%w"
	# proxy && curl -s -m $timeout "https://wttr.in?format=%cWeather:+%C+%t,+%p+%w"
	echo -e "${RESET}"

	# Print IP address (quite slow so commented)
	# if hash ip 2>/dev/null; then
	#   ip_address=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
	#   ip_interface=$(ip route get 8.8.8.8 | awk -F"dev " 'NR==1{split($2,a," ");print a[1]}')
	#   echo -e "${COLOR_S}🌐 IP: $(curl -s -m $timeout 'https://ipinfo.io/ip') (${ip_address} on ${ip_interface})"
	#   echo -e "${RESET}\n"
	# fi
}

# Putting it all together
function welcome() {
	welcome_greeting
	# welcome_sysinfo
	welcome_today
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# License file for something (what ?)
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
		module load intel/2020
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
if cmd-exists --strict zoxide; then
	eval "$(zoxide init bash)"
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
fi
if [[ -f "${HOME}/dev/epx/devtools/env.sh" ]]; then
	alias epxenv="source ${HOME}/dev/epx/devtools/env.sh"
	epxenv
fi
if [[ -f "${HOME}/arm/forge/22.1.2/bin/ddt" ]]; then
	alias ddt="${HOME}/arm/forge/22.1.2/bin/ddt &"
fi
alias weather="proxy && curl wttr.in/?F"
alias c='clear'         # c:            Clear terminal display
alias which='type -all' # which:        Find executables
if cmd-exists eza; then
	unalias ldir
	alias ldir="eza -lD"
	unalias lfile
	alias lfile="eza -lf --color=always | grep -v /"
fi
if cmd-exists --strict nvim; then
	alias {v,vi,vim}='nvim'
	alias svi='sudo nvim'
	alias vis='nvim "+set si"'
elif cmd-exists --strict vim; then
	alias {v,vi}='vim'
	alias svi='sudo vim'
	alias vis='vim "+set si"'
elif cmd-exists --strict vi; then
	alias v='vi'
	alias svi='sudo vi'
fi
if cmd-exists --strict batcat; then
	alias bat='batcat --decorations=always --color=always'
fi
#-------------------------------------------------------------

#-------------------------------------------------------------
# Exit message
BRed='\e[1;31m'    # Red
NC="\e[m"          # Normal color
function _exit() { # Function to run upon exit of shell.
	#echo -e "${BRed}Hasta la vista, baby${NC}"
	echo -e '\e[m'
	echo -e "${BRed}So long Space Cowboy...${NC}"
	echo -e '\e[m'
	echo -e "$BRed$(sparkbars)${NC}"
	echo -e '\e[m'
}
# If not running in nested shell, then show exit message :)
if [[ "${SHLVL}" -lt 2 ]]; then
	trap _exit EXIT
fi
#-------------------------------------------------------------

#-------------------------------------------------------------
# Welcome message
# If not running in nested shell, then show welcome message :)
if [[ "${SHLVL}" -lt 2 ]]; then
	if [ -n "$SSH_CLIENT" ]; then
		if [ -z "${TMUX}" ]; then
			clear && printf '\e[3J'
		else
			printf '\e[3J'
		fi
	else
		echo "no ssh"
		clear && printf '\e[3J'
	fi
	welcome
	# Fortune message
	if cmd-exists --strict lolcat; then
		if [ -x /usr/games/fortune ]; then
			echo -e '\e[m'
			/usr/games/fortune -s | lolcat # Makes our day a bit more fun.... :-)
			echo -e '\e[m'
			sparkbars | lolcat
		fi
	else
		if [ -z "${TMUX}" ]; then
			echo -e '\e[m'
			echo -e "$COLOR_S$(sparkbars)${NC}"
		fi
	fi
fi
#-------------------------------------------------------------

#-------------------------------------------------------------
# Some formatting
export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTIGNORE="&:bg:fg:ll:h"
export HISTTIMEFORMAT="$(echo -e ${BCyan})[%d/%m %H:%M:%S]$(echo -e ${NC}) "
export HISTCONTROL=ignoredups
export HOSTFILE=$HOME/.hosts # Put a list of remote hosts in ~/.hosts
#-------------------------------------------------------------

#-------------------------------------------------------------
# Bat theme
export BAT_THEME=DarkNeon
#-------------------------------------------------------------

#-------------------------------------------------------------
# Default editor in ranger
export SELECTED_EDITOR=$EDITOR
#-------------------------------------------------------------

#-------------------------------------------------------------
# Fzf config
export FZF_DEFAULT_COMMAND="fdfind --hidden --exclude .git"
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_ALT_C_COMMAND="fdfind --type=d --hidden --exclude .git"
# --- setup fzf theme ---
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#79ff0f,fg+:#66ff66,bg:#000000,bg+:#000000
  --color=hl:#386bd7,hl+:#66ccff,info:#f3d64e,marker:#e7bf00
  --color=prompt:#cd0000,spinner:#db67e6,pointer:#b349be,header:#87afaf
  --color=border:#2a2a2a,label:#666666,query:#bbbbbb
  --border="rounded" --border-label="" --preview-window="border-rounded" --prompt="> "
  --marker=">" --pointer="◆" --separator="─" --scrollbar="│"'
#-------------------------------------------------------------

#-------------------------------------------------------------
# Fzf+fdfind
# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
_fzf_compgen_path() {
	fdfind --hidden --exclude .git . "$1"
}
_fzf_compgen_dir() {
	fdfind --type=d --hidden --exclude .git . "$1"
}
#-------------------------------------------------------------

#-------------------------------------------------------------
# Fzf-git
if [[ -f "$HOME/dotfiles/config/fzf-git/fzf-git.sh" ]]; then
	source "$HOME/dotfiles/config/fzf-git/fzf-git.sh"
	_fzf_git_fzf() {
		fzf-tmux --ansi -p80%,60% -- \
			--layout=reverse --multi --height=50% --min-height=20 --border \
			--border-label-pos=2 \
			--color='header:italic:underline,label:blue' \
			--preview-window='right,50%,border-left' \
			--bind='ctrl-/:change-preview-window(down,50%,border-top|hidden|)' "$@"
	}
fi
#-------------------------------------------------------------

#-------------------------------------------------------------
# Sync with cronos to back up my data
#rsync -ravP ~/Documents/ ${USER}@cronos.hpc.edf.fr:${HOME}/${USER}/
#-------------------------------------------------------------

#-------------------------------------------------------------
# Fancy clear
# if [[ -f "${HOME}/dotfiles/config/ExtremeUltimateBashrc/bashrc.d/clear_color_spark" ]]; then
# source ${HOME}/dotfiles/config/ExtremeUltimateBashrc/bashrc.d/clear_color_spark
# fi
# TTY Terminal colors
if [[ -f "${HOME}/dotfiles/config/ExtremeUltimateBashrc/bashrc.d/clear_color_spark/tty_terminal_color_scheme" ]]; then
	source ${HOME}/dotfiles/config/ExtremeUltimateBashrc/bashrc.d/clear_color_spark/tty_terminal_color_scheme
fi
#-------------------------------------------------------------

