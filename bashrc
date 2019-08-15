export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'

[ -z "$TMUX"  ] && { tmux attach || exec tmux new-session && exit; }
