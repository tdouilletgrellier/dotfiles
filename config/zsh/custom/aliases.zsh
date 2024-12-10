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
# cd with immediate ll afterwards
if  (( $+commands[zoxide] )); then
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
# if [[ -f "${HOME}/dev/epx/devtools/env.sh" ]]; then
# 	alias epxenv="source ${HOME}/dev/epx/devtools/env.sh"
# 	if [[ "${SHLVL}" -lt 2 ]]; then
# 		if [ -z "${TMUX}" ]; then
# 			epxenv 1>/dev/null
# 		fi
# 	fi
# fi
if [[ -f "${HOME}/arm/forge/22.1.2/bin/ddt" ]]; then
	alias ddt="${HOME}/arm/forge/22.1.2/bin/ddt &"
fi
alias c='clear'         # c:            Clear terminal display
alias which='type -all' # which:        Find executables
if  (( $+commands[eza] )); then
	_EZA_COMMON_FLAGS="--all --classify --color=auto --color-scale=all --icons=auto"
	_EZA_LONG_FLAGS="${_EZA_COMMON_FLAGS} --group-directories-first --long --links --smart-group --modified"	
	alias ls="eza ${_EZA_COMMON_FLAGS} --group-directories-first"
	alias labc="eza ${_EZA_COMMON_FLAGS} --grid --sort name"
	alias ll="eza ${_EZA_LONG_FLAGS}"	
	alias ldir="eza -lD"
	alias lfile="eza -lf --color=always | grep -v /"
	alias lsh="eza ${_EZA_COMMON_FLAGS} --group-directories-first --hyperlink"
	alias llh="eza ${_EZA_LONG_FLAGS} --hyperlink"
fi
if  (( $+commands[nvim] ));  then
	alias v='nvim'
	alias vi='nvim'
	alias vim='nvim'
	alias svi='sudo nvim'
	alias vis='nvim "+set si"'
elif  (( $+commands[vim] ));  then
	alias v='vim'
	alias vi='vim'
	alias svi='sudo vim'
	alias vis='vim "+set si"'
elif  (( $+commands[vi] ));  then
	alias v='vi'
	alias svi='sudo vi'
fi
if  (( $+commands[batcat] ));  then
	alias bat='batcat --color=always'
fi
if  (( $+commands[bat] ));  then
	alias bat='bat --color=always'
fi
#-------------------------------------------------------------

#-------------------------------------------------------------
# Bat theme
export BAT_THEME=base16
export BAT_STYLE=plain
#-------------------------------------------------------------

#-------------------------------------------------------------
# Fzf config
if (( $+commands[fzf] )); then
	if (( $+commands[fdfind] )); then
		export FZF_DEFAULT_COMMAND="fdfind --hidden --exclude '.git'"
	elif (( $+commands[fd] )); then
		export FZF_DEFAULT_COMMAND="fd --hidden --exclude '.git'"
	fi
	if (( $+commands[bat] )); then
		export FZF_PREVIEW_COMMAND_FILE='bat -n --color=always -r :500 {}'
	elif (( $+commands[batcat] )); then
		export FZF_PREVIEW_COMMAND_FILE='batcat -n --color=always -r :500 {}'
	else
		export FZF_PREVIEW_COMMAND_FILE='cat -n {}'
	fi
	if (( $+commands[eza] )); then
		export FZF_PREVIEW_COMMAND_DIR='eza --tree --level 1 --color=always --icons {}'
	else
		export FZF_PREVIEW_COMMAND_DIR='tree -C {}'
	fi
	if [[ $TERM = xterm-kitty ]]; then
		export FZF_PREVIEW_COMMAND_IMG='kitty icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {}'
		# export FZF_PREVIEW_COMMAND_IMG_CLEAR='printf "\x1b_Ga=d,d=A\x1b\\" &&'
		export FZF_PREVIEW_COMMAND_IMG_CLEAR=""
	else
		export FZF_PREVIEW_COMMAND_IMG='echo image: {}'
		export FZF_PREVIEW_COMMAND_IMG_CLEAR=""
	fi
	export FZF_PREVIEW_COMMAND_DEFAULT='echo {}'
	export FZF_PREVIEW_COMMAND_FILE=' '${FZF_PREVIEW_COMMAND_IMG_CLEAR}' [[ $(file --mime {}) =~ image ]] && '${FZF_PREVIEW_COMMAND_IMG}' || ([[ $(file --mime {}) =~ binary ]] && '${FZF_PREVIEW_COMMAND_DEFAULT}'is binary file  || '${FZF_PREVIEW_COMMAND_FILE}')'
	# export FZF_PREVIEW_COMMAND='[[ $(file --mime {}) =~ directory ]] && '${FZF_PREVIEW_COMMAND_DIR}' || ([[ $(file --mime {}) =~ binary ]] && '${FZF_PREVIEW_COMMAND_DEFAULT}'is binary file  || '${FZF_PREVIEW_COMMAND_FILE}')'
	export FZF_PREVIEW_COMMAND='('${FZF_PREVIEW_COMMAND_IMG}' || '${FZF_PREVIEW_COMMAND_FILE}' || '${FZF_PREVIEW_COMMAND_DIR}' || '${FZF_PREVIEW_COMMAND_DEFAULT}') 2> /dev/null'
	export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND} --type f"
	export FZF_CTRL_T_OPTS="
  	--walker-skip .git,node_modules,target
  	--preview '${FZF_PREVIEW_COMMAND_FILE}'
  	--preview-window 'right:60%:wrap'
  	--bind 'ctrl-/:change-preview-window(right|hidden|)'
  	--bind 'ctrl-u:preview-half-page-up'
  	--bind 'ctrl-d:preview-half-page-down'
  	--bind 'ctrl-x:reload("$FZF_CTRL_T_COMMAND")'
  	--bind 'ctrl-w:reload("$FZF_CTRL_T_COMMAND" --max-depth 1)'"
	export FZF_ALT_C_COMMAND="${FZF_DEFAULT_COMMAND} --type d"
	export FZF_ALT_C_OPTS="
  	--walker-skip .git,node_modules,target
  	--preview '${FZF_PREVIEW_COMMAND_DIR}'
  	--preview-window 'right:60%:wrap'
  	--bind 'ctrl-/:change-preview-window(right|hidden|)'
  	--bind 'ctrl-u:preview-half-page-up'
  	--bind 'ctrl-d:preview-half-page-down'
  	--bind 'ctrl-x:reload("$FZF_ALT_C_COMMAND")'
  	--bind 'ctrl-w:reload("$FZF_ALT_C_COMMAND" --max-depth 1)'"
	export FZF_CTRL_R_OPTS="
	--preview 'echo {}' --preview-window down:3:hidden:wrap
	--bind 'ctrl-/:toggle-preview'"
	export FZF_DEFAULT_OPTS=""
	# --- setup fzf theme ---
	export FZF_DEFAULT_OPTS=${FZF_DEFAULT_OPTS}'
 	--color=fg:#79ff0f,fg+:#66ff66,bg:#000000,bg+:#2a2a2a
 	--color=hl:#386bd7,hl+:#66ccff,info:#f3d64e,marker:#e7bf00
  	--color=prompt:#cd0000,spinner:#db67e6,pointer:#b349be,header:#87afaf
  	--color=border:#2a2a2a,label:#666666,query:#bbbbbb
  	--color header:italic'
	# --- setup fzf default options ---
	export FZF_DEFAULT_OPTS=${FZF_DEFAULT_OPTS}'
	--border="rounded" --border-label=""
	--prompt="❯ " --pointer="◆" --marker="✓ "'
fi
#-------------------------------------------------------------

#-------------------------------------------------------------
# Change ssh alias if kitty otherwise $TERM is unknown
if [[ $TERM = xterm-kitty ]]; then
	alias ssh='kitten ssh'
	alias icat="kitten icat"
	alias hg="kitten hyperlinked-grep"
fi
#-------------------------------------------------------------

# Path prepend
add_to_path() {
    for dir in "$@"; do
        [[ ":$PATH:" != *":$dir:"* ]] && export PATH="$dir:$PATH"
    done
}
add_to_path /opt/nvim/bin ~/CASTEM2022/bin /opt/cmake/bin /opt/tmux
