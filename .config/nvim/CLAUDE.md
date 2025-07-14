# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a personal Neovim configuration using the Lazy.nvim plugin manager. The configuration is organized in a modular structure:

- **Entry Point**: `init.lua` loads core configuration and plugin manager
- **Core Configuration**: `lua/sam/core/` contains fundamental Neovim settings
- **Plugin Management**: `lua/sam/lazy.lua` initializes Lazy.nvim and imports all plugins
- **Plugin Configurations**: `lua/sam/plugins/` contains individual plugin configurations

## Key Configuration Structure

### Core Files
- `init.lua` - Main entry point, requires core and lazy modules
- `lua/sam/core/init.lua` - Loads options and keymaps
- `lua/sam/core/options.lua` - Neovim options (indentation, appearance, etc.)
- `lua/sam/core/keymaps.lua` - Custom keymaps and leader key configuration

### Plugin Architecture
- `lua/sam/lazy.lua` - Lazy.nvim setup and plugin imports
- `lua/sam/plugins/init.lua` - Base utility plugins
- `lua/sam/plugins/` - Individual plugin configurations as separate files
- `lua/sam/plugins/lsp/` - LSP-related configurations

## Development Environment Setup

### Language Support
The configuration supports multiple languages with LSP, debugging, and testing:
- **Go**: LSP (gopls), debugging (delve), testing (neotest-go)
- **Java**: LSP (jdtls), testing (neotest-java)
- **Elixir**: Testing (neotest-elixir)
- **Python**: Debugging support
- **Web Technologies**: TypeScript, JavaScript, HTML, CSS, Tailwind

### Key Testing Commands
- `<leader>tm` - Run nearest test
- `<leader>tf` - Run all tests in current file
- `<leader>ta` - Run entire test suite
- `<leader>tsum` - Toggle test summary panel
- `<leader>tw` - Watch test file for changes

### Debugging (DAP)
- Go debugging configured with delve adapter
- Python debugging support available
- DAP-UI for debugging interface

## Important Configuration Details

### Leader Key
- Leader key is set to `<space>`

### Custom Movement Keymaps
- All vertical movements (j, k, {, }, (, ), C-d, C-u, etc.) are remapped to include `zz` for centered scrolling

### Plugin Management
- Uses Lazy.nvim with automatic plugin checking enabled
- Plugins are organized by functionality in separate files
- LSP configurations are in dedicated `lsp/` subdirectory

### Mason Configuration
- Mason automatically installs LSP servers, formatters, and linters
- Configured LSP servers: html, cssls, tailwindcss, svelte, lua_ls, graphql, emmet_ls, prismals, pyright, gopls, jdtls, elixirls
- Tools: prettier, stylua, isort, black, pylint, eslint_d, gofumpt, goimports, golines, terraform_fmt, xmlformatter

### Notes Integration
- Obsidian plugin configured for coding notes
- Keymaps: `<leader>on` (new note), `<leader>os` (search), `<leader>oq` (quick switch)

## Common Plugin Patterns

### Plugin Structure
Each plugin configuration follows this pattern:
```lua
return {
  "plugin/name",
  dependencies = { ... },
  config = function()
    -- plugin setup
  end,
}
```

### Event-based Loading
Many plugins use lazy loading with events like:
- `"BufReadPre", "BufNewFile"` for file-related plugins
- `"VeryLazy"` for non-essential plugins

## Development Workflow

### File Navigation
- Telescope for fuzzy finding (`<leader>ff`, `<leader>fs`, etc.)
- Oil.nvim for file management
- Neo-tree for file explorer

### Code Navigation
- LSP-based navigation (gd, gR, gi, gt)
- Treesitter for syntax highlighting and incremental selection
- Telescope integration for LSP references and definitions

### Git Integration
- Gitsigns for git status in files
- Lazygit integration for git operations

### Terminal Integration
- Terminal keymaps configured for toggleterm
- tmux-navigator for seamless tmux/nvim navigation