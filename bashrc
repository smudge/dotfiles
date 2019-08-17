[ -z "$TMUX"  ] && { tmux attach || exec tmux new-session && exit; }

export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
[ -f $(brew --prefix)/etc/profile.d/autojump.sh ] && . $(brew --prefix)/etc/profile.d/autojump.sh

source ~/.alias
