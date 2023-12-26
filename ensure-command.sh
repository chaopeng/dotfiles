#!/usr/bin/env bash

# Ensure the command exists

if ! command -v "$command" >/dev/null 2>&1; then
  echo "Error: '$command' is not installed. Please install it and try again." >&2
  exit 1
fi