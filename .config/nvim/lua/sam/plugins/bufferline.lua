return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			mode = "tabs",
			-- separator_style = "slope",
		},
		highlights = {
			-- background = {
			-- 	fg = "#1e1e2e", -- text
			-- 	bg = "#a6e3a1", -- base
			-- },
			tab_selected = {
				bold = true,
				italic = true,
			},
			buffer_selected = {
				fg = "#fde2e4", -- base (text)
				bg = "#1e1e2e",
			},
		},
	},
	config = function(_, opts)
		require("bufferline").setup(opts)

		vim.keymap.set("n", "<leader>bp", "<cmd>BufferLinePick<CR>", { desc = "Buffer Pick" })
		vim.keymap.set("n", "<leader>bd", "<cmd>BufferLinePickClose<CR>", { desc = "Buffer Pick Close" })
	end,
}
