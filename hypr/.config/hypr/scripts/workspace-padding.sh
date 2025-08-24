#!/bin/bash
# Apply workspace 2 padding only when NOT on eDP-1

# Get the current monitor for workspace 2
current_monitor=$(hyprctl workspaces -j | jq -r '.[] | select(.id==2) | .monitor')

if [ "$current_monitor" != "eDP-1" ] && [ -n "$current_monitor" ]; then
  # Apply padding when on external monitor
  hyprctl keyword workspace "2, gapsout:100 100 100 100"
  hyprctl keyword workspace "1, gapsout:100 100 100 100"
else
  # No padding on laptop display
  hyprctl keyword workspace "2, gapsout:10"
  hyprctl keyword workspace "1, gapsout:10"
fi

