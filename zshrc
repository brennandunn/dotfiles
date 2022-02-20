# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship
unsetopt PROMPT_SP

source ~/.zshrclocal

source /Users/brennandunn/.dotfiles/.zsh/completion.zsh
autoload -Uz compinit

typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi

# Enhanced form of menu completion called `menu selection'
zmodload -i zsh/complist

#source /Users/brennandunn/.dotfiles/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

alias ls="ls -G"
alias zshreload='source ~/.zshrc' 
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias less='less -R'
alias g='git'