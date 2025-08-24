#!/bin/bash

apply_workspace_padding() {
  local workspace=$1
  # Get the current monitor for the workspace
  current_monitor=$(hyprctl workspaces -j | jq -r ".[] | select(.id==$workspace) | .monitor")

  if [ "$current_monitor" != "eDP-1" ] && [ -n "$current_monitor" ]; then
    # Apply padding when on external monitor (clamshell mode)
    hyprctl keyword workspace "$workspace, gapsout:100 100 100 100"
  else
    # No padding on laptop display
    hyprctl keyword workspace "$workspace, gapsout:10"
  fi
}

if [[ "$1" == "open" ]]; then
  hyprctl keyword monitor "eDP-1, 2880x1920@120, 0x0, 2"
  # Small delay to ensure monitor is configured
  sleep 0.5
  # Check and apply padding for workspaces 1 and 2
  apply_workspace_padding 1
  apply_workspace_padding 2
else
  hyprctl keyword monitor "eDP-1, disable"
  # Small delay to ensure monitor is disabled
  sleep 0.5
  # When laptop lid is closed (clamshell mode), apply padding to external monitor
  apply_workspace_padding 1
  apply_workspace_padding 2
fi
