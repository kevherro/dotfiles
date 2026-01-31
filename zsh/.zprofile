# homebrew (login)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# rust/cargo (login)
[[ -r "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
