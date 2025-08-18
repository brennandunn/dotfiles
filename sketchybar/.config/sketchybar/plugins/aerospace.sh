#!/usr/bin/env bash

source "$CONFIG_DIR/environment"
source "$THEME_DIR/rosepine-moon"

if [ "$SENDER" = "aerospace_service_mode_enabled_changed" ]; then
  if [ "$AEROSPACE_SERVICE_MODE_ENABLED" = true ]; then
    sketchybar --set workspaces_service_mode \
      label.drawing=on
  else
    sketchybar --set workspaces_service_mode \
      label.drawing=off
  fi
fi

if [ "$SENDER" = "aerospace_workspace_change" ]; then
  if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME \
      icon.highlight=on \
      label.highlight=on
  else
    sketchybar --set $NAME \
      icon.highlight=off \
      label.highlight=off
  fi
fi
