




source ~/dev/epx/devtools/env.sh
clear && printf '\e[3J'

echo -e '\e[1;32m'

toilet -Wf big F66379 --filter border --export utf8

echo -e '\e[m'

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

    # export PS1="________________________________________________________________________________\n| \w @ \h (\u) \n| => "
    # export PS2="| => "

    # export PS1="[\w]\n\u@\h>"

    #alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# For Dark Theme in Okular
export QT_QPA_PLATFORMTHEME=gtk2

# some more ls aliases
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
#alias ll='ls -al'
alias="eza --long --icons --git -all"
alias la='ls -A'
alias l='ls -CF'
alias cp='cp -i'
alias mv='mv -i'
# alias paraview='/home/f66379/paraview/bin/paraview -style=fusion -stylesheet=/home/f66379/paraview/dark.qss &'
alias paraview='/home/f66379/paraview/bin/paraview &'
#alias kdiff3='/home/f66379/Downloads/kdiff3-0.9.98/kdiff3-0.9.98/releaseQt/kdiff3 &'
alias dodo='systemctl suspend -i'
alias qfind="find . -name "                 # qfind:    Quickly search for file
alias ffind="find / -name "           # qfind:    Quickly search for file
alias ufind="find ~ -name "                 # qfind:    Quickly search for file
alias reload="source ~/.bashrc"
alias epxenv="source ~/dev/epx/devtools/env.sh"
alias pulse="/usr/local/pulse/pulsesvc -K"
alias ddt="/home/f66379/arm/forge/22.1.2/bin/ddt &"
alias vim="nvim"
alias vi="nvim"
eval "$(zoxide init bash)"
# eval "$(zoxide init --cmd cd bash)"
# alias cd="z"
alias fd="fdfind"
alias cat="batcat"
export BAT_THEME=DarkNeon
export FZF_DEFAULT_COMMAND="fdfind --hidden --exclude .git"
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_ALT_C_COMMAND="fdfind --type=d --hidden --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fdfind --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fdfind --type=d --hidden --exclude .git . "$1"
}

# --- setup fzf theme ---
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#26ff00,fg+:#2fff00,bg:#000000,bg+:#000000
  --color=hl:#0080ff,hl+:#00bfff,info:#afaf87,marker:#e2d705
  --color=prompt:#d60000,spinner:#8000ff,pointer:#8000ff,header:#87afaf
  --color=border:#262626,label:#aeaeae,query:#d9d9d9
  --border="rounded" --border-label="" --preview-window="border-rounded" --prompt="> "
  --marker=">" --pointer="◆" --separator="─" --scrollbar="│"'

source ~/fzf-git.sh/fzf-git.sh

_fzf_git_fzf() {
  fzf-tmux --ansi -p80%,60% -- \
    --layout=reverse --multi --height=50% --min-height=20 --border \
    --border-label-pos=2 \
    --color='header:italic:underline,label:blue' \
    --preview-window='right,50%,border-left' \
    --bind='ctrl-/:change-preview-window(down,50%,border-top|hidden|)' "$@"
}

export EZA_COLORS=$LS_COLORS

#export PATH=/home/f66379/.local/bin:$PATH

function proxy_old(){
    /usr/bin/edf-proxy-cli.py
    expect 'Login Sesame:'
    send 'F66379'
    expect 'Mot de passe Sesame:'
    send 'mgs0lid\044sn4ke'
    export http_proxy='http://vip-users.proxy.edf.fr:3128'
    export ftp_proxy=$http_proxy
    export https_proxy=$http_proxy
    export HTTP_PROXY=$http_proxy
    export FTP_PROXY=$http_proxy
    export HTTPS_PROXY=$http_proxy
    export no_proxy='*.edf.fr'
    export NO_PROXY='*.edf.fr'
}

function proxy(){
     export http_proxy='http://vip-users.proxy.edf.fr:3131/'
     export https_proxy='http://vip-users.proxy.edf.fr:3131/'
     export HTTP_PROXY='http://vip-users.proxy.edf.fr:3131/'
     export HTTPS_PROXY='http://vip-users.proxy.edf.fr:3131/'
     export no_proxy='localhost,127.0.0.1,.edf.fr,.edf.com'
     curl --silent --proxy-negotiate --user : http://www.gstatic.com/generate_204
}


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ./.bash_aliases ]; then
    . ./.bash_aliases
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export LM_LICENSE_FILE=27000@noeyyr5y.noe.edf.fr


#export PATH=/home/f66379/.local/bin:$PATH
#export PYTHONPATH=/home/f66379/.local/lib/python3.5/site-packages:$PYTHONPATH




# Find a file with a pattern in name - dans le rep local:
function ff() { find . -type f -iname '*'$*'*' -ls ; }

# Find a file with a pattern in name - dans /:
function ffslash() { sudo find / -type f -iname '*'$*'*' -ls ; }

#n'a pas l air de fonctionner... ?
function fstr() # find a string in a set of files localement
{
    if [ "$#" -gt 2 ]; then
       echo "Usage: fstr \"pattern\" [files] "
       return;
    fi
    SMSO=$(tput smso)
    RMSO=$(tput rmso)
    find . -type f -name "${2:-*}" -print | xargs grep -sin "$1" | \
    sed "s/$1/$SMSO$1$RMSO/gI"
}


#n'a pas l air de fonctionner... ?
function fstrslash() # find a string in a set of files de /
{
    if [ "$#" -gt 2 ]; then
       echo "Usage: fstr \"pattern\" [files] "
       return;
    fi
    SMSO=$(tput smso)
    RMSO=$(tput rmso)
    sudo find / -type f -name "${2:-*}" -print | xargs grep -sin "$1" | sed "s/$1/$SMSO$1$RMSO/gI"
}

# repeat n times command
function repeat()       
{
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do
        eval "$@";
    done
}


#liste les alias et functions
function listba(){
cat .bashrc|egrep "alias|function"|grep -v "^#"|most
}

#Cree le repertoire et va dedans
function mkcd() {
mkdir $1 && cd $1
}


function killps()       # Kill process by name
{                       # works with gawk too
    local pid pname sig="-TERM" # default signal
    if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
        echo "Usage: killps [-SIGNAL] pattern"
        return;
    fi
    if [ $# = 2 ]; then sig=$1 ; fi
    for pid in $(my_ps | nawk '!/nawk/ && $0~pat { print $2 }' pat=${!#}) ; do
        pname=$(my_ps | nawk '$2~var { print $6 }' var=$pid )
        if ask "Kill process $pid <$pname> with signal $sig ? "
            then kill $sig $pid
        fi
    done
}


function load_intel(){

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




export PATH='/home/f66379/CASTEM2022/bin':$PATH #GENERATED-BY-IZPACK-CAST3M22
export PATH='/opt/cmake/bin':$PATH #GENERATED-BY-IZPACK-CAST3M22
#export LC_ALL=en_US.UTF-8
# Adapted from https://unix.stackexchange.com/a/113768/347104
#if [ -n "$PS1" ] && [ -z "$TMUX" ]; then
#  # Adapted from https://unix.stackexchange.com/a/176885/347104
#  # Create session 'main' or attach to 'main' if already exists.
#  tmux new-session -A -s main
#fi

#rsync -ravP ~/Documents/ f66379@cronos.hpc.edf.fr:/home/f66379/f66379/
#
            function fuck () {
                TF_PYTHONIOENCODING=$PYTHONIOENCODING;
                export TF_SHELL=bash;
                export TF_ALIAS=fuck;
                export TF_SHELL_ALIASES=$(alias);
                export TF_HISTORY=$(fc -ln -10);
                export PYTHONIOENCODING=utf-8;
                TF_CMD=$(
                    thefuck THEFUCK_ARGUMENT_PLACEHOLDER "$@"
                ) && eval "$TF_CMD";
                unset TF_HISTORY;
                export PYTHONIOENCODING=$TF_PYTHONIOENCODING;
                history -s $TF_CMD;
            }
alias fk='fuck'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash


lg()
{
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}
