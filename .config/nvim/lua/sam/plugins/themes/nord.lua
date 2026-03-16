return {
	"shaunsingh/nord.nvim",
	priority = 999,
	config = function()
		vim.g.nord_contrast = true
		vim.g.nord_borders = false
		vim.g.nord_disable_background = true
		vim.g.nord_italic = true
		vim.g.nord_bold = true
		require("nord").set()

		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "nord",
			callback = function()
				vim.api.nvim_set_hl(0, "CursorLine", { bg = "#3b4252" })   -- nord1
				vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#88c0d0", bold = true }) -- nord8
			end,
		})
		vim.cmd("doautocmd ColorScheme nord")
	end,
}
