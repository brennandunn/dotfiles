# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)

eval "$(starship init bash)"

source ~/.local/share/omarchy/default/bash/rc

set -o vi

# Enable starship vi mode detection for bash
starship_precmd_user_func="set_win_title"
set_win_title() {
  :
}

# Vi mode cursor shape for Ghostty
# Block cursor in normal mode, bar cursor in insert mode
# bind 'set show-mode-in-prompt on'
# bind 'set vi-ins-mode-string \1\e[6 q\2'
# bind 'set vi-cmd-mode-string \1\e[2 q\2'

# export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
# . <(asdf completion bash)

eval "$(ssh-agent -s)" >/dev/null

alias ls="eza -1 --icons=always --group-directories-first -t=modified -l --git --no-user --time-style=relative"
alias reload="source ~/.bashrc"
alias tm="tmux attach"
alias cc="cliphist list | fzf | cliphist decode | wl-copy"
alias update='sudo timeshift-autosnap yay -Syu'
alias finder="nautilus . >/dev/null 2>&1 &"
alias yolo="claude --dangerously-skip-permissions --continue"
alias yolonew="claude --dangerously-skip-permissions"

alias vpn-up='sudo systemctl start openvpn-client@ireland'
alias vpn-down='sudo systemctl stop openvpn-client@ireland'
alias vpn-log='journalctl -u openvpn-client@ireland -f'

transcode-video-shrink() {
  ffmpeg -y -i "$1" -c:v libx264 -preset veryfast "$2"
}

unset GNOME_KEYRING_CONTROL
unset SSH_AUTH_SOCK
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
