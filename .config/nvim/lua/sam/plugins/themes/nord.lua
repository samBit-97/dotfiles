return {
	"shaunsingh/nord.nvim",
	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	priority = 999, -- make sure to load this before all the other start plugins
	config = function()
		-- Example config in lua
		vim.g.nord_contrast = true -- Make sidebars and popup menus like nvim-tree and telescope have a different background
		vim.g.nord_borders = false -- Enable the border between verticaly split windows visable
		vim.g.nord_disable_background = true -- Disable the setting of background color so that NeoVim can use your terminal background
		vim.g.set_cursorline_transparent = false -- Set the cursorline transparent/visible
		vim.g.nord_italic = true -- enables/disables italics
		vim.g.nord_enable_sidebar_background = false -- Re-enables the background of the sidebar if you disabled the background of everything
		vim.g.nord_uniform_diff_background = true -- enables/disables colorful backgrounds when used in diff mode
		vim.g.nord_bold = true -- enables/disables bold

		-- Load the colorscheme
		require("nord").set()

		-- Custom highlight overrides matching Catppuccin style
		vim.api.nvim_set_hl(0, "Comment", { fg = "#616E88", italic = true }) -- Muted gray - comments (italic like Catppuccin)
		vim.api.nvim_set_hl(0, "Conditional", { fg = "#81A1C1", italic = true }) -- Blue - conditionals (italic)
		vim.api.nvim_set_hl(0, "Keyword", { fg = "#B48EAD", italic = true }) -- Purple - keywords (italic, matches Catppuccin mauve)
		vim.api.nvim_set_hl(0, "Function", { fg = "#88C0D0", bold = true }) -- Light cyan - function names (bold like Catppuccin)
		vim.api.nvim_set_hl(0, "Type", { fg = "#8FBCBB", bold = true }) -- Cyan - class names, types (bold)
		vim.api.nvim_set_hl(0, "String", { fg = "#A3BE8C" }) -- Green - strings
		vim.api.nvim_set_hl(0, "Identifier", { fg = "#D8DEE9" }) -- Light gray - variables
		vim.api.nvim_set_hl(0, "Constant", { fg = "#EBCB8B" }) -- Yellow - constants
		vim.api.nvim_set_hl(0, "Operator", { fg = "#81A1C1" }) -- Blue - operators
		vim.api.nvim_set_hl(0, "Special", { fg = "#B48EAD" }) -- Purple - special characters

		-- UI elements matching Catppuccin style
		vim.api.nvim_set_hl(0, "CursorLine", { bg = "#3B4252" }) -- Slightly lighter background for cursor line
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#88C0D0", bold = true }) -- Cyan cursor line number (bold)
		vim.api.nvim_set_hl(0, "Visual", { bg = "#434C5E" }) -- Visual selection
		vim.api.nvim_set_hl(0, "LineNr", { fg = "#4C566A" }) -- Line numbers

		local bg_transparent = true

		-- Toggle background transparency
		local toggle_transparency = function()
			bg_transparent = not bg_transparent
			vim.g.nord_disable_background = bg_transparent
			vim.cmd([[colorscheme nord]])
		end

		vim.keymap.set(
			"n",
			"<leader>bg",
			toggle_transparency,
			{ noremap = true, silent = true, desc = "Toggle background transparency" }
		)
	end,
}
