# 🚀 Dotfiles

My personal setup for **WSL (Ubuntu)**, **Devcontainers (Debian)**, and **macOS (not supported yet)**. 
Managed with [Chezmoi](https://www.chezmoi.io/).

## ✨ Highlights

* **Shell:** Zsh with Oh My Zsh & Powerlevel10k.
* **Editor:** Neovim (installed via **Bob** for easy version management).
* **Search:** ```fzf``` (v0.25.1+), ```ripgrep``` (live grep), and ```fd``` (find).
* **Languages:** Full Rust toolchain (via ```rustup```).
* **Fonts:** Hack Nerd Font (automatically handled via Chezmoi Externals).

---

## 🛠️ Installation / Bootstrap

To install this setup on a new machine or a fresh container, run:

```bash
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply <your-github-username>
```

*In a Devcontainer:* The repository is cloned, and ```install.sh``` automatically triggers the Chezmoi process.
*Note*: Use the `--dotfiles-repository` flag with the Devcontainer CLI.

---

## 📂 What is Chezmoi?

[Chezmoi](https://www.chezmoi.io/) is a dotfiles manager that creates a clear distinction between your **Source State** (the Git repo) and your **Target State** (your Home directory).

Instead of editing files directly in your Home directory or creating manual symlinks, Chezmoi manages the "Source of Truth" in ```~/.local/share/chezmoi```.

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

| Tool | Installation | Path / Info |
| :--- | :--- | :--- |
| **Rust/Cargo** | Rustup | ```~/.cargo/bin``` |
| **Neovim** | Bob-Nvim | ```~/.local/share/bob/nvim-bin``` |
| **FZF** | Git | Installed v0.25.1+ for full plugin compatibility |
| **fd** | Apt/Cargo | Alias ```fd='fdfind```' is set automatically |
| **Fonts** | Externals | Hack Nerd Font in ```~/.local/share/fonts``` |

---

### Helpful Commands
* ```chezmoi managed```: Lists all files managed by Chezmoi.
* ```chezmoi diff```: Shows the difference between the repo and your home directory.
* ```bob use stable```: Switches to the latest stable Neovim version.
