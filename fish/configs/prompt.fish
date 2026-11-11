# Replace greeting
function fish_greeting
    # Check if any disk mount point is almost full (>= 85%)
    set -l high_disks (df -Pk 2>/dev/null | awk 'NR > 1 {
        if ($1 ~ /^\/dev\/loop/ || $1 == "devfs") next
        if ($6 ~ /^\/(dev|sys|proc|snap|run)($|\/)/) next
        if ($2 == 0) next
        pct = $5
        sub(/%$/, "", pct)
        pct = pct + 0
        if (pct >= 85) {
            mount = $6
            for (i = 7; i <= NF; i++) mount = mount " " $i
            print pct " " mount
        }
    }')
    for item in $high_disks
        set -l parts (string split -m 1 " " $item)
        set_color red --bold
        printf "Warning: "
        set_color yellow
        printf "Disk mount point '%s' is %s%% full!\n" $parts[2] $parts[1]
        set_color normal
    end

    printf "Hey %s, today is %s. Have a good one!\n" $USER (date "+%Y-%m-%d")
end

############################################
# starship, prompt
starship init fish | source
