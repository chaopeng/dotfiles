# Use fd ad default command
set -x FZF_DEFAULT_COMMAND 'fd --hidden --no-ignore'

# Change key bindings to
#
#  COMMAND            |  KEY SEQUENCE
#  Search Directory   |  Ctrl+F
#  Search History     |  Ctrl+R
#  Search Processes   |  Ctrl+Alt+P
#  Search Git Log     |  None
#  Search Git Status  |  None
#  Search Variables   |  None
fzf_configure_bindings --directory=\cf --history=\cr --processes=\e\cp --variables= --git_status= --git_log=

# fzf.fish does not support **Tab, instead we can use the fish build-in Shift+Tab.

alias fzf_search_git_log _fzf_search_git_log
# abbr glf fzf_search_git_log

alias fzf_search_git_status _fzf_search_git_status
# abbr gsf fzf_search_git_status

alias fzf_search_vars '_fzf_search_variables (set --show | psub) (set --names | psub)'
set -xg mycmds $mycmds "fzf_search_vars : show all env vars"

function fzf_kill --description 'interactive kill, allow argument for kill signal, default is -9'
    set -l signal -9
    test -z $argv[1]
    or set signal $argv[1]

    set -l uid (id -u)
    set -l pid
    if test $uid -ne 0
        set pid (ps -f -u $uid | sed 1d | fzf -m | awk '{ print $2; }')
    else
        set pid (ps -ef | sed 1d | fzf -m | awk '{ print $2; }')
    end

    test -z $pid
    or echo $pid | xargs kill $signal
end
abbr fkill fzf_kill
set -xg mycmds $mycmds "fkill       : interactive kill"

function fzf_editor_file --description 'find a file and use $EDITOR to edit'
    argparse -n fzf_editor_file h/help w/wait -- $argv

    if test -n "$_flag_help"
        echo 'Usage:
fzf_editor_file [OPTS] [FILTER]

    -h/--help     for help
    -w/--wait     wait for the editing complete'
        return
    end

    set -l file (fd --hidden --no-ignore --type=file $argv[1] | fzf)

    eval (_choose_editor) $file
end
abbr fe fzf_editor_file
set -xg mycmds $mycmds "fe          : open file to edit"
