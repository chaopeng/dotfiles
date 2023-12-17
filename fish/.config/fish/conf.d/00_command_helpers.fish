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
