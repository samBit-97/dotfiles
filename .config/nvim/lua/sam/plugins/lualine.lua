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
					{
						"diff",
						symbols = {
							added = " ", -- Green plus
							modified = " ", -- Yellow tilde
							removed = " ", -- Red minus
						},
						source = function()
							local gitsigns = vim.b.gitsigns_status_dict
							if gitsigns then
								return {
									added = gitsigns.added,
									modified = gitsigns.changed,
									removed = gitsigns.removed,
								}
							end
						end,
					},
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
		vim.o.laststatus = 3
		vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE" })
		vim.o.winbar = "%=%{%v:lua.require('custom-winbar').get_winbar()%}%="
		vim.o.tabline = "%!v:lua.require('custom-tabline').generateTabline()"
	end,
}
