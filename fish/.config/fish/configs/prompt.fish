# Replace greeting
function fish_greeting
    printf "Hey %s, today is %s. Have a good one!\n" $USER (date "+%Y-%m-%d")
end

############################################
# starship, prompt
starship init fish | source
