return {
	"stevearc/oil.nvim",
	---@module 'oil'
	opts = {
		view_options = {
			show_hidden = true,
		},
		delete_to_trash = true,
		skip_confirm_for_simple_edits = true,
		float = {
			padding = 4,
			max_width = 80,
			max_height = 30,
			border = "rounded",
		},
		preview_win = {
			update_on_cursor_moved = true,
		},
		keymaps = {
			["<C-p>"] = "actions.preview",
			["q"] = "actions.close",
		},
	},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function(_, opts)
		require("oil").setup(opts)
		vim.keymap.set("n", "<leader>eo", "<CMD>Oil<CR>", { desc = "Open Oil file explorer" })
		vim.keymap.set("n", "<leader>ef", "<CMD>Oil --float<CR>", { desc = "Open Oil float" })
		vim.keymap.set("n", "<leader>er", "<CMD>Oil " .. vim.fn.getcwd() .. "<CR>", { desc = "Open Oil at project root" })
	end,
}
