# All my plugins
#

if (( $+commands[peco] )); then
  ZSH_PECO_HISTORY_OPTS="--layout=bottom-up --initial-filter=Fuzzy"
  ZSH_PECO_HISTORY_DEDUP="True"
  if ! (( ${+ZSH_PECO_HISTORY_OPTS} )); then
    ZSH_PECO_HISTORY_OPTS="--layout=bottom-up"
  fi

  function peco_select_history() {
    local parse_cmd

    if (( $+commands[gtac] )); then
      parse_cmd="gtac"
    elif (( $+commands[tac] )); then
      parse_cmd="tac"
    else
      parse_cmd="tail -r"
    fi

    if [ -n "$ZSH_PECO_HISTORY_DEDUP" ]; then
      if (( $+commands[perl] )); then
        parse_cmd="$parse_cmd | perl -ne 'print unless \$seen{\$_}++'"
      elif (( $+commands[awk] )); then
        parse_cmd="$parse_cmd | awk '!seen[\$0]++'"
      else
        parse_cmd="$parse_cmd | uniq"
      fi
    fi

    BUFFER=$(fc -l -n 1 | eval $parse_cmd | \
               peco ${=ZSH_PECO_HISTORY_OPTS} --query "$LBUFFER")

    CURSOR=$#BUFFER # move cursor
    zle -R -c       # refresh
  }

  zle -N peco_select_history
  bindkey '^R' peco_select_history
fi


if (( $+commands[peco] )); then
  ZSH_PECO_GHQ_FILTER=${ZSH_PECO_GHQ_FILTER:-IgnoreCase}
  function zsh-peco-ghq () {
    local selected_dir=$(ghq list -p | peco --initial-filter "$ZSH_PECO_GHQ_FILTER" --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
      BUFFER="cd ${selected_dir}"
      zle accept-line
    fi
    zle clear-screen
  }

  zle -N zsh-peco-ghq
  bindkey '^f' zsh-peco-ghq
fi
