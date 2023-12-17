# fish in zellij have issue to load commands completions from ~/.config/fish/completions.
if [ $IS_ZELLIJ = 1 ]
    for f in (ls $HOME/.config/fish/completions)
        source $HOME/.config/fish/completions/$f
    end
end

# fish in vscode have issue to load commands completions from ~/.config/fish/completions.
if [ $IS_VSCODE = 1 ]
    for f in (ls $HOME/.config/fish/completions)
        source $HOME/.config/fish/completions/$f
    end
end