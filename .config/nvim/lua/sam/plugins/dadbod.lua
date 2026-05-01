return {
	{ "tpope/vim-dadbod", lazy = true },
	{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = { "tpope/vim-dadbod" },
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		keys = { { "<leader>db", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" } },
	},
}
