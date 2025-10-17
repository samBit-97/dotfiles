return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "nord",
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
					{
						function()
							-- Get file name
							local filename = vim.fn.expand("%:t")
							local display = " " .. filename

							-- Add [+] if file is modified
							if vim.bo.modified then
								display = display .. " [+]"
							end

							return display
						end,
						color = { fg = "#ffffff", gui = "bold" },
					},
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
