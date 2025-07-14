return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "onedark",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				globalstatus = false,
			},
			sections = {
				lualine_a = {
					{
						"mode",
						fmt = function(mode)
							return string.upper(mode)
						end,
					},
				},
				lualine_b = {
					{ "branch", icon = "" },
				},
				lualine_c = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						sections = { "error", "warn", "info", "hint" },
						symbols = {
							error = " ",
							warn = " ",
							info = " ",
							hint = "󰠠 ",
						},
						color_error = { fg = "#ff6c6b" },
						color_warn = { fg = "#ECBE7B" },
						color_info = { fg = "#98be65" },
						color_hint = { fg = "#4FC1FF" },
					},
					{ "filename", path = 0 },
				},
				lualine_x = {
					"encoding",
					"fileformat",
					"filetype",
					"location",
				},
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
