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
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cdh='cd ${HOME}'

# tmux
alias tmux='tmux -u'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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

# nvcc
export PATH=$PATH:/usr/local/cuda/bin

export DOTFILES_ROOT="$HOME/dotfiles"
export MYPLUGIN_ROOT="$DOTFILES_ROOT/plugins"


# pyenv / virtualenv installation
if [ ! -d ~/.pyenv ]; then
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv
fi

export PYENV_ROOT="$HOME/.pyenv"

if [ -d ~/.pyenv ]; then
  if [ ! -d "${PYENV_ROOT}/plugins/pyenv-virtualenv" ]; then
    git clone https://github.com/pyenv/pyenv-virtualenv.git "${PYENV_ROOT}/plugins/pyenv-virtualenv"
  fi
fi

# pyenv /virtualenv activation
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# fzf installation
if [ ! -d ~/.fzf ]; then
  git clone https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [ ! -d ~/.fzy ]; then
    git clone https://github.com/jhawthorn/fzy ~/.fzy
    cd ~/.fzy
    make
    cd ${HOME}
fi
export PATH=$PATH:${HOME}/.fzy


# get git branch info
function git_branch {
    local branch_name="$(git symbolic-ref --short HEAD 2>/dev/null)"
    if [ -n "$branch_name" ]; then
        echo " ($branch_name)"
    fi
}

function pyenv_version {
    local version_name="$(pyenv version-name 2>/dev/null)"
    if [ -n "$version_name" ]; then
        echo -e "\[\e[48;5;6m\] [pyenv : $version_name] \[\e[m\]"
    fi
}

# terminal design
# Output user
NAME="\[\e[1;37;42m\]"
HOST="\[\e[1;40m\]"
DIR="\[\e[0;30;47m\]"
END="\[\e[m\]"
TIME="\[\e[1;90;107m\]"

# export PS1="${NAME} \u ${HOST} @\h ${DIR} \w ${TIME} \t ${END}\$(git_branch) \n > "

# ls and ll
alias ls='ls -G --color'
alias ll='ls -laGh'

# Color ls
LS_COLORS='no=0:ow=41:di=7:fi=0:ln=105:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=01;31:*.md=96'
export LS_COLORS

# Break after output
# function prompt {
#     if [[ -z "${PS1_NEWLINE_LOGIN}" ]]; then
#         PS1_NEWLINE_LOGIN=true
#     else
#         printf '\n'
#     fi
#     export PS1="${NAME} \u ${HOST} @\h ${DIR} \w ${TIME} \t ${END}\$(git_branch) \n > "
#     PS1="$(pyenv_version)${PS1}"
# }

# PROMPT_COMMAND='prompt'
