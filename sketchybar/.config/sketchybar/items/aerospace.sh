#!/usr/bin/env bash

source "$CONFIG_DIR/environment"
source "$THEME_DIR/rosepine-moon"

# Workspace ID to name/icon mappings
declare -A WORKSPACE_NAMES=(
  [1]="󰎤"
  [2]="󰎧"
  [3]="󰎪"
  [4]="󰎭"
  [5]="󰎱"
  [6]="󰎳"
  [7]="󰎶"
  [8]="󰎹"
  [9]="󰎼"
)

declare -A WORKSPACE_ICONS=(
  [1]="" # web: globe
  [2]="" # code: terminal/code
  [3]="" # support: chat bubble
  [4]="" #o misc: menu or list  [1]="🌐"
  [5]=""
  [6]="󰒱"
  [7]="󰊠"
  [8]=""
  [9]="󰓇"
)

create_workspace_bracket_for_monitor() {
  parameters=("$@")
  monitor_id=${parameters[0]}
  monitor_workspaces=("${parameters[@]:1}")

  if [ "$monitor_id" -eq 1 ]; then
    sketchybar --add item workspaces_spacer_left left \
      --set workspaces_spacer_left \
      width=6 \
      background.drawing=off \
      label.drawing=off
  fi

  for workspace_id in "${monitor_workspaces[@]}"; do
    workspace_name="${WORKSPACE_NAMES[$workspace_id]:-$workspace_id}"
    workspace_icon="${WORKSPACE_ICONS[$workspace_id]:-}"

    sketchybar --add item workspaces."$monitor_id"."$workspace_id" left \
      --subscribe workspaces."$monitor_id"."$workspace_id" aerospace_workspace_change \
      --set workspaces."$monitor_id"."$workspace_id" \
      background.drawing=off \
      click_script="aerospace workspace $workspace_id" \
      label="$workspace_name" \
      label.padding_left=6 \
      label.font.size="22" \
      icon="$workspace_icon" \
      icon.drawing=yes \
      icon.font.size="16" \
      icon.padding_left="$LABEL_PADDING" \
      script="$PLUGIN_DIR/aerospace.sh $workspace_id"
  done

  if [ "$monitor_id" -lt "${#monitor_ids[@]}" ]; then
    sketchybar --add item workspaces_monitor_separator."$monitor_id" left \
      --set workspaces_monitor_separator."$monitor_id" \
      background.drawing=off \
      label.padding_left=-6 \
      label.font.size="$BACKGROUND_HEIGHT" \
      label="|"
  else
    sketchybar --add item workspaces_service_mode left \
      --subscribe workspaces_service_mode aerospace_service_mode_enabled_changed \
      --set workspaces_service_mode \
      background.drawing=off \
      label.drawing=off \
      label.highlight=on \
      label.font="$LABEL_HIGHLIGHT_FONT" \
      label="[s]" \
      label.padding_right=20 \
      script="$PLUGIN_DIR/aerospace.sh $AEROSPACE_SERVICE_MODE_ENABLED"

    sketchybar --add item workspaces_spacer_right left \
      --set workspaces_spacer_right \
      width=6 \
      background.drawing=off \
      label.drawing=off
  fi

  sketchybar --add bracket workspaces."$monitor_id" /workspaces\.*/ \
    --set workspaces."$monitor_id" \
    background.padding_left="50" \
    background.corner_radius="$BRACKET_BACKGROUND_CORNER_RADIUS" \
    background.border_width="$BRACKET_BACKGROUND_BORDER_WIDTH"
}

sketchybar --add event aerospace_workspace_change
sketchybar --add event aerospace_service_mode_enabled_changed

monitor_ids=($(aerospace list-monitors | awk '{print $1}'))

for monitor_id in "${monitor_ids[@]}"; do
  workspaces_for_monitor_id=($(aerospace list-workspaces --monitor "$monitor_id"))
  create_workspace_bracket_for_monitor "$monitor_id" "${workspaces_for_monitor_id[@]}"
done
