links: prestow-check
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
		tealdeer stow \
		python-pipenv python-paramiko \
		nerdfonts/bin/nerdfonts.sh -i ttf-firacode-nerd
	fish -c "fisher install PatrickF1/fzf.fish"
	fish -c "fisher install edc/bass"
	fish -c "fisher install catppuccin/fish"

mac-install:
	./ensure-command.sh port
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
	nerdfonts/bin/nerdfonts.sh -i FiraCode
	fish -c "fisher install PatrickF1/fzf.fish"
	fish -c "fisher install edc/bass"
	fish -c "fisher install catppuccin/fish"

debian-install:
	./ensure-command.sh rustup
	./ensure-command.sh cargo
	./ensure-command.sh go
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
	nerdfonts/bin/nerdfonts.sh -i FiraCode
	fish -c "fisher install PatrickF1/fzf.fish"
	fish -c "fisher install edc/bass"
	fish -c "fisher install catppuccin/fish"

prestow-check:
	./prestow-check.sh