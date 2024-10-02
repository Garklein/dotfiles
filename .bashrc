# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

PS1='\e[0;31m[\u@\h \W]$\e[m '

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

. ~/.bash_aliases

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


path=(
	"/usr/local/sbin"
	"/usr/local/bin"
	"/usr/sbin"
	"/usr/bin"
	"/sbin"
	"/bin"
	"~/.bin"
	"~/programs/jdk-19.0.1/bin"
	"~/.ghcup/bin"
	"~/.nimble/bin"
	"~/.cargo/bin"
)
path=$(printf ":%s" "${path[@]}")
path=${path:1}
export PATH=$path
