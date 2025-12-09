function url_encode() {
  # not encode everything, just "(" to "%28", ")" to "%29", and "+" to "%2B"
  local string="$1"
  echo "$string" | sed 's/(/%28/g; s/)/%29/g; s/+/%2B/g'
}

function combine_with_delimiter() {
    # Check if at least two arguments are provided
    if [ "$#" -lt 2 ]; then
        echo "Usage: combine_with_delimiter DELIMITER ARG1 [ARG2 ...]"
        return 1
    fi

    local delimiter="$1"
    shift  # Remove the first argument (delimiter)

    # Concatenate arguments with spaces
    result="$(url_encode $1)"
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
