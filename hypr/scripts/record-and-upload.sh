#!/bin/bash

# Configuration
[[ -f ~/.config/user-dirs.dirs ]] && source ~/.config/user-dirs.dirs
OUTPUT_DIR="${SCREENRECORD_DIR:-${XDG_VIDEOS_DIR:-$HOME/Videos}/ScreenRecordings}"
LOCKFILE="/tmp/screenrecord.lock"
RESOLUTION_FILE="/tmp/screenrecord_original_resolution"

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# Helper functions
notify() {
    notify-send "Screen Recorder" "$1" -t "${2:-2000}"
}

error_exit() {
    notify "$1" 3000 -u critical
    cleanup
    exit 1
}

cleanup() {
    # Restore original resolution if it was changed
    if [[ -f "$RESOLUTION_FILE" ]]; then
        original_res=$(cat "$RESOLUTION_FILE")
        current_output=$(get_current_output)
        wlr-randr --output "$current_output" --mode "$original_res"
        rm -f "$RESOLUTION_FILE"
        notify "Resolution restored to $original_res"
    fi
    rm -f "$LOCKFILE"
}

get_current_output() {
    wlr-randr | grep -E "^[A-Za-z]+" | head -1 | awk '{print $1}'
}

change_resolution() {
    local scale="$1"
    local current_output=$(get_current_output)
    local current_res=$(wlr-randr | grep -A1 "$current_output" | grep -oE "[0-9]+x[0-9]+" | head -1)
    
    # Save original resolution
    echo "$current_res" > "$RESOLUTION_FILE"
    
    # Calculate new resolution based on scale
    local width=$(echo "$current_res" | cut -dx -f1)
    local height=$(echo "$current_res" | cut -dx -f2)
    local new_width=$((width * 100 / scale))
    local new_height=$((height * 100 / scale))
    
    # Find closest available resolution
    local available_res=$(wlr-randr | grep -oE "[0-9]+x[0-9]+" | sort -t'x' -k1 -n -r)
    local best_res=""
    local min_diff=999999
    
    while IFS= read -r res; do
        local res_width=$(echo "$res" | cut -dx -f1)
        local diff=$((res_width > new_width ? res_width - new_width : new_width - res_width))
        if [[ $diff -lt $min_diff ]]; then
            min_diff=$diff
            best_res=$res
        fi
    done <<< "$available_res"
    
    if [[ -n "$best_res" ]]; then
        wlr-randr --output "$current_output" --mode "$best_res"
        notify "Resolution changed to $best_res (scale ${scale}%)"
        sleep 2  # Give time for resolution change to settle
    fi
}

start_recording() {
    local temp_file="/tmp/recording-$(date +'%Y-%m-%d_%H-%M-%S').mp4"
    local audio_opts=""
    local region_opts=""
    
    # Audio configuration
    case "${AUDIO_SOURCE:-both}" in
        mic)
            audio_opts="--audio --audio-source alsa_input.pci-0000_00_1f.3.analog-stereo"
            ;;
        system)
            audio_opts="--audio --audio-source alsa_output.pci-0000_00_1f.3.analog-stereo.monitor"
            ;;
        both|*)
            # Record both microphone and system audio
            audio_opts="--audio"
            ;;
    esac
    
    # Region selection
    if [[ "$1" != "output" ]]; then
        region=$(slurp -b "#00000066" -c "#ff0000ff" -w 2) || error_exit "Recording cancelled"
        region_opts="-g $region"
    fi
    
    # Save recording info
    echo "$temp_file" > "$LOCKFILE"
    
    # Countdown
    for i in 3 2 1; do
        notify "Recording starts in $i..." 500
        sleep 1
    done
    
    notify "🔴 Recording started" 1500
    
    # Start recording based on GPU - redirect output to suppress FPS spam
    if lspci | grep -qi 'nvidia'; then
        wf-recorder -f "$temp_file" \
            -c h264_nvenc \
            -p preset=medium \
            -p crf=23 \
            $audio_opts \
            $region_opts >/dev/null 2>&1 &
    else
        if [[ -n "$region_opts" ]]; then
            # wl-screenrec uses --geometry instead of -g
            wl-screenrec -f "$temp_file" \
                --geometry "${region}" \
                $audio_opts >/dev/null 2>&1 &
        else
            wl-screenrec -f "$temp_file" \
                $audio_opts >/dev/null 2>&1 &
        fi
    fi
    
    echo $! >> "$LOCKFILE"
    
    # Detach from terminal if running interactively
    if [[ -t 0 ]]; then
        disown
    fi
}

stop_recording() {
    if [[ ! -f "$LOCKFILE" ]]; then
        # Check if there's an orphaned recording process
        if pgrep -x wl-screenrec >/dev/null || pgrep -x wf-recorder >/dev/null; then
            notify "⚠️ Found orphaned recording, stopping..." 2000
            pkill -SIGINT -x wl-screenrec 2>/dev/null
            pkill -SIGINT -x wf-recorder 2>/dev/null
            sleep 2
            notify "Recording stopped (no file saved)" 2000
            return
        fi
        error_exit "No recording in progress"
    fi
    
    local temp_file=$(head -1 "$LOCKFILE")
    local pid=$(tail -1 "$LOCKFILE")
    
    # Stop recording - try graceful stop first
    if kill -0 "$pid" 2>/dev/null; then
        kill -SIGINT "$pid" 2>/dev/null
    else
        # Process doesn't exist, try to find by name
        pkill -SIGINT -x wl-screenrec 2>/dev/null
        pkill -SIGINT -x wf-recorder 2>/dev/null
    fi
    sleep 2  # Wait for file to be written
    
    notify "⏹️ Recording stopped, optimizing..." 2000
    
    # Generate final filename
    local final_file="$OUTPUT_DIR/screenrec-$(date +'%Y%m%d-%H%M%S').mp4"
    
    # Optimize video with ffmpeg
    ffmpeg -i "$temp_file" \
        -c:v libx264 \
        -preset slow \
        -crf 22 \
        -c:a aac \
        -b:a 128k \
        -movflags +faststart \
        -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" \
        "$final_file" -y 2>/dev/null
    
    if [[ ! -f "$final_file" ]]; then
        # Fallback: just move the original if optimization fails
        mv "$temp_file" "$final_file"
        notify "⚠️ Optimization failed, saved original" 2000
    else
        rm -f "$temp_file"
        notify "✅ Recording saved to ScreenRecordings" 3000
    fi
    
    # Copy path to clipboard
    echo -n "$final_file" | wl-copy
    notify "📋 File path copied to clipboard" 2000
    
    # Optional: Open in file manager
    if [[ "${AUTO_OPEN_FOLDER:-false}" == "true" ]]; then
        xdg-open "$OUTPUT_DIR" &
    fi
    
    # Save metadata
    echo "Recorded: $(date)" > "${final_file}.info"
    echo "Duration: $(ffprobe -v quiet -print_format json -show_format "$final_file" | jq -r '.format.duration' 2>/dev/null) seconds" >> "${final_file}.info"
    echo "Size: $(du -h "$final_file" | cut -f1)" >> "${final_file}.info"
    
    cleanup
}

# Signal handlers
handle_interrupt() {
    if [[ -f "$LOCKFILE" ]]; then
        notify "⚠️ Recording interrupted" 1000
        stop_recording
    fi
    exit 0
}

# Main logic
trap cleanup EXIT
trap handle_interrupt SIGINT SIGTERM

# Parse arguments
SCALE=""
AUDIO_SOURCE="both"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --scale)
            SCALE="$2"
            shift 2
            ;;
        --audio)
            AUDIO_SOURCE="$2"
            shift 2
            ;;
        --output)
            MODE="output"
            shift
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --scale PERCENT    Temporarily reduce resolution (e.g., --scale 150 for 150% UI scale)"
            echo "  --audio SOURCE     Audio source: mic, system, both (default: both)"
            echo "  --output           Record full output instead of region"
            echo ""
            echo "Environment variables:"
            echo "  SCREENRECORD_DIR    Output directory (default: ~/Videos/ScreenRecordings)"
            echo "  AUTO_OPEN_FOLDER    Open output folder after recording (default: false)"
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done

# Check for any running recording processes first
if pgrep -x wl-screenrec >/dev/null || pgrep -x wf-recorder >/dev/null; then
    # Recording is running - stop it
    if [[ -f "$LOCKFILE" ]]; then
        # Normal stop with lockfile
        stop_recording
    else
        # Orphaned process - just kill it
        notify "⚠️ Found orphaned recording, stopping..." 2000
        pkill -SIGINT -x wl-screenrec 2>/dev/null
        pkill -SIGINT -x wf-recorder 2>/dev/null
        sleep 2
        # Clean up any stale lockfile
        rm -f "$LOCKFILE"
        notify "Recording stopped (orphaned process)" 2000
    fi
else
    # No recording running - start new one
    if [[ -f "$LOCKFILE" ]]; then
        # Stale lockfile - remove it
        rm -f "$LOCKFILE"
    fi
    
    # Change resolution if requested
    if [[ -n "$SCALE" ]]; then
        change_resolution "$SCALE"
    fi
    
    # Start recording
    start_recording "${MODE:-region}"
fi