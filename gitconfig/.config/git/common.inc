# Include this file
# [include]
#   path = <HOME>/.config/git/common.inc

[core]
	pager = delta

[interactive]
	diffFilter = delta --color-only

[delta]
	navigate = true
	light = false

[merge]
	conflictstyle = diff3

[diff]
	colorMoved = default

[init]
	defaultBranch = main

