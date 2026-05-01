return {
	{
		"tpope/vim-dadbod",
		lazy = false,
	},
	{
		"kristijanhusak/vim-dadbod-completion",
		ft = { "sql", "mysql", "plsql" },
		dependencies = { "tpope/vim-dadbod" },
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = { "tpope/vim-dadbod" },
		lazy = false,
		keys = { { "<leader>db", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" } },
	},
}
