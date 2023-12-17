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

# add cargo paths
. "$HOME/.cargo/env"

# add $HOME/bin and $HOME/go/bin
export PATH="$HOME/bin:$HOME/go/bin:$PATH"

# add macports
if [ "$(uname)" = "Darwin" ]; then
	export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
fi

eval "$(starship init bash)"
