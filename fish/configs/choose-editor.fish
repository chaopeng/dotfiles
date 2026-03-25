# Choose editor is complicated!
function _choose_editor
    set -l term_editor micro
    argparse -n _choose_editor wait -- $argv

    # If I am already in vscode, keep me is vscode. This also works in ssh.
    if [ $IS_VSCODE = 1 ]
        if test -n "$_flag_wait"
            echo "code -w"
        else
            echo code
        end
        return
    end

    if [ $IS_ZELLIJ = 1 ]
        echo $term_editor
        return
    end

    # If I am in terminal only, I don't have much choice. 
    if [ $IS_SSH = 1 ]
        echo $term_editor
        return
    end

    # If no display, terminal only.
    if test -z "$DISPLAY"
        echo $term_editor
        return
    end

    # Otherwise, open a new vscode instance maybe a good idea.
    if test -n "$_flag_wait"
        echo "code -n -w"
    else
        echo "code -n"
    end
end

# Set EDITOR
set -gx EDITOR (_choose_editor --wait)
