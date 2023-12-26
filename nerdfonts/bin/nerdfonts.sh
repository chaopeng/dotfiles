#!/usr/bin/env bash

############################################################
# Nerd fonts help
#
# For Mac and Linux (except Arch), this downloads fonts from
# GitHub nerdfonts release. For Arch, this uses Pacman. Arch
# is da best Linux distro.
#
# -h: help
# -l: list available nerd fonts
# -L: list installed nerd fonts
# -u: update installed nerd fonts
# -i <font_name>: install the font
# -r <font_name >: remove the font
############################################################

# I don't know how to support WSL.
if [[ -n "$WSL_DISTRO_NAME" ]]; then
  echo "Does not support WSL"
  exit 0
fi

font_path=""

if [[ "$(uname -s)" == "Darwin" ]]; then
  font_path="$HOME/Library/Fonts/"
elif [[ "$(uname -s)" == "Linux" ]]; then
  font_path="$HOME/.local/share/fonts/"
else
  echo "Unsupported platform" >&2
fi

function is_arch() {
  command -v pacman >/dev/null 2>&1
}

function fc_cache_refresh() {
  fc-cache -f -v > /dev/null 2>&1
}

function list_nerdfonts() {
  if is_arch; then
    pacman -Ss '(ttf|otf)-.*-nerd' | grep '(nerd-fonts)' | awk '{ print $1 }'
  else
    curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | jq -r '.assets[] .name' | grep "zip" | awk '{split($0,a,"."); print a[1]}'
  fi
}

function list_installed_nerdfonts() {
  if is_arch; then
    pacman -Qsq '(ttf|otf)-.*-nerd' | awk '{ print $1 }'
    return
  fi

  for dir in $(ls $font_path | grep "^nerdfonts-"); do
    font_name="${dir#nerdfonts-}"
    version_file="$font_path/$dir/VERSION"

    if [[ -f "$version_file" ]]; then
      printf "$font_name: "
      cat "$version_file"
    else
      echo "Warning: $version_file not found for $font_name"
    fi
  done
}

function update_installed_nerdfonts() {
  if is_arch; then
    echo "please use sudo pacman -Syu"
    return
  fi

  latest_version=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | jq -r ".tag_name")
  echo "Latest nerd font version: $latest_version"
  echo ""

  need_update_fc_cache=false
  for dir in $(ls $font_path | grep "^nerdfonts-"); do
    font_name="${dir#nerdfonts-}"
    version_file="$font_path/$dir/VERSION"

    version=""
    if [[ -f "$version_file" ]]; then
      version=$(cat "$version_file")
    else
      # version file not found, just update
      version="?"
    fi

    if [[ "$version" != "$latest_version" ]]; then
      echo "Update $font_name $version => $latest_version:"
      download_nerdfont_unzip_move_to_font_path $font_name $version
      need_update_fc_cache=true
    else
      echo "$font_name is up-to-date."
    fi
  done

  if [[ $need_update_fc_cache == true ]]; then
    fc_cache_refresh
  fi
}

function download_nerdfont_unzip_move_to_font_path() {
  font_name=$1
  version=$2

  echo "install $font_name $version"
  download_link=https://github.com/ryanoasis/nerd-fonts/releases/download/$version/$font_name.zip
  wget -q "$download_link" -O "/tmp/nerdfonts-$font_name.zip"
  if [[ $? -ne 0 ]]; then
    exit 1
  fi

  echo "  [done] download $font_name $version"

  unzip -q "/tmp/nerdfonts-$font_name.zip" -d "/tmp/nerdfonts-$font_name"
  rm "/tmp/nerdfonts-$font_name.zip"
  echo "  [done] unzip font"

  # if this fonts has been installed, remove the previous installation.
  if [[ -d "$font_path/nerdfonts-$font_name" ]]; then
    rm -rf "$font_path/nerdfonts-$font_name"
  fi
  mv "/tmp/nerdfonts-$font_name" $font_path
  echo $version >$font_path/nerdfonts-$font_name/VERSION

  echo "  [done] copied to font dir"
}

function install_nerdfont() {
  font_name=$1

  if is_arch; then
    sudo pacman -S "$font_name"
    return
  fi

  version=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | jq -r ".tag_name")

  download_nerdfont_unzip_move_to_font_path $font_name $version
  fc_cache_refresh
}

function remove_nerdfont() {
  if is_arch; then
    sudo pacman -Rs $1
    return
  fi

  # if this fonts has been installed, remove the previous installation.
  if [[ -d "$font_path/nerdfonts-$1" ]]; then
    rm -rf "$font_path/nerdfonts-$1"
    fc_cache_refresh
  else
    echo "nerdfonts-$1 does not exist."
  fi
}

function ensure_command_exists() {
  local command="$1"

  if ! command -v "$command" >/dev/null 2>&1; then
    echo "Error: '$command' is not installed. Please install it and try again." >&2
    exit 1
  fi
}

function help() {
  echo 'Usage:
  -h: help
  -l: list available nerd fonts
  -L: list installed nerd fonts
  -u: update installed nerd fonts
  -i <font_name>: install the font
  -r <font_name >: remove the font'
}

ensure_command_exists jq
ensure_command_exists curl
ensure_command_exists wget
ensure_command_exists unzip

if [[ $# -eq 0 ]]; then
  help
  exit 1
fi

while getopts "hlLui:r:n:" opt; do
  case $opt in
  h)
    help
    exit 0
    ;;
  l)
    list_nerdfonts
    exit 0
    ;;
  L)
    list_installed_nerdfonts
    exit 0
    ;;
  u)
    update_installed_nerdfonts
    exit 0
    ;;
  i)
    install_nerdfont "$OPTARG"
    exit 0
    ;;
  r)
    remove_nerdfont "$OPTARG"
    exit 0
    ;;
  \?)
    echo "Invalid option: -$OPTARG" >&2
    help
    exit 1
    ;;
  esac
done

# Handle any remaining arguments
if [[ $# -gt 0 ]]; then
  echo "Invalid arguments: $*" >&2
  exit 1
fi
