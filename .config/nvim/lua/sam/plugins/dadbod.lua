return {
	{
		"tpope/vim-dadbod",
		lazy = false,
	},
	{
		"kristijanhusak/vim-dadbod-completion",
		lazy = false,
		dependencies = { "tpope/vim-dadbod" },
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = { "tpope/vim-dadbod" },
		lazy = false,
		keys = {
			{ "<leader>db", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
			{ "<leader>df", "<cmd>DBUIFindBuffer<CR>", desc = "DBUI find buffer" },
			{ "<leader>dr", "<cmd>DBUIRenameBuffer<CR>", desc = "DBUI rename buffer" },
			{ "<leader>dq", "<cmd>DBUILastQueryInfo<CR>", desc = "DBUI last query info" },
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_show_database_icon = 1
			vim.g.db_ui_force_echo_notifications = 1
			vim.g.db_ui_win_position = "left"
			vim.g.db_ui_winwidth = 40
			vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
			vim.g.db_ui_use_nvim_notify = 0
			vim.g.db_ui_execute_on_save = 0
			vim.g.db_ui_tmp_query_location = vim.fn.stdpath("data") .. "/db_ui/tmp"
		end,
	},
}
