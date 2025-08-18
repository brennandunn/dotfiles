#!/usr/bin/env bash

# Rosé Pine Moon Palette
black="0xff232136"
blue="0xff3e8fb0"
blue1="0xff2a273f"
cyan="0xff9ccfd8"
green="0xff95b1ac"
magenta="0xffc4a7e7"
orange="0xfff6c177"
purple="0xffc4a7e7"
red="0xffeb6f92"
transparent="0x00000000"
white="0xffe0def4"
yellow="0xfff6c177"

# Additional colors
base="0xff232136"
surface="0xff2a273f"
overlay="0xff393552"
muted="0xff6e6a86"
subtle="0xff908caa"
subtle_blue="0xff6e6a86" # More muted blue for inactive items
rose="0xffea9a97"
rose_muted="0xff9b7874" # Muted variant of rose
highlight_low="0xff2a283e"
highlight_med="0xff44415a"
highlight_high="0xff56526e"

# Bar
## Colors
BAR_COLOR="$transparent"
BAR_BLUR_RADIUS=30

## Geometry
BAR_POSITION="top"
BAR_HEIGHT=34
BAR_PADDING=0
BAR_Y_OFFSET=9
BAR_CORNER_RADIUS=12
BAR_MARGIN=21

# Item Defaults
## Colors
BACKGROUND_COLOR="$surface"
BACKGROUND_BORDER_COLOR="$blue"
BACKGROUND_BORDER_WIDTH=0
LABEL_ALIGN="center"
LABEL_COLOR="$rose_muted"
LABEL_HIGHLIGHT_COLOR="$yellow"

## Fonts
ICON_BASE_FONT="CaskaydiaMono Nerd Font"
# ICON_BASE_FONT="Hack Nerd Font"
ICON_FONT="$ICON_BASE_FONT:Bold:14.0"
LABEL_BASE_FONT="Hack Nerd Font"
LABEL_FONT="$LABEL_BASE_FONT:Regular:14.0"
LABEL_HIGHLIGHT_FONT="$LABEL_BASE_FONT:ExtraBold:14.0"

## Geometry
BACKGROUND_CORNER_RADIUS=4
BACKGROUND_HEIGHT=34
LABEL_Y_OFFSET=0
LABEL_PADDING=11
BRACKET_BACKGROUND_BORDER_WIDTH=1
BRACKET_BACKGROUND_CORNER_RADIUS=8
