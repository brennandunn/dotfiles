if status is-interactive
    set fish_greeting
    fish_config theme choose "Rosé Pine Moon"
    zoxide init fish | source
    set -g fish_key_bindings fish_vi_key_bindings
    # Commands to run in interactive sessions can go here
end
