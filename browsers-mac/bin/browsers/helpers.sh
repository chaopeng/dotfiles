function combine_with_delimiter() {
    # Check if at least two arguments are provided
    if [ "$#" -lt 2 ]; then
        echo "Usage: combine_with_delimiter DELIMITER ARG1 [ARG2 ...]"
        return 1
    fi

    local delimiter="$1"
    shift  # Remove the first argument (delimiter)

    # Concatenate arguments with spaces
    result="$1"
    shift
    while [ "$#" -gt 0 ]; do
        result="$result $1"
        shift
    done

    # Replace duplicated spaces with a single delimiter
    result="$(echo "$result" | tr -s ' ')"
    
    # Replace spaces with the specified delimiter
    result="${result// /$delimiter}"

    echo "$result"
}
