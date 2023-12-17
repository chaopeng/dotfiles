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
	. "$HOME/.cargo/env"
fi

# add $HOME/bin and $HOME/go/bin
export PATH="$HOME/bin:$HOME/go/bin:$PATH"

# add macports
if [ "$(uname)" = "Darwin" ]; then
	export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
fi

eval "$(starship init bash)"
