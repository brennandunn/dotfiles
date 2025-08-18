#!/usr/bin/env bash

source "$CONFIG_DIR/environment"
source "$THEME_DIR/rosepine-moon"

CLOCK_LABEL_COLOR="$magenta"
CLOCK_BACKGROUND_BORDER_COLOR="$magenta"

sketchybar --add item spotify_spacer_right right \
  --set spotify_spacer_right \
  background.drawing=off

sketchybar --add item spotify right \
  --set spotify \
  background.drawing=off \
  icon.color="$red" \
  icon="󰓇" \
  icon.drawing=on \
  icon.padding_left="$LABEL_PADDING" \
  icon.padding_right="$LABEL_PADDING" \
  label.color="$CLOCK_LABEL_COLOR" \
  label.padding_left=0 \
  label.padding_right=0 \
  update_freq=10 \
  click_script="aerospace workspace 5" \
  script="$PLUGIN_DIR/spotify.sh"

sketchybar --add bracket spotify_bracket spotify spotify_spacer_right \
  --set spotify_bracket \
  background.border_color="$CLOCK_BACKGROUND_BORDER_COLOR" \
  background.corner_radius="$BRACKET_BACKGROUND_CORNER_RADIUS" \
  background.border_width="$BRACKET_BACKGROUND_BORDER_WIDTH"
