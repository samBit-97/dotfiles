return {
	-- catppuccin theme setup
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
				bufferline = true, -- bufferline integration
			},
			highlight_overrides = {
				mocha = function(colors)
					return {
						CursorLine = { bg = colors.surface1 }, -- soft, slightly lighter than default bg
						CursorLineNr = { fg = colors.lavender, bold = true },
						Visual = { bg = colors.surface2, blend = 10 }, -- slightly stronger than CursorLine
						LineNr = { fg = colors.overlay0 },
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

		-- Toggle background transparency
		vim.keymap.set("n", "<leader>bg", function()
			local current = require("catppuccin").options.transparent_background
			require("catppuccin").setup({ transparent_background = not current })
			vim.cmd.colorscheme("catppuccin")
		end, { noremap = true, silent = true, desc = "Toggle background transparency" })
	end,
}
