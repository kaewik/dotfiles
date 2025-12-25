#!/bin/bash
set -e

# 1. Paths
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CHEZMOI_DIR="$HOME/.local/share/chezmoi"
BIN_DIR="$HOME/.local/bin"

# 2. Install chezmoi if missing
if ! command -v chezmoi >/dev/null 2>&1; then
  mkdir -p "$BIN_DIR"
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$BIN_DIR"
  export PATH="$BIN_DIR:$PATH"
fi

# 3. Force the connection
# If the repo isn't where chezmoi expects it, symlink it.
if [ "$REPO_DIR" != "$CHEZMOI_DIR" ]; then
    echo "Connecting $REPO_DIR to Chezmoi..."
    mkdir -p "$(dirname "$CHEZMOI_DIR")"
    # Remove if it exists as a folder, then symlink
    rm -rf "$CHEZMOI_DIR"
    ln -sf "$REPO_DIR" "$CHEZMOI_DIR"
fi

# 4. Apply
echo "Applying dotfiles..."
# We use --force to overwrite existing .zshrc files 
# We use -v (verbose) so you can see your scripts running!
chezmoi apply -v
