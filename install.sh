#!/bin/bash
set -e

# 1. Determine where this script is running (the repo root)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 2. Ensure chezmoi is installed
bin_dir="$HOME/.local/bin"
if ! command -v chezmoi >/dev/null 2>&1; then
  mkdir -p "$bin_dir"
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$bin_dir"
  export PATH="$bin_dir:$PATH"
fi

# 3. Initialize and Apply using the current directory as the source
# The 'init' command with --apply and --source tells chezmoi:
# "Use this folder as the source of truth from now on."
chezmoi init --apply --source="$SCRIPT_DIR"
