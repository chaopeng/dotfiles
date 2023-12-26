#!/usr/bin/env bash

# Ensure the command exists

if ! command -v "$1" >/dev/null 2>&1; then
  echo "Error: '$1' is not installed. Please install it and try again." >&2
  exit 1
fi