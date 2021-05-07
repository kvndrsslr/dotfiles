export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH

alias mc='mc -x'
alias sed='gsed'
rr () {
INITIAL_QUERY=""
RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" \
  fzf --bind "change:reload:$RG_PREFIX {q} || true" \
      --ansi --disabled --query "$INITIAL_QUERY" \
      --height=50% --layout=reverse --delimiter : --preview 'bat --style=numbers --color=always --line-range :5000 -H {2} {1}' --preview-window '+{2}+3/2'
}