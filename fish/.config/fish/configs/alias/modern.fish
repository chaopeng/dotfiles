############################################
# There are some modern shell tools
# Garthering their setup here
#
# https://dev.to/lissy93/cli-tools-you-cant-live-without-57f6
# https://github.com/ibraheemdev/modern-unix
############################################

# lsd, better ls
# 1. install lsd
alias ls lsd
alias ll 'lsd -l'
alias la 'll -a'
alias ld 'll -d'
alias lt 'lsd --tree'
alias ltn 'lsd --tree --depth'

set -xg mycmds $mycmds (_color_mycmd "lt" "lt; better tree")
set -xg mycmds $mycmds (_color_mycmd "ltn" "ltn <level>; better tree")

############################################
# bat, better cat
# 1. install bat
# 2. source bat.fish
alias cat bat
