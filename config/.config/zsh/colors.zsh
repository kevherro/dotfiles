# usage: set PROMPT_THEME=<name>

: ${PROMPT_THEME:=modern_blue}

prompt_theme_modern_blue() {
  PROMPT_USER_BG=234
  PROMPT_USER_FG=39
  PROMPT_PATH_FG=81
  PROMPT_PATH_FG_LONG=81
}

prompt_theme_github_dark() {
  PROMPT_USER_BG=235
  PROMPT_USER_FG=255
  PROMPT_PATH_FG=114
  PROMPT_PATH_FG_LONG=114
}

prompt_theme_gruvbox() {
  PROMPT_USER_BG=237
  PROMPT_USER_FG=214
  PROMPT_PATH_FG=142
  PROMPT_PATH_FG_LONG=108
}

prompt_theme_nord() {
  PROMPT_USER_BG=236
  PROMPT_USER_FG=81
  PROMPT_PATH_FG=110
  PROMPT_PATH_FG_LONG=110
}

prompt_theme_minimal_mono() {
  PROMPT_USER_BG=234
  PROMPT_USER_FG=255
  PROMPT_PATH_FG=250
  PROMPT_PATH_FG_LONG=245
}

prompt_theme_cyberpunk_lite() {
  PROMPT_USER_BG=234
  PROMPT_USER_FG=213
  PROMPT_PATH_FG=81
  PROMPT_PATH_FG_LONG=45
}

prompt_theme_orange_focus() {
  PROMPT_USER_BG=235
  PROMPT_USER_FG=208
  PROMPT_PATH_FG=229
  PROMPT_PATH_FG_LONG=223
}

prompt_theme_deep_navy() {
  PROMPT_USER_BG=18
  PROMPT_USER_FG=231
  PROMPT_PATH_FG=118
  PROMPT_PATH_FG_LONG=82
}

prompt_theme_emerald() {
  PROMPT_USER_BG=234
  PROMPT_USER_FG=118
  PROMPT_PATH_FG=114
  PROMPT_PATH_FG_LONG=78
}

prompt_theme_purple_ice() {
  PROMPT_USER_BG=234
  PROMPT_USER_FG=177
  PROMPT_PATH_FG=81
  PROMPT_PATH_FG_LONG=110
}

prompt_theme_slate() {
  PROMPT_USER_BG=238
  PROMPT_USER_FG=255
  PROMPT_PATH_FG=75
  PROMPT_PATH_FG_LONG=67
}

prompt_theme_warm() {
  PROMPT_USER_BG=234
  PROMPT_USER_FG=220
  PROMPT_PATH_FG=223
  PROMPT_PATH_FG_LONG=229
}

# apply theme
prompt_apply_theme() {
  local fn="prompt_theme_${PROMPT_THEME}"
  if (( $+functions[$fn] )); then
    $fn
  else
    prompt_theme_modern_blue
  fi
}

prompt_apply_theme
