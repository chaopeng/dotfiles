set -xg PATH $HOME/bin $HOME/go/bin $HOME/.cargo/bin $PATH

if [ $IS_MAC = 1 ]
    set -xg PATH $HOME/bin/browsers $PATH
    eval (/opt/homebrew/bin/brew shellenv)
end

