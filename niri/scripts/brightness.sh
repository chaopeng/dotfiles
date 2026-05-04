#!/bin/bash
# Control screen brightness for DDC monitors and integrated backlights.
# Uses ddcutil for fast detection/reading and dms ipc for fast adjustment.
# Usage: brightness.sh [+|-]

# Configuration
STEP=5
OP=$1 # + or -

if [[ "$OP" != "+" && "$OP" != "-" ]]; then
    echo "Usage: $0 [+|-]"
    exit 1
fi

# Check if ddcutil exists
if ! command -v ddcutil >/dev/null 2>&1; then
    dms notify "Brightness Error" "ddcutil not found."
    exit 0
fi

# Use ddcutil to detect DDC monitors
DDC_INFO=$(ddcutil detect --brief 2>/dev/null)
DDC_COUNT=$(echo "$DDC_INFO" | grep -c "^Display [0-9]\+")

DEVICE=""
if [ "$DDC_COUNT" -gt 1 ]; then
    dms notify "Brightness" "Multiple DDC devices found."
    exit 1
elif [ "$DDC_COUNT" -eq 1 ]; then
    # Parse I2C bus ID (e.g., i2c-2)
    BUS_ID=$(echo "$DDC_INFO" | grep -A 1 "^Display [0-9]\+" | grep "I2C bus:" | awk -F'/' '{print $NF}' | xargs)
    DEVICE="ddc:$BUS_ID"
else
    # Fallback to backlight
    DEVICE=$(dms brightness list 2>/dev/null | grep "^backlight:" | awk '{print $1}' | head -n 1)
    if [ -z "$DEVICE" ]; then
        dms notify "Brightness" "No brightness devices found."
        exit 1
    fi
fi

# Determine action
ACTION="increment"
[ "$OP" == "-" ] && ACTION="decrement"

# Set new brightness via IPC (fastest method)
dms ipc call brightness "$ACTION" "$STEP" "$DEVICE" > /dev/null
