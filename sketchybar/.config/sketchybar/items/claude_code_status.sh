#!/usr/bin/env bash

source "$CONFIG_DIR/environment"
source "$THEME_DIR/rosepine-moon"

CLAUDE_LABEL_COLOR="$magenta"
CLAUDE_BACKGROUND_BORDER_COLOR="$magenta"

sketchybar --add item claude_code_spacer_right right \
  --set claude_code_spacer_right \
  background.drawing=off

sketchybar --add item claude_code_status right \
  --set claude_code_status \
  background.drawing=off \
  icon.drawing=on \
  icon="󰚩" \
  icon.color="$cyan" \
  icon.padding_left="$LABEL_PADDING" \
  icon.padding_right="$LABEL_PADDING" \
  label.color="$CLAUDE_LABEL_COLOR" \
  label.padding_left=0 \
  label.padding_right=0 \
  update_freq=1 \
  script="$PLUGIN_DIR/claude_code_status.sh"

sketchybar --add bracket claude_code_bracket claude_code_status claude_code_spacer_right \
  --set claude_code_bracket \
  background.border_color="$CLAUDE_BACKGROUND_BORDER_COLOR" \
  background.corner_radius="$BRACKET_BACKGROUND_CORNER_RADIUS" \
  background.border_width="$BRACKET_BACKGROUND_BORDER_WIDTH"
