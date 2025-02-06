return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true, -- Enable icons
				theme = "onedark", -- Use your colorscheme's auto colors
				component_separators = { left = "", right = "" }, -- Separators between components
				section_separators = { left = "", right = "" }, -- Separators between sections
				globalstatus = false, -- Global status line across all splits
			},
			sections = {
				-- Left section: Mode and Git branch
				lualine_a = {
					{
						"mode",
						fmt = function(mode)
							return string.upper(mode)
						end,
					}, -- Mode in uppercase
				},
				-- Center section: File name
				lualine_b = {
					{ "branch", icon = "" }, -- Git branch
				}, -- Empty for centering
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
						color_error = { fg = "#ff6c6b" }, -- Red for errors
						color_warn = { fg = "#ECBE7B" }, -- Yellow for warnings
						color_info = { fg = "#98be65" }, -- Green for info
						color_hint = { fg = "#4FC1FF" }, -- Blue for hints
					},
					{ "filename", path = 0 }, -- File name only (no path)
				},
				-- Right section: Encoding, file format, and location
				lualine_x = {
					"encoding", -- File encoding (e.g., utf-8)
					"fileformat", -- File format (e.g., unix)
					"filetype", -- File type (e.g., lua)
					"location", -- Cursor position (line:column)
				},
				lualine_y = {}, -- Empty
				lualine_z = {}, -- Empty
			},
		})
		vim.o.laststatus = 3
		vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE" })
		vim.o.winbar = "%=%{%v:lua.require('custom-winbar').get_winbar()%}%="
		vim.o.tabline = "%!v:lua.require('custom-tabline').generateTabline()"
	end,
}
