# help for all my custom commands includes abbr and alias,
# `set -xg mycmds $mycmds newdocs` to add.
set -e mycmds
function helpme
    echo "Customed commands:"
    echo "========================================"
    for cmd in $mycmds
        echo "- $cmd"
    end
end

function _color_mycmd --description "colorful print the command"
    set_color -o blue
    printf $argv[1]
    set_color normal
    printf " : %s" $argv[2]
end

# locale setting
set -xg LC_TIME zh_CN.UTF-8
set -xg LC_ALL en_US.UTF-8

set -xg FISH_CFG_PATH $HOME/.config/fish/configs

source $FISH_CFG_PATH/path.fish
source $FISH_CFG_PATH/env-detect.fish
source $FISH_CFG_PATH/choose-editor.fish
source $FISH_CFG_PATH/prompt.fish
source $FISH_CFG_PATH/helpers.fish
source $FISH_CFG_PATH/alias/alias.fish
