links:
	stow --verbose --target=$$HOME --restow */

del-links:
	stow --verbose --target=$$HOME --delete */

arch-install:
	sudo pacman -Sy
	sudo pacman -S --needed \
		base-devel \
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

