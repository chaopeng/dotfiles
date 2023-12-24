# Include this file
# [include]
#   path = <HOME>/.config/git/common.inc

[pull]
	rebase = true

[core]
	pager = delta

[interactive]
	diffFilter = delta --color-only

[delta]
	navigate = true
	light = false
	true-color = always
	line-numbers = true
	features = colibri

[merge]
	conflictstyle = diff3

[diff]
	colorMoved = default

[init]
	defaultBranch = main

[log]
  date = iso

# Delta Themes
[delta "colibri"]
	# author: https://github.com/pablospe
	# Based on woolly-mammoth: https://github.com/Kr1ss-XD.
	commit-decoration-style = 130 box
	dark = true
	file-decoration-style = "#606018" overline
	file-added-label = [●]
	file-copied-label = [C]
	file-modified-label = [+]
	file-removed-label = [⛌]
	file-renamed-label = [→]
	file-style = 232 bold 184
	hunk-header-style = syntax bold italic 237
	line-numbers = true
	line-numbers-left-format = "{nm:>1}┊"
	line-numbers-left-style = red
	line-numbers-minus-style = red bold
	line-numbers-plus-style = green bold
	line-numbers-right-format = " {np:>1}┊"
	line-numbers-right-style = green
	line-numbers-zero-style = "#545474" italic
	minus-emph-style = normal "#80002a"
	minus-style = normal "#5e0000"
	plus-emph-style = syntax bold "#007e5e"
	plus-style = syntax "#003500"
	syntax-theme = 1337
	whitespace-error-style = "#80002a" reverse
	zero-style = syntax
	blame-format = "{author:<18} ({commit:>7}) ┊{timestamp:^16}┊ "
