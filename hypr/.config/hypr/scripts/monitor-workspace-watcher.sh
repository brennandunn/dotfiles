#!/bin/bash
# Monitor workspace 2 and apply padding when moved between monitors

apply_workspace_padding() {
    # Get the current monitor for workspace 2
    current_monitor=$(hyprctl workspaces -j | jq -r '.[] | select(.id==2) | .monitor')
    
    if [ "$current_monitor" != "eDP-1" ] && [ -n "$current_monitor" ]; then
        # Apply padding when on external monitor
        hyprctl keyword workspace "2, gapsout:100 100 100 100"
    else
        # No padding on laptop display
        hyprctl keyword workspace "2, gapsout:0"
    fi
}

# Apply initial configuration
apply_workspace_padding

# Listen for workspace events
socat - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read line; do
    case $line in
        workspace>>2|moveworkspacetomonitor>>*)
            # Workspace 2 activated or workspace moved to monitor
            apply_workspace_padding
            ;;
        monitoradded>>*|monitorremoved>>*)
            # Monitor configuration changed
            apply_workspace_padding
            ;;
    esac
done
