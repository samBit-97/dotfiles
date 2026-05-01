return {
	{
		"Xemptuous/sqlua.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"MunifTanjim/nui.nvim",
		},
		lazy = false,
		keys = {
			{ "<leader>db", "<cmd>SQLua<CR>", desc = "Open SQL IDE" },
		},
		config = function()
			require("sqlua").setup({
				-- Connection settings
				connections = vim.fn.expand("~/.local/share/db_ui/connections.json"),
				-- UI settings
				window = {
					width = 0.8,
					height = 0.8,
				},
				-- Query settings
				auto_execute_on_save = true,
				result_window_position = "right",
			})
		end,
	},
}
