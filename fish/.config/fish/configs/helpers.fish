# notify me
function notify
    set -l url "https://api.telegram.org/bot$tg_bot_token/sendMessage"
    curl -s -X POST -o /dev/null $url -d chat_id=$tg_chat_id -d text="$argv[1]"
end

set -xg mycmds $mycmds "notify      : send a notification"

function mkcd
    argparse --min-args=1 --max-args=1 -- $argv
    mkdir -p $argv[1]
    cd $argv[1]
end

set -xg mycmds $mycmds "mkcd        : mkdir -p and then cd"

alias fish_reload 'source $HOME/.config/fish/configs/main.fish'
set -xg mycmds $mycmds "fish_reload : reload my fish configs"
