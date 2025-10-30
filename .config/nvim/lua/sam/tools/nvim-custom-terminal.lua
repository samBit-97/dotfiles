local M = {}

-- Store terminal job IDs
M.term_job_id = nil

vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
		-- Store the job ID when terminal opens
		M.term_job_id = vim.b.terminal_job_id
	end,
})

-- Open terminal in bottom split
function M.open_terminal()
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 15)

	-- Get the job ID immediately after opening terminal
	M.term_job_id = vim.bo.channel

	vim.cmd.startinsert()
	return M.term_job_id
end

-- Open floating terminal
function M.open_floating_terminal()
	-- Create a new buffer
	local buf = vim.api.nvim_create_buf(false, true)

	-- Get editor dimensions
	local width = vim.api.nvim_get_option("columns")
	local height = vim.api.nvim_get_option("lines")

	-- Calculate floating window size (80% of screen)
	local win_width = math.floor(width * 0.8)
	local win_height = math.floor(height * 0.8)

	-- Calculate position to center the window
	local row = math.floor((height - win_height) / 2)
	local col = math.floor((width - win_width) / 2)

	-- Window options
	local opts = {
		relative = "editor",
		width = win_width,
		height = win_height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	}

	-- Create floating window
	local win = vim.api.nvim_open_win(buf, true, opts)

	-- Open terminal in the buffer
	vim.fn.termopen(vim.o.shell)

	-- Get the job ID
	M.term_job_id = vim.bo.channel

	vim.cmd.startinsert()
	return M.term_job_id
end

-- Send command to terminal
function M.send_command(cmd, use_floating)
	-- Check if terminal buffer still exists
	local term_valid = false
	if M.term_job_id then
		-- Check if the job is still valid
		local ok = pcall(vim.fn.chansend, M.term_job_id, "")
		term_valid = ok
	end

	if not term_valid then
		vim.notify("[terminal] No terminal open. Opening one now...", vim.log.levels.INFO)
		if use_floating then
			M.open_floating_terminal()
		else
			M.open_terminal()
		end
		-- Wait a bit for terminal to open
		vim.defer_fn(function()
			if M.term_job_id then
				vim.fn.chansend(M.term_job_id, cmd .. "\n")
			end
		end, 100)
	else
		vim.fn.chansend(M.term_job_id, cmd .. "\n")
	end
end

-- Run command from input prompt
function M.run_command()
	vim.ui.input({
		prompt = "Enter command to run: ",
	}, function(cmd)
		if cmd and cmd ~= "" then
			M.send_command(cmd)
		end
	end)
end

-- Send visual selection to terminal
function M.send_visual_selection()
	-- Exit visual mode to update '< and '> marks
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)

	-- Get visual selection marks
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local lines = vim.fn.getline(start_pos[2], end_pos[2])

	if #lines == 0 then
		vim.notify("[terminal] No text selected", vim.log.levels.WARN)
		return
	end

	-- Handle single line selection
	if #lines == 1 then
		lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
	else
		-- Handle multi-line selection
		lines[1] = string.sub(lines[1], start_pos[3])
		lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
	end

	local selection = table.concat(lines, "\n")
	M.send_command(selection, true) -- true = use floating terminal
	vim.notify("[terminal] Sent " .. #lines .. " line(s) to floating terminal", vim.log.levels.INFO)
end

-- Keymaps
vim.keymap.set("n", "<leader>st", M.open_terminal, { desc = "Open terminal in split" })
vim.keymap.set("n", "<leader>sf", M.open_floating_terminal, { desc = "Open floating terminal" })
vim.keymap.set("n", "<leader>sr", M.run_command, { desc = "Run command in terminal" })
vim.keymap.set("v", "<leader>ss", M.send_visual_selection, { desc = "Send selection to terminal" })

return M
