[ -z "$TMUX"  ] && { tmux attach || exec tmux new-session && exit; }

export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'

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

source ~/.alias
