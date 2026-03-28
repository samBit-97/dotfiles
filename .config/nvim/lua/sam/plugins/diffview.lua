return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff view (working tree)" },
		{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current file)" },
		{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "File history (repo)" },
		{ "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
	},
	opts = {
		enhanced_diff_hl = true,
		file_panel = {
			listing_style = "tree",
			tree_options = {
				flatten_dirs = true,
				folder_statuses = "only_folded",
			},
			win_config = {
				position = "left",
				width = 35,
			},
		},
	},
}
