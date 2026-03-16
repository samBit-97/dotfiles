return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			transparent_background = true,
			term_colors = true,
			styles = {
				comments = { "italic" },
				conditionals = { "italic" },
				functions = { "bold" },
				keywords = { "italic" },
			},
			integrations = {
				cmp = true,
				gitsigns = true,
				neotree = true,
				telescope = true,
				treesitter = true,
				bufferline = true,
			},
		})
		vim.cmd.colorscheme("catppuccin")

		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "catppuccin",
			callback = function()
				vim.api.nvim_set_hl(0, "CursorLine", { bg = "#313244" })   -- catppuccin surface0
				vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#b4befe", bold = true }) -- lavender
			end,
		})
		vim.cmd("doautocmd ColorScheme catppuccin")
	end,
}
