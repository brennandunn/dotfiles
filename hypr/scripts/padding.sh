#!/bin/sh

# add to autostart.conf: exec-once = ~/.config/hypr/scripts/better-padding.sh

# gapsout for when there's just one window
solo_padding=100

# gapsout for when 2+ windows
plural_padding=10

# if there's a monitor you want to disable bigger padding on, e.g. your laptop's built-in display
disable_on="eDP-1"

# Ensure only one instance runs
PIDFILE="/tmp/hypr-padding-${HYPRLAND_INSTANCE_SIGNATURE}.pid"

# Handle stop parameter
if [ "$1" = "stop" ]; then
  if [ -f "$PIDFILE" ]; then
    OLD_PID=$(cat "$PIDFILE")
    if kill -0 "$OLD_PID" 2>/dev/null; then
      echo "Stopping padding.sh (PID: $OLD_PID)"
      # Kill child processes first (socat)
      pkill -P "$OLD_PID" 2>/dev/null
      # Then kill the main process
      kill "$OLD_PID" 2>/dev/null
      rm -f "$PIDFILE"
    else
      echo "Process not running, removing stale pidfile"
      rm -f "$PIDFILE"
    fi
  else
    echo "padding.sh is not running"
  fi
  exit 0
fi

# Check if another instance is running
if [ -f "$PIDFILE" ]; then
  OLD_PID=$(cat "$PIDFILE")
  if kill -0 "$OLD_PID" 2>/dev/null; then
    echo "padding.sh already running with PID $OLD_PID"
    exit 0
  else
    echo "Removing stale pidfile"
    rm -f "$PIDFILE"
  fi
fi

# Store current PID
echo $$ >"$PIDFILE"

# Cleanup on exit
trap "rm -f $PIDFILE" EXIT INT TERM

adjust_padding() {
  current_workspace_id=$(hyprctl activeworkspace -j | jq -r '.id')
  current_monitor=$(hyprctl activeworkspace -j | jq -r '.monitor')
  window_count=$(hyprctl activeworkspace -j | jq -r '.windows')

  if [[ "$current_monitor" == "$disable_on" ]] || [[ $window_count -gt 1 ]]; then
    hyprctl keyword workspace "$current_workspace_id, gapsout:$plural_padding"
  else
    hyprctl keyword workspace "$current_workspace_id, gapsout:$solo_padding"
  fi

}

handle() {
  case $1 in
  openwindow*) adjust_padding ;;
  closewindow*) adjust_padding ;;
  workspace*) adjust_padding ;;
  configreloaded*) adjust_padding ;;
  esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
