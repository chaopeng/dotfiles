#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

###########################################################
# Keep This File Simple

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# source fils in ~/.config/bash/
for f in ~/.config/bash/*; do
	source $f
done

eval "$(starship init bash)"
