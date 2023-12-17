# Chao's dotfiles

This repo uses [stow][] to manage the symlinks for dotfiles. It is very easy to
use, just 1 line of command:

```sh
make links 
```

**Big Thanks to [venthur/dotfiles][] for this awesome trick!**

Each subdir includes config for one software so it is easy to maintance.

This also includes some softwares installation:

```sh
make arch-install
make fish-install
```

<!-- xrefs -->

[stow]: https://www.gnu.org/software/stow/
[venthur/dotfiles]: https://github.com/venthur/dotfiles

