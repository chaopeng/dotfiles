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
if [ -d "$HOME/.config/bash" ]; then
	for f in $HOME/.config/bash/*; do
		source $f
	done
fi

# add cargo paths
if [ -d "$HOME/.cargo" ]; then
	if [ -f "$HOME/.cargo/env" ]; then
    	. "$HOME/.cargo/env"
	fi
fi

# add $HOME/bin and $HOME/go/bin
export PATH="$HOME/bin:$HOME/go/bin:$PATH"

# add brew
if [ "$(uname)" = "Darwin" ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

eval "$(starship init bash)"
