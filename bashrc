eval "$(/opt/homebrew/bin/brew shellenv)"

if type tmux &>/dev/null; then
  if [ "$TERM" == "xterm-256color" ] || [ "$TERM" == "alacritty" ]; then
    [ -z "$TMUX"  ] && { tmux attach || exec tmux new-session && exit; }
  fi
fi

source "$HOME/.alias"
eval "$(direnv hook bash)"
export GOPATH="$HOME/.go"
export PATH="$PATH:$GOPATH/bin"
. "$HOME/.cargo/env"

export DOCKER_DEFAULT_PLATFORM=linux/amd64

if type rbenv &> /dev/null; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

if type nodenv &> /dev/null; then
  export PATH="$HOME/.nodenv/bin:$PATH"
  eval "$(nodenv init -)"
fi

if type pyenv &> /dev/null; then
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init --path)"
fi

if type brew &>/dev/null; then
  export HOMEBREW_NO_SANDBOX=1
  export HOMEBREW_BUNDLE_NO_LOCK=1
  HOMEBREW_ROOT="$(brew --prefix)"
  export HOMEBREW_ROOT

  if [[ -r "$HOMEBREW_ROOT/etc/profile.d/bash_completion.sh" ]]; then
    source "$HOMEBREW_ROOT/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "$HOMEBREW_ROOT/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi

  if [[ -f "$HOMEBREW_ROOT/etc/bash_completion.d/git-completion.bash" ]]; then
    export GIT_PS1_SHOWDIRTYSTATE=1 GIT_PS1_SHOWCOLORHINTS=1 GIT_PS1_HIDE_IF_PWD_IGNORED=1
    export PROMPT_COMMAND='__git_ps1 "\W" "\\\$ "'
  fi

  [ -f $HOMEBREW_ROOT/etc/profile.d/autojump.sh ] && . $HOMEBREW_ROOT/etc/profile.d/autojump.sh
fi
