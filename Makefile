links:
ifeq ($(shell uname), Linux)
	ls -d */ | grep -v ".*-mac/" | xargs stow --verbose --target=$$HOME --restow
else ifeq ($(shell uname), Darwin)
	ls -d */ | grep -v ".*-linux/" | xargs stow --verbose --target=$$HOME --restow
else
	@echo "OS does not support yet"
endif

del-links:
	stow --verbose --target=$$HOME --delete */

arch-install:
	sudo pacman -Sy
	sudo pacman -S --needed \
		base-devel go \
		fish fisher \
		neovim micro \
		git curl wget jq \
		lsd zellij xh ripgrep fd bat fzf starship \
		lazygit git-delta \
		kitty \
		tldr stow

fish-install: SHELL:=/usr/bin/fish
fish-install:
	fisher install PatrickF1/fzf.fish
	fisher install edc/bass
	fisher install catppuccin/fish

