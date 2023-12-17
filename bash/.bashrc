#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

###########################################################
# Keep This File Simple

alias ls='ls --color=auto'
alias grep='grep --color=auto'

eval "$(~/.cargo/bin/starship init bash)"

