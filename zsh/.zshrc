# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
plugins=(git)
ZSH_DISABLE_COMPFIX=true
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
mkdir -p "${ZSH_COMPDUMP:h}"
[[ -d "$ZSH" ]] && source "$ZSH/oh-my-zsh.sh"

# history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY
setopt HIST_FCNTL_LOCK

# conditional sourcing helper
source_if() { [[ -r "$1" ]] && source "$1"; }

# bun completions (compinit already ran via oh-my-zsh above)
source_if "$HOME/.bun/_bun"

# aliases (avoid breaking mac bsd tools)
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias update='brew update && brew upgrade'
command -v nvim >/dev/null && alias vim=nvim
command -v flyctl >/dev/null && alias fly=flyctl
alias mkt='cd "$(mktemp -d)"'
alias cc='EDITOR=vim claude'
if command -v rg >/dev/null; then
  alias grep='rg'
  alias egrep='rg'
  alias fgrep='rg'
fi
alias k='ssh -i /Users/kevin/.ssh/us-ca-lax.pem kevin@ec2-35-92-54-199.us-west-2.compute.amazonaws.com'
alias cpi='ssh -i /Users/kevin/.ssh/us-ca-lax.pem ubuntu@ec2-54-185-197-100.us-west-2.compute.amazonaws.com'

# nvm lazy-load
nvm() {
  unset -f nvm
  export NVM_DIR="$HOME/.config/nvm"
  [[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
  nvm "$@"
}

# prompt (adam1-style, gruvbox dark hard-ish)
autoload -Uz add-zsh-hook

prompt_kevin_setup() {
  # gruvbox dark hard palette (approx 256-color)
  PROMPT_USER_BG=24      # dark bg
  PROMPT_USER_FG=223      # light fg (gruvbox fg)
  PROMPT_PATH_FG=142      # yellow/olive
  PROMPT_PATH_FG_LONG=108 # aqua/teal

  _pk_base="%K{${PROMPT_USER_BG}}%F{${PROMPT_USER_FG}}%n@%m%f%k "
  _pk_base_nocol="%n@%m "

  add-zsh-hook precmd prompt_kevin_precmd
}

prompt_kevin_precmd() {
  setopt localoptions noxtrace

  local cols=${COLUMNS:-80}
  local base_len space_left path

  base_len=${#${(%)_pk_base_nocol}}

  # short path: 1 line
  if (( base_len + 1 + 20 <= cols )); then
    path="%F{${PROMPT_PATH_FG}}%(4~|...|)%3~%f"
    PROMPT="${_pk_base}${path} %# "
    return
  fi

  # long path: truncate + newline
  space_left=$(( cols - base_len - 2 ))
  (( space_left < 10 )) && space_left=10

  path="%F{${PROMPT_PATH_FG_LONG}}%${space_left}<...<%~%f"
  PROMPT="${_pk_base}${path}
%# "
}

prompt_kevin_setup

source_if "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/tmux-help.zsh"
alias th='tmux-help'

# autosuggestions + syntax highlighting LAST (they hook widgets)
source_if "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source_if "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
