#!/bin/bash

# focus or start Obsidian on the 'Notes' workspace.

APP_ID="obsidian"
WORKSPACE_NAME="Notes"

# 1. Check and get Obsidian's numerical ID
get_id() {
    niri msg -j windows | jq -r ".[] | select(.app_id == \"$APP_ID\") | .id" | head -n 1
}

WIN_ID=$(get_id)

# 2. Start if not exists
if [ -z "$WIN_ID" ] || [ "$WIN_ID" == "null" ]; then
    systemctl --user start obsidian.service
    
    # Poll and wait for window to appear and get new ID
    for i in {1..20}; do
        sleep 0.5
        WIN_ID=$(get_id)
        if [ -n "$WIN_ID" ] && [ "$WIN_ID" != "null" ]; then break; fi
    done
fi

# 3. Confirm ID is obtained again
if [ -z "$WIN_ID" ] || [ "$WIN_ID" == "null" ]; then
    echo "Could not find Obsidian window ID"
    exit 1
fi

# 4. Move and focus (using --id)
niri msg action focus-workspace "$WORKSPACE_NAME"
niri msg action focus-window --id "$WIN_ID"
