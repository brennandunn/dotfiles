# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)

eval "$(starship init bash)"

source ~/.local/share/omarchy/default/bash/rc

set -o vi

# export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
# . <(asdf completion bash)

eval "$(ssh-agent -s)" >/dev/null

alias tm="tmux attach"
alias cc="cliphist list | fzf | cliphist decode | wl-copy"
alias yolo="claude --dangerously-skip-permissions --continue"
alias yolonew="claude --dangerously-skip-permissions"
# alias restart-workspace-padding='pkill -f "monitor-workspace-watcher.sh" && ~/.config/hypr/scripts/monitor-workspace-watcher.sh &'

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
#
# Use VSCode instead of neovim as your default editor
# export EDITOR="code"
#
# Set a custom prompt with the directory revealed (alternatively use https://starship.rs)
# PS1="\W \[\e]0;\w\a\]$PS1"
unset GNOME_KEYRING_CONTROL
unset SSH_AUTH_SOCK
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
