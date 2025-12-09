# notify me
function notify
    set -l url "https://api.telegram.org/bot$tg_bot_token/sendMessage"
    curl -s -X POST -o /dev/null $url -d chat_id=$tg_chat_id -d text="$argv[1]"
end

set -xg mycmds $mycmds (_color_mycmd "notify" "send a notification")

function mkcd
    argparse --min-args=1 --max-args=1 -- $argv
    mkdir -p $argv[1]
    cd $argv[1]
end

set -xg mycmds $mycmds (_color_mycmd "mkcd" "mkdir -p and then cd")

function fish_reload --description "Simulate fish source configs"
    for f in (/bin/ls $HOME/.config/fish/conf.d)
        source $HOME/.config/fish/conf.d/$f
    end
    source $HOME/.config/fish/configs/main.fish
end
set -xg mycmds $mycmds (_color_mycmd "fish_reload" "reload my fish configs")

function rust_bin_update
    rustup update
    cargo-install-update install-update --all
end
set -xg mycmds $mycmds (_color_mycmd "rust_bin_update" "update bin installed by cargo")

if [ $IS_MAC = 1 ]
    function port_update
        sudo port selfupdate
        sudo port upgrade outdated
        sudo port uninstall inactive
    end
    set -xg mycmds $mycmds (_color_mycmd "port_update" "update bin installed by port")
end
