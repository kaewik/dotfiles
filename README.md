# Dotfiles

Personal macOS setup managed with [chezmoi](https://www.chezmoi.io/).

## Install

Run this in a new account (replace the GitHub username):

```sh
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply YOUR_GITHUB_USERNAME
```

The first apply installs Homebrew if needed, then Mise and the standalone OpenCode
binary. Global CLI tools are listed in `~/.config/mise/config.toml`; tool versions
for individual projects belong in those projects' own `mise.toml` files.

## What's included

- Zsh, Oh My Zsh, and Powerlevel10k
- Neovim with LazyVim
- OpenCode V2 via its native installer (no global Node.js required; update with `opencode upgrade`)
- Mise-managed global CLI tools: Neovim, tmux, lazygit, ripgrep, fd, delta, and tree-sitter
- Delta is pinned to 0.18.2 on Intel Macs because newer upstream releases no longer include Intel macOS binaries.
- Hack Nerd Font in `~/Library/Fonts/Hack`

## Workflow

Edit managed files through chezmoi, then apply them:

```sh
chezmoi edit ~/.zshrc
chezmoi apply -v
```

To commit a change, stage only the intended file(s):

```sh
chezmoi cd
git add dot_zshrc
git commit -m "Update zsh config"
git push
```

Useful checks: `chezmoi diff`, `chezmoi managed`, and `mise ls`.
