return {
	-- catppuccin theme setup
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				transparent_background = true,
				term_colors = true, -- Set terminal colors
				styles = {
					comments = { "italic" }, -- Style for comments
					conditionals = { "italic" },
					loops = {},
					functions = { "bold" },
					keywords = { "italic" },
					strings = {},
					variables = {},
				},
				integrations = {
					cmp = true, -- nvim-cmp integration
					gitsigns = true, -- GitSigns integration
					lsp_trouble = true, -- LSP Trouble integration
					lsp_saga = false, -- LSP Saga integration
					nvimtree = true, -- NvimTree integration
					neotree = true, -- NeoTree integration
					telescope = true, -- Telescope integration
					treesitter = true, -- Treesitter integration
					which_key = true, -- WhichKey integration
				},
				highlight_overrides = {
					mocha = function(colors)
						return {
							Comment = { fg = colors.overlay2, style = { "italic" } },
							Function = { fg = colors.blue, style = { "bold" } },
							Keyword = { fg = colors.mauve, style = { "italic" } },
							String = { fg = colors.green },
							Variable = { fg = colors.text },
						}
					end,
				},
			})
			-- setup must be called before loading
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
