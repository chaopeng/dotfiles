#!/bin/bash

# focus or start Gemini, move it to the current workspace, and arrange it in a 50/50 split with the original window.

APP_ID="chrome-gdfaincndogidkdcdkhapmbffkckdkhn-Default"
DESKTOP_PATH="$HOME/.local/share/applications/$APP_ID.desktop"

# Get Gemini's numerical ID
get_id() {
    niri msg -j windows | jq -r ".[] | select(.app_id == \"$APP_ID\") | .id" | head -n 1
}

# 1. Capture current context BEFORE we start switching focus
CUR_WINDOW=$(niri msg -j windows | jq -r '.[] | select(.is_focused)')
CUR_WINDOW_ID=$(echo "$CUR_WINDOW" | jq -r '.id')
# Use idx or name as reference for move-window-to-workspace
CUR_WS=$(niri msg -j workspaces | jq -r '.[] | select(.is_focused) | if .name != null then .name else .idx end')
CUR_COL_INDEX=$(echo "$CUR_WINDOW" | jq -r '.layout.pos_in_scrolling_layout[0]')

WIN_ID=$(get_id)

if [ -z "$WIN_ID" ] || [ "$WIN_ID" == "null" ]; then
    echo "Gemini not running, starting..."
    gio launch "$DESKTOP_PATH"
    
    for i in {1..20}; do
        sleep 0.5
        WIN_ID=$(get_id)
        if [ -n "$WIN_ID" ] && [ "$WIN_ID" != "null" ]; then break; fi
    done
fi

if [ -n "$WIN_ID" ] && [ "$WIN_ID" != "null" ]; then
    echo "Gemini window found ($WIN_ID). Moving to workspace $CUR_WS..."
    
    # Move to current workspace (non-focused move)
    niri msg action move-window-to-workspace --window-id "$WIN_ID" "$CUR_WS"
    
    # Focus Gemini
    niri msg action focus-window --id "$WIN_ID"
    
    # Reorder to be after the original window
    if [ -n "$CUR_COL_INDEX" ] && [ "$CUR_COL_INDEX" != "null" ]; then
        niri msg action move-column-to-index $((CUR_COL_INDEX + 1))
    fi
    
    # Wait a bit for the move/reorder to settle before resizing
    sleep 0.1
    
    # Resize both to 50%
    if [ -n "$CUR_WINDOW_ID" ] && [ "$CUR_WINDOW_ID" != "null" ] && [ "$CUR_WINDOW_ID" != "$WIN_ID" ]; then
        # Set Gemini to 50%
        niri msg action set-column-width "50%"
        
        # Focus original window and set to 50%
        niri msg action focus-window --id "$CUR_WINDOW_ID"
        echo "Focusing original window ($CUR_WINDOW_ID)..."
        niri msg action set-column-width "50%"
        
        # Focus back to Gemini
        niri msg action focus-window --id "$WIN_ID"
    else
        # Just resize Gemini if no original window
        niri msg action set-column-width "50%"
    fi
else
    echo "Error: Could not find or start Gemini."
    exit 1
fi

