if type tmux &>/dev/null; then
  if [ "$TERM" == "xterm-256color" ] || [ "$TERM" == "alacritty" ]; then
    [ -z "$TMUX"  ] && { tmux attach || exec tmux new-session && exit; }
  fi
fi

HOMEBREW_PREFIX=$(brew --prefix)
[ -f ${HOMEBREW_PREFIX}/etc/profile.d/autojump.sh ] && . $(brew --prefix)/etc/profile.d/autojump.sh
if type brew &>/dev/null; then
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi

eval "$(nodenv init -)"
eval "$(direnv hook bash)"
export PATH="$HOME/.cargo/bin:$PATH"

export RUBYFMT_USE_RELEASE=1
alias rubyfmt="~/.rbenv/versions/2.6.5/bin/ruby --disable=all ~/src/rubyfmt/rubyfmt.rb"

source ~/.alias
