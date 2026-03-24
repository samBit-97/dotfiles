# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

macOS dotfiles repository using GNU Stow for symlink management. All tools use **Gruvbox Material Dark** as the default theme (Catppuccin Mocha available as commented blocks).

## Installation

```bash
# macOS
brew install stow && cd ~/dotfiles && stow -t ~ .
brew bundle install --file=Brewfile

# Fedora
chmod +x packages-fedora.sh && ./packages-fedora.sh
cd ~/dotfiles && stow -t ~ .
```

Stow commands: `stow -t ~ .` (apply), `stow -D -t ~ .` (remove), `stow -R -t ~ .` (restow after changes).

## Theme System

Theme consistency is critical — all tools must use the same palette.

- **Neovim**: `NVIM_THEME` env var in `.zshrc` selects theme; modules in `lua/sam/plugins/themes/`
- **Tmux**: Bash color variables at top of `.tmux.conf` (lines 10-37); gruvbox active, nord + catppuccin commented
- **Sketchybar**: `colors.sh` defines `$WHITE`, `$RED`, `$GREEN`, `$BG0`, etc. with opacity variants (`BG0O50`-`BG0O85`); gruvbox active, catppuccin commented
- **Starship**: `palette = 'gruvbox'` in `.config/starship/starship.toml`; palettes for nord, onedark, gruvbox, catppuccin all defined
- **Television**: `theme = "gruvbox-dark"` in `config.toml`

When changing themes, update **all** of the above together.

## Sketchybar Architecture

Modular bash scripts — `sketchybarrc` sources everything:

- `colors.sh` / `icons.sh` — global variables sourced first
- `items/*.sh` — define static item config (icon, font, position, update frequency)
- `plugins/*.sh` — scripts that run on schedule or event to update item state
- Pattern: items call `script="$PLUGIN_DIR/foo.sh"` and `--subscribe item event_name`
- Icons: SF Symbols for system, Nerd Font for custom, sketchybar-app-font for app logos
- All color references use bash variables from `colors.sh` (e.g., `icon.color=$GREEN`)

## Neovim Plugin Architecture

Lazy.nvim with each plugin as a separate `.lua` file in `lua/sam/plugins/`:

- `init.lua` → requires `sam.core` (options + keymaps) then `sam.lazy`
- `lazy.lua` imports from `sam.plugins` and `sam.plugins.lsp`
- Theme loader (`themes/init.lua`) reads `NVIM_THEME` env var, falls back to catppuccin
- LSP keymaps bound on `LspAttach` autocmd in `lsp/lspconfig.lua`
- `transparent_background = 1` on gruvbox-material for Ghostty blur compatibility
- Java LSP uses separate `ftplugin/java.lua` for JDTLS

## Zsh Startup Optimizations

The `.zshrc` has specific performance patterns — preserve them:

- **compinit caching** (lines 1-10): skip recompile if `.zcompdump` < 24h old
- **kubectl lazy-load** (lines 132-138): wrapper function defers completion sourcing until first use
- **GOPATH cached**: hardcoded `~/go` instead of calling `go env GOPATH`
- **Secrets**: sourced from `~/.secrets` (never committed)

Zsh plugins are sourced from Homebrew paths (`/opt/homebrew/share/`). On Linux these would come from `~/.local/share/zsh/plugins/` — OS detection needed for cross-platform.

## Tmux

- Prefix: `Ctrl-A`. Base index: 1. Renumber windows on.
- Sesh session picker bound to `Prefix + T` (fzf-tmux popup)
- `vim-tmux-navigator` enables `Ctrl+h/j/k/l` across tmux panes and nvim splits
- TPM manages plugins — `run '~/.tmux/plugins/tpm/tpm'` must stay at bottom

## Television Cable Channels

Each `.toml` file in `.config/television/cable/` defines a channel with `[metadata]`, `[source]`, `[preview]`, `[keybindings]`, and `[actions.*]` sections. Shell integration in `config.toml` maps command prefixes to channels (e.g., `git checkout` → `git-branch` channel).

## Key Conventions

- Ghostty transparency (`background-opacity = 0.8`) means configs needing visible backgrounds must account for blur
- Sketchybar height is 28, yabai `external_bar all:24:0` — change together
- `v()` function in `.zshrc` wraps nvim with an instance count guard (warns at 5+)
- `.gitignore` excludes `.zshrc` from tracking but it IS tracked (gitignore entry is stale)
