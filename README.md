# 🚀 Dotfiles

My personal setup for **WSL (Ubuntu)**, **Devcontainers (Debian)**, and **macOS**. 
Managed with [Chezmoi](https://www.chezmoi.io/).

## ✨ Highlights

* **Shell:** Zsh with Oh My Zsh & Powerlevel10k.
* **Editor:** Neovim (installed via **Mise**).
* **Search:** ```ripgrep``` (live grep) and ```fd``` (find).
* **Languages:** Rust toolchain (via **Mise**).
* **Fonts:** Hack Nerd Font (automatically handled via Chezmoi Externals).

---

## 🛠️ Installation / Bootstrap

To install this setup on a new machine or a fresh container, run:

```bash
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply <your-github-username>
```

*In a Devcontainer:* The repository is cloned, and ```install.sh``` automatically triggers the Chezmoi process.
*Note*: Use the `--dotfiles-repository` flag with the Devcontainer CLI.

#### Environment Variables

| Variable | Description |
| :--- | :--- |
| `DOTFILES_BRANCH` | Checkout a specific branch before applying (triggers re-exec of `install.sh`) |
| `DEVCONTAINER` | When set, generates chezmoi config with devcontainer-specific mise tool overrides |
| `XDG_DATA_HOME` | Overrides the default data directory (`~/.local/share`). Respected by `install.sh`, chezmoi, mise, and neovim |
| `XDG_CACHE_HOME` | Overrides the default cache directory (`~/.cache`) |
| `HISTFILE` | Overrides where zsh writes shell history (`~/.zsh_history`) |

---

## 📂 What is Chezmoi?

[Chezmoi](https://www.chezmoi.io/) is a dotfiles manager that creates a clear distinction between your **Source State** (the Git repo) and your **Target State** (your Home directory).

Instead of editing files directly in your Home directory or creating manual symlinks, Chezmoi manages the "Source of Truth" in ```${XDG_DATA_HOME:-~/.local/share}/chezmoi```.

**The Advantage:** Chezmoi allows for templates (e.g., handling different paths for Mac vs. Linux) and ensures your configuration remains identical across all machines without manual path fixing.

---

## 🔄 Workflow: Saving Changes

When you want to adjust your configuration, do **not** modify the files directly in your Home directory (e.g., ```~/.zshrc```), as they might be overwritten during an ```apply```. Use this workflow instead:

If you have to adjust thing directly use `chezmoi re-add` this will add the changes again so you won't loose it.

### 1. Edit a File
Open the file through Chezmoi (this opens the version in the source folder):
```bash
chezmoi edit ~/.zshrc
```

### 2. Apply Changes
Push the changes from the source folder to your actual Home directory:
```bash
chezmoi apply -v
```
*Tip: The ```-v``` (verbose) flag shows exactly which lines changed compared to the current state.*

### 3. Sync to Git
To save your changes permanently to GitHub:
```bash
chezmoi cd
git add .
git commit -m "Update zsh aliases"
git push
```

---

## 🤫 Work-Specific Configs (Private)

Since this repository is public, work-specific aliases, internal IPs, or private keys are **not** stored here. 

This setup is configured to automatically source a file named ```~/.zshrc_work``` if it exists:
1. Create the file locally: ```touch ~/.zshrc_work```
2. Add your private aliases there.
3. The file is ignored by Chezmoi (via ```.chezmoiignore```), so it will **never** be pushed to your public GitHub repo.

---

## 📦 Included Tools & Paths

| Tool | Installation | Info |
| :--- | :--- | :--- |
| **Neovim** | Mise | `neovim "stable"` |
| **Rust** | Mise | `rust "latest"` |
| **ripgrep** | Mise | Prebuilt binary via GitHub releases |
| **fd** | Mise | Prebuilt binary via GitHub releases |
| **delta** | Mise | Prebuilt binary via GitHub releases |
| **tree-sitter** | Mise | Prebuilt binary via GitHub releases |
| **tmux** | Mise | `tmux "latest"` |
| **lazygit** | Mise | `lazygit "latest"` |
| **Fonts** | Chezmoi Externals | Hack Nerd Font in ```~/.local/share/fonts``` |

---

### Helpful Commands
* ```chezmoi managed```: Lists all files managed by Chezmoi.
* ```chezmoi diff```: Shows the difference between the repo and your home directory.
* ```mise ls```: Lists all installed tools and their versions.
