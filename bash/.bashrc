#
# ~/.bashrc
#

###########################################################
# Environment & PATH modifications (All shells)

# Path modifications
if [ -d "$HOME/.cargo" ]; then
  if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
  fi
fi

if [ -d "$HOME/go/bin" ]; then
  export PATH="$HOME/go/bin:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$PATH"
fi

if [ "$(uname)" = "Darwin" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export NVM_DIR="$HOME/.config/nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh" # This loads nvm
fi

# Source files in ~/.config/bash/ (e.g. linux.bashrc)
if [ -d "$HOME/.config/bash" ]; then
  for f in $HOME/.config/bash/*; do
    source "$f"
  done
fi

###########################################################
# Return early if not running interactively
[[ $- != *i* ]] && return

###########################################################
# Interactive Shell Setup Only

alias ls='ls --color=auto'
alias grep='grep --color=auto'

if [ -s "$NVM_DIR/bash_completion" ]; then
  source "$NVM_DIR/bash_completion" # This loads nvm bash_completion
fi

eval "$(starship init bash)"
