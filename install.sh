#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

command -v stow >/dev/null || { echo "install stow"; exit 1; }

stow -R -v zsh config tmux
