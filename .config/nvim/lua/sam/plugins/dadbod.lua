return {
	{ "tpope/vim-dadbod", cmd = "DB", lazy = true },
	{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
	{
		"kristijanhusak/vim-dadbod-ui",
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		keys = { { "<leader>db", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" } },
	},
}
