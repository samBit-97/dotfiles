return {
	"sainnhe/gruvbox-material",
	priority = 1000,
	config = function()
		vim.g.gruvbox_material_background = "hard"
		vim.g.gruvbox_material_foreground = "material"
		vim.g.gruvbox_material_enable_italic = 1
		vim.g.gruvbox_material_transparent_background = 1
		vim.g.gruvbox_material_better_performance = 1
		vim.cmd.colorscheme("gruvbox-material")

		-- With transparent background + blurred wallpaper the cursorline
		-- disappears. Use a solid gruvbox surface color so it stays visible.
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "gruvbox-material",
			callback = function()
				vim.api.nvim_set_hl(0, "CursorLine", { bg = "#3c3836" })
				vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#d4be98", bold = true })
			end,
		})
		vim.cmd("doautocmd ColorScheme gruvbox-material")
	end,
}
