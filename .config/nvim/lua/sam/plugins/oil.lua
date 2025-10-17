return {
	"stevearc/oil.nvim",
	---@module 'oil'
	opts = {
		view_options = {
			show_hidden = true,
		},
		-- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
		delete_to_trash = false,
		-- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
		skip_confirm_for_simple_edits = true,
	},
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	config = function(_, opts)
		require("oil").setup(opts)
		vim.keymap.set("n", "<leader>eo", "<CMD>Oil<CR>", { desc = "Open Oil file explorer" })
	end,
}
