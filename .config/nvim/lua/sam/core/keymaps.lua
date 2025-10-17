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
keymap.set("v", "<leader>+", "g<C-a>", { desc = "Increment number in Visual mode" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement
keymap.set("v", "<leader>-", "g<C-x>", { desc = "Decrement number in Visual mode" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- resize splits
keymap.set("n", "<leader>sH", "<cmd>vertical resize +2<CR>", { desc = "Resize split left (expand)" })
keymap.set("n", "<leader>sJ", "<cmd>resize -2<CR>", { desc = "Resize split down (shrink)" })
keymap.set("n", "<leader>sK", "<cmd>resize +2<CR>", { desc = "Resize split up (expand)" })
keymap.set("n", "<leader>sL", "<cmd>vertical resize -2<CR>", { desc = "Resize split right (shrink)" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Remap paragraph movements } and { to include zz
vim.keymap.set("n", "}", "}zz", { noremap = true, silent = true, desc = "Next paragraph (centered)" })
vim.keymap.set("n", "{", "{zz", { noremap = true, silent = true, desc = "Previous paragraph (centered)" })

-- Remap paragraph movements ) and ( to include zz
vim.keymap.set("n", ")", ")zz", { noremap = true, silent = true, desc = "Next sentence (centered)" })
vim.keymap.set("n", "(", "(zz", { noremap = true, silent = true, desc = "Previous sentence (centered)" })

-- Remap other vertical movements to include zz
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true, desc = "Half-page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true, desc = "Half-page up (centered)" })
vim.keymap.set("n", "<C-f>", "<C-f>zz", { noremap = true, silent = true, desc = "Full-page down (centered)" })
vim.keymap.set("n", "<C-b>", "<C-b>zz", { noremap = true, silent = true, desc = "Full-page up (centered)" })
vim.keymap.set("n", "j", "jzz", { noremap = true, silent = true, desc = "Move down (centered)" })
vim.keymap.set("n", "k", "kzz", { noremap = true, silent = true, desc = "Move up (centered)" })
vim.keymap.set("n", "G", "Gzz", { noremap = true, silent = true, desc = "Go to end of file (centered)" })
vim.keymap.set("n", "gg", "ggzz", { noremap = true, silent = true, desc = "Go to beginning of file (centered)" })

function _G.set_terminal_keymaps()
	local opts = { buffer = 0, desc = "Exit terminal mode" }
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

-- Run the nearest test (Go or Java)
vim.keymap.set("n", "<leader>tm", function()
	require("neotest").run.run()
end, { desc = "Run nearest test " })

-- Run all tests in the current file
vim.keymap.set("n", "<leader>tf", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run all tests in file " })

-- Run the entire test suite
vim.keymap.set("n", "<leader>ta", function()
	require("neotest").run.run(vim.fn.getcwd())
end, { desc = "Run entire test suite " })

-- Show the test summary panel
vim.keymap.set("n", "<leader>tsum", function()
	require("neotest").summary.toggle()
end, { desc = "Toggle test summary" })

-- -- Show test output in a floating window
-- vim.keymap.set("n", "<leader>to", function()
-- 	require("neotest").output.open({ enter = true })
-- end, { desc = "Show test output" })

-- Watch file and rerun tests on save
vim.keymap.set("n", "<leader>tw", function()
	require("neotest").watch.watch()
end, { desc = "Watch test file for changes" })

-- keymap.set("n", "<leader>tc", function()
-- 	if vim.bo.filetype == "python" then
-- 		require("dap-python").test_class()
-- 	end
-- end)
--
-- keymap.set("n", "<leader>tm", function()
-- 	if vim.bo.filetype == "python" then
-- 		require("dap-python").test_method()
-- 	end
-- end)
--
-- Obsidian actions
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "New coding note" })
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Search coding notes" })
vim.keymap.set("n", "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Quick switch notes" })
vim.keymap.set("n", "<leader>of", "<cmd>ObsidianFollowLink<CR>", { desc = "Follow link" })
vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "Show backlinks" })

-- Docker Telescope picker
vim.keymap.set("n", "<leader>fD", function()
	require("sam.tools.telescope-docker").containers()
end, { desc = "Find Docker containers" })
