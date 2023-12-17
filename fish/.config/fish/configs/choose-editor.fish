# Choose editor is complicated!
function _choose_editor
    set -l term_editor nvim
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

    # If I am in Zellij, I may want to stay in Zellij, pop editing or new pane,
    # I don't know. micro have many keybinding conflict with Zellij, before I
    # resolve, use nvim.
    # Also Zellij hold DISPLAY from the terminal it started, use code may open
    # a window in unexpeted window.
    if [ $IS_ZELLIJ = 1 ]
        echo nvim
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

# Maybe GIT_EDITOR?
