return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "dracula",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
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
					{ "branch", icon = "" },
				},
				lualine_c = {
					{
						function()
							-- Get full file path
							local filepath = vim.fn.expand("%:p")
							-- Replace home directory with ~
							local home = vim.fn.expand("~")
							filepath = filepath:gsub("^" .. home, "~")
							local display = " " .. filepath

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
					"filetype",
				},
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
