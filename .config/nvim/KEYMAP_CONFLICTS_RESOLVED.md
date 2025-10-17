# Keymap Conflicts Resolution

## ✅ **Resolved Conflicts**

### 1. **Java JDTLS Conflicts**
**Problem**: ftplugin/java.lua and nvim-jdtls.lua had conflicting keymaps and DAP setup

**Resolution**:
- **ftplugin/java.lua** keeps the main JDTLS setup and existing keymaps:
  - `<leader>co` - Organize imports
  - `<leader>crv` - Extract variable
  - `<leader>crc` - Extract constant
  - `<leader>crm` - Extract method
- **nvim-jdtls.lua** now only adds debug-specific keymaps:
  - `<leader>djc` - Debug Java test class
  - `<leader>djm` - Debug Java test method
- **debugging.lua** removed conflicting Java keymaps

### 2. **Test Keymap Conflicts**
**Problem**: `<leader>tf` was used for both "Run file tests" and "Open current buffer in new tab"

**Resolution**:
- **core/keymaps.lua**: Changed `<leader>tf` → `<leader>tb` for "Open current buffer in new tab"
- **neotest.lua**: Keeps `<leader>tf` for "Run current file tests"
- **core/keymaps.lua**: Removed duplicate test keymaps (now handled in neotest.lua)

### 3. **Debug Keymap Organization**
**Problem**: Multiple debug keymaps scattered across files

**Resolution**:
- **debugging.lua**: Main debug keymaps for Go and Elixir
- **nvim-jdtls.lua**: Java-specific debug keymaps
- **ftplugin/java.lua**: Java LSP refactoring keymaps

## 📋 **Current Keymap Organization**

### **Core Keymaps** (lua/sam/core/keymaps.lua)
- General editor keymaps
- Window management
- Tab management: `<leader>to`, `<leader>tx`, `<leader>tn`, `<leader>tp`, `<leader>tb`
- Movement enhancements (zz centering)
- Inlay hints toggle: `<leader>ih`

### **Test Keymaps** (lua/sam/plugins/neotest.lua)
- `<leader>tt` - Run nearest test
- `<leader>tf` - Run current file tests
- `<leader>ta` - Run all tests
- `<leader>ts` - Toggle test summary
- `<leader>to` - Show test output
- `<leader>tO` - Toggle output panel
- `<leader>tw` - Toggle watch mode
- `<leader>tS` - Stop running tests
- `<leader>td` - Debug nearest test
- `<leader>tg` - Run Go test (verbose)
- `<leader>tj` - Run Java test (info)
- `<leader>te` - Run Elixir test (trace)

### **Debug Keymaps** (lua/sam/plugins/debugging.lua)
- `<leader>dt` - Toggle breakpoint
- `<leader>dT` - Conditional breakpoint
- `<leader>dc` - Start/Continue debugging
- `<leader>dx` - Stop debugging
- `<leader>dr` - Restart debugging
- `<leader>dp` - Pause debugging
- `<leader>du` - Toggle debug UI
- `<leader>de` - Evaluate expression
- `<leader>ds` - Show scopes
- `<leader>dw` - Show watches
- `<leader>dk` - Show call stack
- `<leader>db` - Show breakpoints
- `<leader>dR` - Open REPL
- `<leader>dl` - Run last
- `<leader>dgt` - Debug Go test
- `<leader>dgT` - Debug last Go test
- `<leader>det` - Debug Elixir test

### **Java-Specific Keymaps** (ftplugin/java.lua + nvim-jdtls.lua)
**ftplugin/java.lua**:
- `<leader>co` - Organize imports
- `<leader>crv` - Extract variable
- `<leader>crc` - Extract constant
- `<leader>crm` - Extract method

**nvim-jdtls.lua**:
- `<leader>djc` - Debug Java test class
- `<leader>djm` - Debug Java test method

### **Coverage Keymaps** (lua/sam/plugins/nvim-coverage.lua)
- `<leader>cc` - Load coverage
- `<leader>cs` - Coverage summary
- `<leader>ct` - Toggle coverage
- `<leader>ch` - Hide coverage
- `<leader>cS` - Show coverage
- `<leader>cg` - Generate Go coverage
- `<leader>cj` - Generate Java coverage
- `<leader>ce` - Generate Elixir coverage

### **Buffer Management** (lua/sam/plugins/bufferline.lua)
- `<leader>bp` - Buffer pick
- `<leader>bd` - Buffer pick close
- `<leader>bc` - Close other buffers
- `<leader>bh` - Close left buffers
- `<leader>bl` - Close right buffers
- `<leader>bs` - Sort by directory
- `<leader>bS` - Sort by extension
- `<leader>bt` - Sort by tabs
- `<leader>bm` - Toggle pin
- `<leader>bP` - Close unpinned
- `<leader>bo` - Close others
- `<leader>br` - Close right
- `<leader>b1-9` - Go to buffer 1-9
- `<leader>b$` - Go to last buffer

## ✅ **No Conflicts Remaining**

All keymaps are now properly organized and conflict-free. The configuration maintains backward compatibility while providing enhanced functionality for testing, debugging, and UI management.