# locale setting
set -xg LC_TIME zh_CN.UTF-8
set -xg LC_ALL en_US.UTF-8

set -xg FISH_CFG_PATH $HOME/.config/fish/configs
set -xg XDG_CONFIG_HOME $HOME/.config

source $FISH_CFG_PATH/path.fish
source $FISH_CFG_PATH/choose-editor.fish
source $FISH_CFG_PATH/prompt.fish
source $FISH_CFG_PATH/helpers.fish
source $FISH_CFG_PATH/alias/alias.fish
source $FISH_CFG_PATH/fix-completions.fish
