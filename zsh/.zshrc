# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
plugins=(git)
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

# completion: cached + fast
autoload -Uz compinit
_compdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
mkdir -p "${_compdump:h}"
# -C skips some expensive checks; delete compdump if you change fpath a lot
compinit -d "$_compdump" -C

# bun completions (fine to source; do it after compinit if it's not adding to fpath)
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# aliases (avoid breaking mac bsd tools)
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias update='brew update && brew upgrade'
alias vim=nvim
alias fly=flyctl
alias mkt='cd "$(mktemp -d)"'
alias cc='EDITOR=vim claude'
alias grep='rg'
alias egrep='rg'
alias fgrep='rg'

# nvm lazy-load
,nvm() {
  export NVM_DIR="$HOME/.config/nvm"
  [[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
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

tmux-help() {
  local choice=${1:-all}

  declare -A cmds
  cmds[sessions]="
  C-a (prefix)                    your prefix (not C-b)
  new -s <name>                   new named session
  a -t <name>                     attach to session
  d                               detach
  kill-session -t <name>          kill session
  ls                              list sessions
  \$                               rename session"

  cmds[windows]="
  c                               new window
  n / p                           next / prev
  w                               list windows
  <n>                             jump to window n
  ,                               !! this renames PANE not window
  &                               kill window"

  cmds[panes]="
  v                               split vertical (your binding)
  s                               split horizontal (your binding)
  h/j/k/l                         navigate panes (vim, prefix)
  z                               zoom/unzoom
  x                               kill pane
  { }                             swap pane
  q                               show pane numbers
  Space                           cycle layouts
  ,                               rename pane (your binding)"

  cmds[copy]="
  prefix + [                      enter copy mode
  v                               begin selection (vi)
  y                               yank to clipboard via pbcopy
  r                               rectangle toggle
  q / Esc                         exit copy mode
  p                               paste tmux buffer (your binding)
  mouse drag                      auto-yanks to pbcopy on release"

  cmds[misc]="
  r                               reload ~/.tmux.conf (your binding)
  ?                               list all bindings
  :                               command prompt
  t                               clock
  mouse on                        click to select pane/window"

  local topics=(sessions windows panes copy misc)

  echo ""
  if [[ "$choice" == "all" ]]; then
    for t in "${topics[@]}"; do
      echo "── $t ──${cmds[$t]}"
      echo ""
    done
  elif [[ -n "${cmds[$choice]}" ]]; then
    echo "── $choice ──${cmds[$choice]}"
  else
    echo "topics: ${topics[*]}"
  fi
}

alias th='tmux-help'

# autosuggestions + syntax highlighting LAST (they hook widgets)
source_if() { [[ -r "$1" ]] && source "$1"; }
source_if "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source_if "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# bun completions
[ -s "/Users/kevin/.bun/_bun" ] && source "/Users/kevin/.bun/_bun"
