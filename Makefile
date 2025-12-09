install:
	dotman install
	bat cache --build

del-links:
	dotman uninstall

arch-install:
	sudo pacman -Sy
	sudo pacman -S --needed \
		base-devel go \
		fish fisher \
		neovim micro \
		git curl wget jq \
		lsd zellij xh ripgrep fd bat fzf starship \
		lazygit git-delta \
		tealdeer \
		ghostty
	go install github.com/nao1215/gup@latest
	go install github.com/chaopeng/to@latest
	go install github.com/elmhuangyu/dotman@latest
	nerdfonts/bin/nerdfonts.sh -i ttf-firacode-nerd
	fish -c "fisher install PatrickF1/fzf.fish"
	fish -c "fisher install edc/bass"
	fish -c "fisher install catppuccin/fish"

mac-install:
	./ensure-command.sh brew
	brew install go \
		fish fisher \
		neovim micro \
		git curl wget jq \
		lsd zellij xh ripgrep fd bat fzf starship \
		lazygit git-delta \
		tealdeer
	brew install --cask ghostty
	go install github.com/nao1215/gup@latest
	go install github.com/chaopeng/to@latest
	go install github.com/elmhuangyu/dotman@latest
	nerdfonts/bin/nerdfonts.sh -i FiraCode
	fish -c "fisher install PatrickF1/fzf.fish"
	fish -c "fisher install edc/bass"
	fish -c "fisher install catppuccin/fish"

debian-install:
	./ensure-command.sh rustup
	./ensure-command.sh cargo
	./ensure-command.sh go
	sudo apt install \
		fish \
		micro \
		git curl wget jq \
		fzf  \
		kitty \
		pipenv python3-paramiko
	rustup update
	cargo install cargo-update \
		lsd zellij xh ripgrep fd-find bat starship \
		git-delta \
		tealdeer
	go install github.com/nao1215/gup@latest
	go install github.com/jesseduffield/lazygit@latest
	go install github.com/chaopeng/to@latest
	go install github.com/elmhuangyu/dotman@latest
	nerdfonts/bin/nerdfonts.sh -i FiraCode
	fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
	fish -c "fisher install PatrickF1/fzf.fish"
	fish -c "fisher install edc/bass"
	fish -c "fisher install catppuccin/fish"
