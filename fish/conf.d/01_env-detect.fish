# OS Name
switch (uname)
    case Linux
        set -xg OS_NAME Linux
        set -xg IS_LINUX 1
        set -xg IS_MAC 0
    case Darwin
        set -xg OS_NAME MAC
        set -xg IS_LINUX 0
        set -xg IS_MAC 1
end

# IS_SSH
set -xg IS_SSH 0
if [ -n "$SSH_CLIENT" ]
    set -xg IS_SSH 1
end

# IS_VSCODE
set -xg IS_VSCODE 0
if [ "$TERM_PROGRAM" = vscode ]
    set -xg IS_VSCODE 1
end

# IS_ZED
set -xg IS_ZED 0
if [ -n "$ZED_TERM" ]
    set -xg IS_ZED 1
end

# IS_ZELLIJ
set -xg IS_ZELLIJ 0
if test -n "$ZELLIJ"
    set -xg IS_ZELLIJ 1
end

# IS_WSL
set -xg IS_WSL 0
if test -n "$WSLENV"
    set -xg IS_WSL 1
end

# IS_KITTY
set -xg IS_KITTY 0
if test "$TERM_PROGRAM" = kitty -o -n "$KITTY_WINDOW_ID"
    set -xg IS_KITTY 1
end
