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
