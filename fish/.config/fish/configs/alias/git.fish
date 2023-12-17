# From https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
# but only include my daily routines.

alias g git
abbr glog fzf_search_git_log
abbr glg fzf_search_git_log
abbr gl 'git pull'
abbr gp 'git push'
abbr gpf 'git push --force'
abbr gst fzf_search_git_status
abbr gca 'git commit -a'
abbr gca! 'git commit -a --amend'
abbr gcam 'git commit -a -m'
abbr gcam! 'git commit -a -m --amend'
abbr ga 'git add'
abbr gaa 'git add -all'
abbr gb 'git branch'
abbr gba 'git branch --all'
abbr gbd 'git branch --delete'
abbr gbdf 'git branch --delete --force'
abbr gco 'git checkout'
abbr gcor 'git checkout --recurse-submodules'
abbr gcb 'git checkout -b'
abbr grb 'git rebase --interactive'
abbr grba 'git rebase --abort'
abbr grbc 'git rebase --continue'
abbr gclean 'git reset --hard; and git clean -dfx'
