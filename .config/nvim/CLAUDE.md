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
- **C/C++**: LSP (clangd), static analysis (clang-tidy), formatting (clang-format), debugging (lldb) - requires `brew install llvm`
- **Web Technologies**: TypeScript, JavaScript, HTML, CSS, Tailwind

### Enhanced Testing Commands (neotest)
- `<leader>tt` - Run nearest test
- `<leader>tf` - Run all tests in current file
- `<leader>ta` - Run entire test suite
- `<leader>ts` - Toggle test summary panel
- `<leader>to` - Show test output
- `<leader>tO` - Toggle output panel
- `<leader>tw` - Toggle watch mode
- `<leader>tS` - Stop running tests
- `<leader>td` - Debug nearest test

**Language Support:**
- ✅ **Go**: Full neotest support (test discovery, debugging)
- ✅ **Java**: JUnit tests with neotest-java
- ✅ **Elixir**: ExUnit tests with neotest-elixir
- ✅ **Python**: pytest/unittest with neotest-python
- ✅ **C++**: Google Test framework with neotest-gtest

### Enhanced Debugging (DAP)
- **Go**: Debugging with delve adapter + test debugging
- **Java**: Debugging with JDTLS integration + test debugging
- **Elixir**: Debugging with mix tasks + test debugging
- **C/C++**: Debugging with lldb adapter (lldb-dap)
- **Python**: Debugging with debugpy adapter + test debugging
- Enhanced DAP-UI with improved layout
- Virtual text for inline variable display
- Breakpoint management with conditions

#### Debug Commands
- `<leader>dt` - Toggle breakpoint
- `<leader>dT` - Conditional breakpoint (prompts for condition)
- `<leader>dc` - Start/Continue debugging
- `<leader>dx` - Stop debugging
- `<leader>dr` - Restart debugging
- `<leader>dp` - Pause debugging
- `<leader>du` - Toggle debug UI
- `<leader>de` - Evaluate expression (prompts for expression)
- `<leader>ds` - Show scopes
- `<leader>dw` - Show watches
- `<leader>dk` - Show call stack
- `<leader>db` - Show breakpoints

**Language-specific Debug Commands:**
- `<leader>dgt` - Debug Go test
- `<leader>djc` - Debug Java test class
- `<leader>djm` - Debug Java test method
- `<leader>det` - Debug Elixir test
- `<leader>dpt` - Debug Python test method
- `<leader>dpc` - Debug Python test class
- `<leader>dct` - Start C++ Debugging

### Coverage Visualization
- `<leader>cc` - Load coverage
- `<leader>cs` - Coverage summary
- `<leader>ct` - Toggle coverage
- `<leader>cg` - Generate Go coverage
- `<leader>cj` - Generate Java coverage
- `<leader>ce` - Generate Elixir coverage

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
- Enhanced buffer line with diagnostics and better styling

#### Buffer Management
- `<leader>bp` - Buffer pick
- `<leader>bd` - Buffer pick close
- `<leader>bc` - Close other buffers
- `<leader>bh` - Close left buffers
- `<leader>bl` - Close right buffers
- `<leader>bs` - Sort by directory
- `<leader>bm` - Toggle pin
- `<leader>b1-9` - Go to buffer 1-9

### Code Navigation
- LSP-based navigation (gd, gR, gi, gt)
- Treesitter for syntax highlighting and incremental selection
- Telescope integration for LSP references and definitions

### Git Integration
- Gitsigns for git status in files
- Lazygit integration for git operations

### Terminal Integration (toggleterm + custom-terminal)
- **toggleterm**: `<Ctrl-\>` to toggle terminal, `<leader>tt` (horizontal), `<leader>tf` (floating), `<leader>tv` (vertical)
- **custom-terminal** (legacy): `<leader>st` (split), `<leader>sf` (floating), `<leader>sr` (run command), `<leader>ss` (send selection)
- tmux-navigator for seamless tmux/nvim navigation

### Code Execution (code-runner + toggleterm)
- `<leader>rc` - Run current file (opens toggleterm at bottom)
- `<leader>rcc` - Run C++ file (single file only, ignores other files)
- `<leader>rp` - Run entire project (smart build detection)
- `<leader>rs` - Toggle terminal on/off

**Supported Languages with Smart Detection:**
- **Java**: Detects Maven (mvn clean compile exec:java) or Gradle (gradle run), falls back to javac/java for standalone files
- **Go**: Uses `go run` command for files, `go build && ./bin/app` for projects with go.mod
- **Elixir**: Detects Mix projects (mix run) or runs standalone .exs scripts, detects Phoenix apps and runs with iex
- **C/C++**:
  - `<leader>rc` (smart): Detects CMake, Makefile, multi-file projects, or standalone
  - `<leader>rcc` (direct): Always compiles ONLY current file with clang++
  - CMakeLists.txt: Uses cmake build system
  - Makefile: Uses make build system
  - Multiple .cpp files: Auto-compiles all .cpp files together
  - Single .cpp file: Compiles with clang++ to ./build/
- **Python**: Runs with python3
- **Rust**: Compiles and runs with rustc

**Terminal Features:**
- All output appears in **toggleterm** (horizontal split at bottom, 20 lines)
- Exit terminal: `<Esc>` or `jk` (in terminal mode)
- Navigate from terminal: `<Ctrl-h/j/k/l>` to switch windows
- Full shell history available (use `↑` and `↓` to browse previous commands, `Ctrl-R` to search)
- Persistent history between sessions
- Multi-terminal support (run `:1ToggleTerm`, `:2ToggleTerm` for separate terminals)