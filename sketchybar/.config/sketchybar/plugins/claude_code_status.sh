#!/bin/bash

# Check if Claude Code is working
if [ -f ~/.config/claude_code_status ]; then
  sketchybar -m --set $NAME drawing=on label="Claude is working…"
  sketchybar -m --set claude_code_bracket drawing=on
  sketchybar -m --set bracket_spacer_1 drawing=on
else
  sketchybar -m --set $NAME drawing=off
  sketchybar -m --set claude_code_bracket drawing=off
  sketchybar -m --set bracket_spacer_1 drawing=off
fi
