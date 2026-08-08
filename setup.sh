#!/usr/bin/env bash
set -euo pipefail
set -o xtrace

# check for prerequisite tools
packages=()

command -v curl >/dev/null 2>&1 || packages+=(curl)
command -v stow >/dev/null 2>&1 || packages+=(stow)

if ((${#packages[@]})); then
  sudo apt-get update
  sudo apt-get install -y "${packages[@]}"
fi

if [[ ! -x "$HOME/.local/bin/mise" ]]; then
  curl --fail --silent --show-error https://mise.run | sh
fi

stow bash git mise nvim tmux

source ~/.bashrc
