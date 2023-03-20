# zsh configuration
# By Yuri

neofetch
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
eval "$(starship init zsh)"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PATH="$PATH:$HOME/go/bin"

export GHQ_ROOT="$HOME/development"

export GPG_TTY=$(tty)

# Some plugins
export MY_ZSH_CONFIG="$HOME/.config/zsh"
source "$MY_ZSH_CONFIG/alias.zsh"
source "$MY_ZSH_CONFIG/plugins.zsh"
source "$MY_ZSH_CONFIG/history.zsh"
source "$MY_ZSH_CONFIG/keymap.zsh"


autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C '/usr/local/bin/aws_completer' aws

if [ -z "$TMUX" ]
then
    tmux attach -t TMUX || tmux new -s TMUX
fi


