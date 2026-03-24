# Dotfiles

macOS terminal setup — Gruvbox Material Dark everywhere.

## Stack

| Tool | Purpose | Config |
|------|---------|--------|
| [Ghostty](https://ghostty.org) | Terminal emulator | `.config/ghostty/` |
| Zsh | Shell (no framework) | `.zshrc` |
| [Starship](https://starship.rs) | Prompt | `.config/starship/` |
| [Tmux](https://github.com/tmux/tmux) | Multiplexer | `.tmux.conf` |
| [Neovim](https://neovim.io) | Editor (Lazy.nvim) | `.config/nvim/` |
| [Sketchybar](https://github.com/FelixKratz/SketchyBar) | Menu bar | `.config/sketchybar/` |
| [yabai](https://github.com/koekeishiya/yabai) + [skhd](https://github.com/koekeishiya/skhd) | Tiling WM | `.config/yabai/`, `.config/skhd/` |
| [Television](https://github.com/alexpasmantier/television) | Fuzzy finder TUI | `.config/television/` |
| [gh-dash](https://github.com/dlvhdr/gh-dash) | GitHub PR/issue TUI | `.config/gh-dash/` |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder | via `.zshrc` |
| [diffnav](https://github.com/dlvhdr/diffnav) + [delta](https://github.com/dandavison/delta) | Git pager | via `.gitconfig` |

## Structure

```
~/dotfiles/
├── .zshrc
├── .tmux.conf
├── Brewfile                     # macOS packages (brew bundle)
├── packages-fedora.sh           # Fedora equivalent
├── .config/
│   ├── ghostty/                 # terminal emulator
│   ├── nvim/                    # neovim (Lazy.nvim)
│   ├── starship/                # prompt
│   ├── sketchybar/              # menu bar (macOS)
│   ├── yabai/                   # tiling WM (macOS)
│   ├── skhd/                    # hotkeys (macOS)
│   ├── television/              # tv channels + config
│   └── gh-dash/                 # GitHub dashboard
```

## Install

### macOS

```bash
# Install Homebrew + stow
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install stow

# Clone and symlink
git clone https://github.com/samBit-97/dotfiles.git ~/dotfiles
cd ~/dotfiles
mkdir -p ~/.config
stow -t ~ .

# Install all packages
brew bundle install --file=Brewfile

# Post-setup
nvim --headless "+Lazy! sync" +qa
touch ~/.secrets && chmod 600 ~/.secrets
```

### Fedora (Linux)

```bash
sudo dnf install -y git stow
git clone https://github.com/samBit-97/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x packages-fedora.sh && ./packages-fedora.sh
mkdir -p ~/.config
stow -t ~ .
```

## Key Features

- **Theme**: Gruvbox Material Dark across all tools (Catppuccin Mocha available as commented blocks)
- **Zsh**: ~110ms startup, compinit cached, kubectl lazy-loaded, nvim instance guard
- **Tmux**: Ctrl-A prefix, base-index 1, sesh session picker, vim-tmux-navigator
- **Sketchybar**: Spotify controls, memory/CPU/battery/wifi indicators, modular architecture
- **Neovim**: 30+ plugins via Lazy.nvim, transparent background, LSP + DAP + Treesitter
- **Television**: Custom cable channels for tmux session management via sesh/zoxide

## Stow Commands

| Command | What it does |
|---------|-------------|
| `stow -t ~ .` | Create all symlinks |
| `stow -D -t ~ .` | Remove all symlinks |
| `stow -R -t ~ .` | Restow (after adding files) |
| `stow -n -t ~ .` | Dry run |
