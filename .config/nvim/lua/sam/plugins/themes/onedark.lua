return {
	"navarasu/onedark.nvim",
	commit = "dd640f6",
	priority = 999,
	config = function()
		require("onedark").setup({
			style = "dark",
			transparent = true,
			term_colors = true,
			code_style = {
				comments = "italic",
				keywords = "none",
				functions = "none",
				strings = "none",
				variables = "none",
			},
		})
		require("onedark").load()

		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "onedark",
			callback = function()
				vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2c313a" })   -- onedark darker bg
				vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e5c07b", bold = true }) -- yellow
			end,
		})
		vim.cmd("doautocmd ColorScheme onedark")
	end,
}
