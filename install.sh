#!/bin/bash
set -e

# Paths
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CHEZMOI_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi"
BIN_DIR="$HOME/.local/bin"

# Install chezmoi if missing
if ! command -v chezmoi >/dev/null 2>&1; then
  mkdir -p "$BIN_DIR"
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$BIN_DIR"
  export PATH="$BIN_DIR:$PATH"
fi

# Force the connection
# If the repo isn't where chezmoi expects it, symlink it.
if [ "$REPO_DIR" != "$CHEZMOI_DIR" ]; then
    echo "Connecting $REPO_DIR to Chezmoi..."
    mkdir -p "$(dirname "$CHEZMOI_DIR")"
    # Remove if it exists as a folder, then symlink
    rm -rf "$CHEZMOI_DIR"
    ln -sf "$REPO_DIR" "$CHEZMOI_DIR"
fi

# Switch to the desired branch if not already on it
if [ -d "$REPO_DIR/.git" ] && [ -n "$DOTFILES_BRANCH" ]; then
    CURRENT_BRANCH="$(git -C "$REPO_DIR" rev-parse --abbrev-ref HEAD)"

    if [ "$CURRENT_BRANCH" != "$DOTFILES_BRANCH" ]; then
        echo "Checking out branch: $DOTFILES_BRANCH"
        cd "$REPO_DIR"

        git fetch origin "$DOTFILES_BRANCH" --depth=1

        if git checkout -B "$DOTFILES_BRANCH" FETCH_HEAD; then
            echo "✅ Successfully switched to $DOTFILES_BRANCH"
        else
            echo "❌ Failed to switch to $DOTFILES_BRANCH"
        fi
        cd - > /dev/null

        # Re-exec so the branch's install.sh runs instead of the one loaded in memory.
        # exec replaces this process entirely — nothing after it executes.
        exec "$REPO_DIR/install.sh"
    fi
fi

# Init (processes .chezmoi.toml.tmpl) and apply
echo "Applying dotfiles..."
chezmoi init --apply --force
