links:
ifeq ($(shell uname), Linux)
	ls -d */ | grep -v ".*-mac/" | xargs stow --verbose --target=$$HOME --restow
else ifeq ($(shell uname), Darwin)
	ls -d */ | grep -v ".*-linux/" | xargs stow --verbose --target=$$HOME --restow
else
	@echo "OS does not support yet"
endif
	bat cache --build

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
		tldr stow \
		python-pipenv python-paramiko

fish-install:
	fish -c "fisher install PatrickF1/fzf.fish"
	fish -c "fisher install edc/bass"
	fish -c "fisher install catppuccin/fish"

mac-install:
	sudo port selfupdate
	sudo port install \
		go \
		fish \
		neovim micro \
		curl wget jq \
		lsd zellij xh ripgrep fd bat fzf starship \
		lazygit git-delta \
		kitty \
		tealdeer stow \
		pipenv py-paramiko

debian-install:
	sudo apt install \
		fish curl wget \
		fd-find bat jq fzf micro \
		kitty stow \
		pipenv python3-paramiko
	rustup update
	cargo install cargo-update
	cargo install lsd
	cargo install starship
	cargo install zellij
	cargo install bat
	cargo install xh
	cargo install tealdeer
	cargo install git-delta
	go install github.com/jesseduffield/lazygit@latest
