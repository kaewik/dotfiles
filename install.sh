#!/bin/bash
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# Switch to the desired branch first, before any other logic runs.
# exec replaces this process with the branch's install.sh so it runs from scratch.
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

        exec "$REPO_DIR/install.sh"
    fi
fi

# Symlink XDG directories to custom paths if requested.
# Avoids cross-device rename errors when these are separate bind mounts.
for var_suffix in CONFIG CACHE DATA; do
    var="DOTFILES_LINK_XDG_${var_suffix}"
    target="${!var}"
    if [ -n "$target" ]; then
        case "$var_suffix" in
            CONFIG) link="${XDG_CONFIG_HOME:-$HOME/.config}" ;;
            CACHE)  link="${XDG_CACHE_HOME:-$HOME/.cache}" ;;
            DATA)   link="${XDG_DATA_HOME:-$HOME/.local/share}" ;;
        esac
        echo "Linking $link → $target"
        mkdir -p "$(dirname "$link")"
        ln -sfn "$target" "$link"
    fi
done

# Paths
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

# Remove stale chezmoi config and state so init regenerates from the template.
rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi"

# Init (processes .chezmoi.toml.tmpl) and apply.
# Without --source, chezmoi creates its source symlink at $XDG_DATA_HOME/chezmoi
# (e.g. on a persistent mount), leaving a dangling symlink on the host pointing
# to a container-internal path. --source keeps the symlink at ~/.local/share/chezmoi.
echo "Applying dotfiles..."
chezmoi init --apply --force --source "$CHEZMOI_DIR"
