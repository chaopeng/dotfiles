#!/bin/bash


# resize current window and next window's height to 50%. stack them vertically. ensure width is 100%. focus current window.
if niri msg action consume-window-into-column; then
    niri msg action set-column-width "100%"
    niri msg action set-window-height "50%"
    niri msg action move-window-up
fi
