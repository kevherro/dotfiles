# always-on env (keep fast)
export XDG_CONFIG_HOME="$HOME/.config"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

export EDITOR=nvim
export VISUAL=nvim

# path via zsh array + de-dupe
typeset -U path PATH
path=(
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /usr/local/bin
  "$HOME/.local/bin"
  "$HOME/bin"
  "$HOME/.bun/bin"
  "$HOME/.opencode/bin"
  /usr/local/go/bin
  "$HOME/go/bin"
  /usr/local/zig
  /usr/local/nvim-macos-arm64/bin
  $path
)
export PATH
