clear && printf '\e[3J'
#source ~/dev/epx/devtools/env.sh
#clear && printf '\e[3J'
#echo "
#┌─────────────────────────────────────────────────────┐
#│   _____   _____     ____    _   _    ____     _____ │
#│  / ____| |  __ \   / __ \  | \ | |  / __ \   / ____|│
#│ | |      | |__) | | |  | | |  \| | | |  | | | (___  │
#│ | |      |  _  /  | |  | | | .   | | |  | |  \___ \ │
#│ | |____  | | \ \  | |__| | | |\  | | |__| |  ____) |│
#│  \_____| |_|  \_\  \____/  |_| \_|  \____/  |_____/ │
#│                                                     │
#│                                                     │
#└─────────────────────────────────────────────────────┘"

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
#force_color_prompt=yes

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

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -al'
alias la='ls -A'
alias l='ls -CF'
alias cp='cp -i'
alias mv='mv -i'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
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

export PATH='/home/f66379/CASTEM2019/bin':$PATH #GENERATED-BY-IZPACK-CAST3M19
export LM_LICENSE_FILE=27000@noeyyr5y.noe.edf.fr


function proxy(){
    /usr/bin/edf-proxy-cli.py
    export http_proxy='http://vip-users.proxy.edf.fr:3128'
    export ftp_proxy=$http_proxy
    export https_proxy=$http_proxy
    export HTTP_PROXY=$http_proxy
    export FTP_PROXY=$http_proxy
    export HTTPS_PROXY=$http_proxy
    export no_proxy='*.edf.fr'
    export NO_PROXY='*.edf.fr'
}

export PATH=/home/f66379/.local/bin:$PATH
export PYTHONPATH=/home/f66379/.local/lib/python3.5/site-packages:$PYTHONPATH




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
