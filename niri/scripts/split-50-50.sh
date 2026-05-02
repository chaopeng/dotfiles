#!/bin/bash

# resize current column and next column's width to 50% and height to 100%. focus current column.
niri msg action expel-window-from-column
niri msg action set-column-width "50%"
niri msg action set-window-height "100%"

if niri msg action focus-column-right; then
    niri msg action set-column-width "50%"
    niri msg action set-window-height "100%"
    niri msg action focus-column-left
fi