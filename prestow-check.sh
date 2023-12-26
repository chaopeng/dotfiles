#!/bin/bash

############################################################
# Pre Stow Check
# before stow, we need to ensure:
#
# - ~/.config/fish exists
# - ~/.config/kitty exists
# - ~/.config/git exists
# - ~/.config/lazygit exists
# - ~/bin exists
# - ~/.bashrc is backup and removed
# - ~/.gitconfig is backup and removed
############################################################

function mkdir_if_not_exists() {
  if [ ! -d "$1" ]; then
    mkdir $1
  fi
}

function fail_if_file_exists_but_a_link() {
  if [ -e "$1" ] && [ ! -L "$1" ]; then
    echo "$1 exists, please backup and remove"
    exit 1
  fi
}

mkdir_if_not_exists ~/.config/fish
mkdir_if_not_exists ~/.config/kitty
mkdir_if_not_exists ~/.config/git
mkdir_if_not_exists ~/.config/lazygit
mkdir_if_not_exists ~/bin
fail_if_file_exists_but_a_link ~/.bashrc
fail_if_file_exists_but_a_link ~/.gitconfig