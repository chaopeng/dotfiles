#!/usr/bin/env fish

# This is a script generate stats report for a local git repo:
#
# - count commits
# - count changed files
# - count changed line: +X lines, -Y lines

if git rev-parse --is-inside-work-tree > /dev/null 2>&1
  # It is in a git repo.
else
  echo "Error: This script must be run from within a Git repository."
  exit 1
end

argparse 'a/author=' 'y/year=' 'h/help' -- $argv

## Variables for parsed values
set author_name $_flag_author
set target_year $_flag_year


## Function to display help/usage  
function show_help
    echo "Usage: gitstats.fish --author <author_name> --year <year>"
    echo "Example: gitstats.fish --author 'chaopeng' --year 2023"
    echo "Example: gitstats.fish -a 'chaopeng' -y 2023"
end

# count commits by author in a given year
function count_commits
    set author $argv[1]
    set year $argv[2]

    git log --author="$author" --since="$year-01-01" --until="$year-12-31" --oneline | wc -l | tr -d ' '
end

# count files changed by author in a year
function count_changed_files
    set author $argv[1]
    set year $argv[2]

    git log --author="$author" --since="$year-01-01" --until="$year-12-31" --pretty=tformat: --name-only | sort | uniq | wc -l | tr -d ' '
end


# calculate line changes (additions/deletions) by author in a year
function count_line_changes
    set author $argv[1]
    set year $argv[2]

    git log --author="$author" --since="$year-01-01" --until="$year-12-31" --numstat | awk 'NF==3 {plus+=$1; minus+=$2} END {printf("+%d lines, -%d lines", plus, minus)}'
end

if set -q _flag_help
  show_help
  exit 0
end

if test -z "$author_name" ;or test -z "$target_year"
  echo "Error: Missing required arguments. Both author and year must be provided."
  echo
  show_help
  exit 1
end

echo "Commits by $author_name in $target_year:"
count_commits $author_name $target_year
echo

echo "Files changed by $author_name in $target_year:"
count_changed_files $author_name $target_year
echo

echo "Line changes by $author_name in $target_year:"
count_line_changes $author_name $target_year
echo