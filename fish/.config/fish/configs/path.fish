set -xg PATH $HOME/bin $HOME/go/bin $HOME/.cargo/bin $PATH

if [ $IS_MAC = 1 ]
    set -xg PATH $HOME/bin/browsers $PATH
    eval (/opt/homebrew/bin/brew shellenv)

    if not which code
        set -xg PATH "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" $PATH
    end
end

