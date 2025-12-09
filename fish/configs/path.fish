fish_add_path -g $HOME/bin
fish_add_path -g $HOME/go/bin
fish_add_path -g $HOME/.cargo/bin
fish_add_path -g $HOME/.npm/bin

if [ $IS_MAC = 1 ]
    set -xg PATH $HOME/bin/browsers $PATH
    eval (/opt/homebrew/bin/brew shellenv)

    if not which code
        set -xg PATH "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" $PATH
    end

    # I have use pyenv on Mac, but not other systems.
    if which pyenv
        set -Ux PYENV_ROOT $HOME/.pyenv
        fish_add_path $PYENV_ROOT/bin
        pyenv init - fish | source
    end
end

# Added by LM Studio CLI (lms)
fish_add_path -g $HOME/.lmstudio/bin
# End of LM Studio CLI section
