# fish in zellij / vscode have issue to load commands completions from ~/.config/fish/completions.
for f in (/bin/ls $HOME/.config/fish/completions)
    source $HOME/.config/fish/completions/$f
end
