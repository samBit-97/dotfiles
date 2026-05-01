return {
	{
		"kndndrj/nvim-dbee",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		lazy = false,
		keys = {
			{ "<leader>db", "<cmd>Dbee<CR>", desc = "Toggle Database UI" },
		},
		config = function()
			require("dbee").setup({
				sources = {
					require("dbee.sources").JsonSource:new(
						vim.fn.expand("~/.local/share/db_ui/connections.json")
					),
				},
			})
		end,
	},
}
