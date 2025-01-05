-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Remap paragraph movements } and { to include zz
vim.keymap.set("n", "}", "}zz", { noremap = true, silent = true })
vim.keymap.set("n", "{", "{zz", { noremap = true, silent = true })

-- Remap paragraph movements ) and ( to include zz
vim.keymap.set("n", ")", ")zz", { noremap = true, silent = true })
vim.keymap.set("n", "(", "(zz", { noremap = true, silent = true })

-- Remap other vertical movements to include zz
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true }) -- Half-page down
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true }) -- Half-page up
vim.keymap.set("n", "<C-f>", "<C-f>zz", { noremap = true, silent = true }) -- Full-page down
vim.keymap.set("n", "<C-b>", "<C-b>zz", { noremap = true, silent = true }) -- Full-page up
vim.keymap.set("n", "j", "jzz", { noremap = true, silent = true }) -- Full-page up
vim.keymap.set("n", "k", "kzz", { noremap = true, silent = true }) -- Full-page up
vim.keymap.set("n", "G", "Gzz", { noremap = true, silent = true }) -- Go to end of file
vim.keymap.set("n", "gg", "ggzz", { noremap = true, silent = true }) -- Go to beginning of file

function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")

vim.keymap.set("n", "<leader>ih", function()
	local bufnr = vim.api.nvim_get_current_buf() -- Get the current buffer number
	-- Check if inlay hints are currently enabled for the buffer
	local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
	-- Toggle the state: enable if disabled, disable if enabled
	vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = bufnr })
	-- Print a message for user feedback
	print(is_enabled and "Inlay hints disabled" or "Inlay hints enabled")
end, { desc = "Toggle Inlay Hints" })
