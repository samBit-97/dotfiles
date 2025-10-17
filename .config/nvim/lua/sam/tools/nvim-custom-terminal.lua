local M = {}

-- Cache directory for storing terminal data
local cache_dir = vim.fn.stdpath("data") .. "/terminal-manager"
local history_file = cache_dir .. "/history.json"
local commands_file = cache_dir .. "/predefined_commands.json"

-- Store multiple terminals by ID
M.terminals = {}
M.current_terminal_id = nil
M.last_terminal_buf = nil
M.last_terminal_win = nil
M.command_history = {}
M.predefined_commands = {}

-- Load command history
local function load_history()
	if vim.fn.filereadable(history_file) == 0 then
		return {}
	end

	local file = io.open(history_file, "r")
	if not file then
		return {}
	end

	local content = file:read("*a")
	file:close()

	local ok, history = pcall(vim.json.decode, content)
	if ok and history then
		return history
	end

	return {}
end

-- Save command history
local function save_history()
	vim.fn.mkdir(cache_dir, "p")

	local file = io.open(history_file, "w")
	if not file then
		return
	end

	file:write(vim.json.encode(M.command_history))
	file:close()
end

-- Load predefined commands
local function load_predefined_commands()
	if vim.fn.filereadable(commands_file) == 0 then
		return {}
	end

	local file = io.open(commands_file, "r")
	if not file then
		return {}
	end

	local content = file:read("*a")
	file:close()

	local ok, commands = pcall(vim.json.decode, content)
	if ok and commands then
		return commands
	end

	return {}
end

-- Save predefined commands
local function save_predefined_commands()
	vim.fn.mkdir(cache_dir, "p")

	local file = io.open(commands_file, "w")
	if not file then
		return
	end

	file:write(vim.json.encode(M.predefined_commands))
	file:close()
end

-- Initialize
M.command_history = load_history()
M.predefined_commands = load_predefined_commands()

-- Get project root (for project-specific terminals)
local function get_project_root()
	local cwd = vim.fn.getcwd()
	return cwd
end

vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false

		-- Store terminal info
		local job_id = vim.b.terminal_job_id
		local buf = vim.api.nvim_get_current_buf()

		if M.current_terminal_id then
			M.terminals[M.current_terminal_id] = {
				job_id = job_id,
				buf = buf,
				project = get_project_root(),
			}
		end
	end,
})


-- Get active terminal job ID
local function get_active_terminal()
	local term_id = M.current_terminal_id or "main"
	if M.terminals[term_id] then
		return M.terminals[term_id].job_id
	end
	return nil
end

-- Send command to terminal
function M.send_command(cmd)
	local job_id = get_active_terminal()

	if not job_id then
		vim.notify("[terminal] No terminal open. Please open a project terminal first with <leader>qp", vim.log.levels.WARN)
		return
	end

	vim.fn.chansend(job_id, cmd .. "\n")

	-- Add to history
	table.insert(M.command_history, 1, cmd)
	-- Keep only last 100 commands
	if #M.command_history > 100 then
		table.remove(M.command_history)
	end
	save_history()
end

-- Send visual selection to terminal
function M.send_visual_selection()
	-- Get visual selection
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
	M.send_command(selection)
	vim.notify("[terminal] Sent " .. #lines .. " line(s) to terminal", vim.log.levels.INFO)
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

-- Run command from history
function M.run_from_history()
	if #M.command_history == 0 then
		vim.notify("[terminal] No command history", vim.log.levels.WARN)
		return
	end

	vim.ui.select(M.command_history, {
		prompt = "Select command from history:",
	}, function(choice)
		if choice then
			M.send_command(choice)
		end
	end)
end

-- Add predefined command
function M.add_predefined_command()
	vim.ui.input({
		prompt = "Enter command alias (e.g. test, build): ",
	}, function(alias)
		if not alias or alias == "" then
			return
		end

		vim.ui.input({
			prompt = "Enter command: ",
		}, function(cmd)
			if not cmd or cmd == "" then
				return
			end

			M.predefined_commands[alias] = cmd
			save_predefined_commands()
			vim.notify(string.format('[terminal] Added command "%s"', alias), vim.log.levels.INFO)
		end)
	end)
end

-- Run predefined command
function M.run_predefined_command()
	if vim.tbl_isempty(M.predefined_commands) then
		vim.notify("[terminal] No predefined commands. Use :AddTermCmd to add one.", vim.log.levels.WARN)
		return
	end

	local items = {}
	for alias, cmd in pairs(M.predefined_commands) do
		table.insert(items, {
			alias = alias,
			cmd = cmd,
		})
	end

	table.sort(items, function(a, b)
		return a.alias < b.alias
	end)

	vim.ui.select(items, {
		prompt = "Select predefined command:",
		format_item = function(item)
			return item.alias .. " → " .. item.cmd
		end,
	}, function(choice)
		if choice then
			M.send_command(choice.cmd)
		end
	end)
end

-- Remove predefined command
function M.remove_predefined_command()
	if vim.tbl_isempty(M.predefined_commands) then
		vim.notify("[terminal] No predefined commands to remove.", vim.log.levels.WARN)
		return
	end

	local items = {}
	for alias, _ in pairs(M.predefined_commands) do
		table.insert(items, alias)
	end

	table.sort(items)

	vim.ui.select(items, {
		prompt = "Select command to remove:",
	}, function(choice)
		if choice then
			M.predefined_commands[choice] = nil
			save_predefined_commands()
			vim.notify(string.format('[terminal] Removed command "%s"', choice), vim.log.levels.INFO)
		end
	end)
end

-- Open project-specific terminal
function M.open_project_terminal()
	local project = get_project_root()
	M.current_terminal_id = "project_" .. vim.fn.fnamemodify(project, ":t")

	-- Check if project terminal already exists
	if M.terminals[M.current_terminal_id] then
		local term_info = M.terminals[M.current_terminal_id]
		if vim.api.nvim_buf_is_valid(term_info.buf) then
			vim.cmd.split()
			vim.api.nvim_win_set_buf(0, term_info.buf)
			vim.cmd.wincmd("J")
			vim.api.nvim_win_set_height(0, 15)
			M.last_terminal_win = vim.api.nvim_get_current_win()
			vim.cmd.startinsert()
			return
		end
	end

	-- Create new project terminal
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 15)

	M.last_terminal_buf = vim.api.nvim_get_current_buf()
	M.last_terminal_win = vim.api.nvim_get_current_win()

	vim.cmd.startinsert()
	vim.notify(string.format('[terminal] Opened terminal for project: %s', vim.fn.fnamemodify(project, ":t")), vim.log.levels.INFO)
end

-- List all terminals
function M.list_terminals()
	local items = {}
	for id, term in pairs(M.terminals) do
		if vim.api.nvim_buf_is_valid(term.buf) then
			table.insert(items, {
				id = id,
				project = term.project,
			})
		end
	end

	if #items == 0 then
		vim.notify("[terminal] No terminals open", vim.log.levels.WARN)
		return
	end

	vim.ui.select(items, {
		prompt = "Select terminal:",
		format_item = function(item)
			return item.id .. " (" .. vim.fn.fnamemodify(item.project, ":t") .. ")"
		end,
	}, function(choice)
		if choice then
			M.current_terminal_id = choice.id
			local term_info = M.terminals[choice.id]
			vim.cmd.split()
			vim.api.nvim_win_set_buf(0, term_info.buf)
			vim.cmd.wincmd("J")
			vim.api.nvim_win_set_height(0, 15)
			M.last_terminal_win = vim.api.nvim_get_current_win()
			vim.cmd.startinsert()
		end
	end)
end

-- Register commands
vim.api.nvim_create_user_command("AddTermCmd", M.add_predefined_command, {})
vim.api.nvim_create_user_command("RemoveTermCmd", M.remove_predefined_command, {})
vim.api.nvim_create_user_command("TermHistory", M.run_from_history, {})
vim.api.nvim_create_user_command("TermList", M.list_terminals, {})

-- Keymaps (using <leader>q prefix for terminal/quick commands)
vim.keymap.set("n", "<leader>qp", M.open_project_terminal, { desc = "Open project terminal" })
vim.keymap.set("n", "<leader>ql", M.list_terminals, { desc = "List all terminals" })
vim.keymap.set("n", "<leader>qr", M.run_command, { desc = "Run command in terminal" })
vim.keymap.set("n", "<leader>qh", M.run_from_history, { desc = "Run command from history" })
vim.keymap.set("n", "<leader>qc", M.run_predefined_command, { desc = "Run predefined command" })
vim.keymap.set("v", "<leader>qs", M.send_visual_selection, { desc = "Send selection to terminal" })

return M
