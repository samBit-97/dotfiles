return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			size = 20,
			open_mapping = [[<c-\>]],
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = true,
			shading_factor = 1.3,
			start_in_insert = true,
			insert_mappings = true,
			persist_size = true,
			persist_mode = true,
			direction = "horizontal",
			close_on_exit = true,
			shell = vim.o.shell,
			auto_scroll = true,
		})

		-- Optional: Add some keymaps for terminal navigation
		function _G.set_terminal_keymaps()
			local opts = { noremap = true }
			vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
			vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
			vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
			vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
			vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
			vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
		end

		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

		-- Leader Key Mappings for ToggleTerm
		vim.keymap.set("n", "<leader>'", "<Cmd>ToggleTerm<CR>", { desc = "Toggle Terminal (Leader+')" })
		vim.keymap.set(
			"n",
			"<leader>v",
			"<Cmd>ToggleTerm direction=vertical size=80<CR>",
			{ desc = "Open Terminal Vertical (Leader+V)" }
		)
	end,
}
