local M = {}

-- Cache file for storing user-defined commands
local cache_dir = vim.fn.stdpath("data") .. "/query-runner"
local cache_file = cache_dir .. "/commands.json"
local db_cache_file = cache_dir .. "/databases.json"

-- Currently selected command
M.selected_command = nil

-- Database cache per command alias
local db_cache = {}

-- Load commands from cache
local function load_commands()
	if vim.fn.filereadable(cache_file) == 0 then
		return {}
	end

	local file = io.open(cache_file, "r")
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

-- Save commands to cache
local function save_commands(commands)
	-- Ensure cache directory exists
	vim.fn.mkdir(cache_dir, "p")

	local file = io.open(cache_file, "w")
	if not file then
		vim.notify("[query-runner] Failed to save commands", vim.log.levels.ERROR)
		return
	end

	file:write(vim.json.encode(commands))
	file:close()
end

-- Load database cache
local function load_db_cache()
	if vim.fn.filereadable(db_cache_file) == 0 then
		return {}
	end

	local file = io.open(db_cache_file, "r")
	if not file then
		return {}
	end

	local content = file:read("*a")
	file:close()

	local ok, cache = pcall(vim.json.decode, content)
	if ok and cache then
		return cache
	end

	return {}
end

-- Save database cache
local function save_db_cache()
	vim.fn.mkdir(cache_dir, "p")

	local file = io.open(db_cache_file, "w")
	if not file then
		return
	end

	file:write(vim.json.encode(db_cache))
	file:close()
end

-- Initialize db_cache on load
db_cache = load_db_cache()

-- Find an existing window showing the given absolute path
local function find_win_by_path(abs_path)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local name = vim.api.nvim_buf_get_name(buf)
		if name == abs_path then
			return win
		end
	end
	return nil
end

-- Get selected text
local function get_visual_selection()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local lines = vim.fn.getline(start_pos[2], end_pos[2])

	if #lines == 0 then
		return ""
	end

	-- Handle single line selection
	if #lines == 1 then
		lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
	else
		-- Handle multi-line selection
		lines[1] = string.sub(lines[1], start_pos[3])
		lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
	end

	return table.concat(lines, "\n")
end


-- Common function to run queries with any backend
local function run_query(name, cmd, query_text)
	-- Check if this is a mongosh command - prompt for database name
	local function execute_query(final_cmd)
		local outfile = vim.fn.stdpath("data") .. "/query-runner/query.out"
		local abs_out = vim.fn.fnamemodify(outfile, ":p")

		-- Write query to temp file
		local tmpfile = vim.fn.tempname()
		local f = io.open(tmpfile, "w")
		if not f then
			vim.notify("[query-runner] Failed to create temp file", vim.log.levels.ERROR)
			return
		end
		f:write(query_text)
		f:close()

		-- Status: running
		vim.api.nvim_echo({ { "[query-runner] Running " .. name .. " query…", "ModeMsg" } }, false, {})
		local t0 = vim.loop.hrtime()

		-- Run the command with the temp file (capture both stdout and stderr)
		local full_cmd
		-- Check if command uses --eval (mongosh style) - pass query as argument
		if final_cmd:match("%-%-eval") then
			full_cmd = final_cmd .. " " .. vim.fn.shellescape(query_text) .. " > " .. vim.fn.shellescape(outfile) .. " 2>&1"
		else
			-- Standard mode - pipe from stdin (psql, mysql, etc.)
			full_cmd = final_cmd .. " < " .. vim.fn.shellescape(tmpfile) .. " > " .. vim.fn.shellescape(outfile) .. " 2>&1"
		end
		local result = vim.fn.system(full_cmd)
		local exit_code = vim.v.shell_error

		-- Clean up temp file
		vim.fn.delete(tmpfile)

		-- Check for errors
		if exit_code ~= 0 then
			vim.notify(string.format("[query-runner] Command failed with exit code %d", exit_code), vim.log.levels.ERROR)
		end

		-- Open or focus existing results split, then reload contents
		local win = find_win_by_path(abs_out)
		if win then
			vim.api.nvim_set_current_win(win)
			vim.cmd("noautocmd edit") -- reload file without flicker
		else
			vim.cmd("split " .. vim.fn.fnameescape(outfile))
		end

		-- Done message with timing
		local ms = math.floor((vim.loop.hrtime() - t0) / 1e6)
		vim.api.nvim_echo({ { string.format("[query-runner] %s query done in %d ms", name, ms), "ModeMsg" } }, false, {})
	end

	-- If mongosh, use cached database or prompt for database name
	if cmd:match("mongosh") then
		-- Check if we have a cached database for this command
		local cached_db = db_cache[name]

		if cached_db then
			-- Use cached database
			local modified_cmd = cmd:gsub("(mongodb[^%s]+)(%s)", function(conn_str, space)
				conn_str = conn_str:gsub("/$", "")
				return conn_str .. "/" .. cached_db .. space
			end)
			execute_query(modified_cmd)
		else
			-- Prompt for database name
			vim.ui.input({
				prompt = "Enter database name: ",
				default = "test",
			}, function(db_name)
				if not db_name or db_name == "" then
					vim.notify("[query-runner] Database name required", vim.log.levels.WARN)
					return
				end

				-- Cache the database name
				db_cache[name] = db_name
				save_db_cache()

				-- Insert database name into connection string
				local modified_cmd = cmd:gsub("(mongodb[^%s]+)(%s)", function(conn_str, space)
					conn_str = conn_str:gsub("/$", "")
					return conn_str .. "/" .. db_name .. space
				end)

				vim.schedule(function()
					execute_query(modified_cmd)
				end)
			end)
		end
	else
		execute_query(cmd)
	end
end

-- Add a new database command
function M.add_command()
	-- Get alias
	vim.ui.input({
		prompt = "Enter command alias (e.g. postgres, mysql, mongo): ",
	}, function(alias)
		if not alias or alias == "" then
			return
		end

		-- Get command
		vim.ui.input({
			prompt = "Enter command (selection will be piped to this): ",
		}, function(cmd)
			if not cmd or cmd == "" then
				return
			end

			-- Add to cached commands
			local commands = load_commands()
			commands[alias] = cmd
			save_commands(commands)

			vim.notify(string.format('[query-runner] Added command "%s"', alias), vim.log.levels.INFO)
		end)
	end)
end

-- Remove commands
function M.remove_command()
	local commands = load_commands()

	if vim.tbl_isempty(commands) then
		vim.notify("[query-runner] No commands to remove.", vim.log.levels.WARN)
		return
	end

	local items = {}
	for alias, cmd in pairs(commands) do
		table.insert(items, alias)
	end

	table.sort(items)

	-- Use vim.ui.select with multiple selection
	local function remove_multiple()
		vim.ui.select(items, {
			prompt = "Select commands to remove (ESC when done):",
			format_item = function(item)
				return item
			end,
		}, function(choice)
			if choice then
				commands[choice] = nil

				-- Clear selected command if it was removed
				if M.selected_command and M.selected_command.alias == choice then
					M.selected_command = nil
				end

				-- Remove from items list
				for i, item in ipairs(items) do
					if item == choice then
						table.remove(items, i)
						break
					end
				end

				vim.notify(string.format('[query-runner] Removed command "%s"', choice), vim.log.levels.INFO)

				-- Continue removing if there are more items
				if #items > 0 then
					vim.schedule(function()
						remove_multiple()
					end)
				else
					save_commands(commands)
					vim.notify("[query-runner] All commands removed.", vim.log.levels.INFO)
				end
			else
				-- User pressed ESC, save and finish
				save_commands(commands)
				if vim.tbl_count(commands) == 0 then
					vim.notify("[query-runner] All commands removed.", vim.log.levels.INFO)
				end
			end
		end)
	end

	remove_multiple()
end

-- Select a command to use
function M.select_command()
	local commands = load_commands()

	if vim.tbl_isempty(commands) then
		vim.notify("[query-runner] No commands configured. Use :AddQueryCmd to add one.", vim.log.levels.WARN)
		return
	end

	local items = {}
	for alias, cmd in pairs(commands) do
		table.insert(items, {
			alias = alias,
			cmd = cmd,
		})
	end

	-- Sort items by alias for consistent ordering
	table.sort(items, function(a, b)
		return a.alias < b.alias
	end)

	-- Add currently selected marker and database info
	local current_alias = M.selected_command and M.selected_command.alias or nil

	vim.ui.select(items, {
		prompt = "Select database command:",
		format_item = function(item)
			local marker = (item.alias == current_alias) and " [current]" or ""
			local db_info = ""
			if item.cmd:match("mongosh") and db_cache[item.alias] then
				db_info = " (db: " .. db_cache[item.alias] .. ")"
			end
			return item.alias .. marker .. db_info
		end,
	}, function(choice)
		if choice then
			M.selected_command = choice
			local db_info = ""
			if choice.cmd:match("mongosh") and db_cache[choice.alias] then
				db_info = " [db: " .. db_cache[choice.alias] .. "]"
			end
			vim.notify(string.format('[query-runner] Selected "%s"%s', choice.alias, db_info), vim.log.levels.INFO)
		end
	end)
end

-- Change database for MongoDB commands
function M.change_database()
	if not M.selected_command then
		vim.notify("[query-runner] No command selected. Use :SelectQueryCmd first.", vim.log.levels.WARN)
		return
	end

	if not M.selected_command.cmd:match("mongosh") then
		vim.notify("[query-runner] Current command is not MongoDB. Database change only works for mongosh.", vim.log.levels.WARN)
		return
	end

	local current_db = db_cache[M.selected_command.alias] or "test"

	vim.ui.input({
		prompt = "Enter new database name: ",
		default = current_db,
	}, function(db_name)
		if not db_name or db_name == "" then
			vim.notify("[query-runner] Database name required", vim.log.levels.WARN)
			return
		end

		-- Update cache
		db_cache[M.selected_command.alias] = db_name
		save_db_cache()

		vim.notify(string.format('[query-runner] Changed database to "%s" for %s', db_name, M.selected_command.alias), vim.log.levels.INFO)
	end)
end

-- Run query with the selected command
function M.run_query()
	-- Get the selected query text
	local query_text = get_visual_selection()

	if query_text == "" then
		vim.notify("[query-runner] No text selected", vim.log.levels.WARN)
		return
	end

	if not M.selected_command then
		-- If no command selected, prompt to select one
		local commands = load_commands()

		if vim.tbl_isempty(commands) then
			vim.notify("[query-runner] No commands configured. Use :AddQueryCmd to add one.", vim.log.levels.ERROR)
			return
		end

		local items = {}
		for alias, cmd in pairs(commands) do
			table.insert(items, {
				alias = alias,
				cmd = cmd,
			})
		end

		-- Sort items by alias for consistent ordering
		table.sort(items, function(a, b)
			return a.alias < b.alias
		end)

		vim.ui.select(items, {
			prompt = "Select database command to run:",
			format_item = function(item)
				return item.alias
			end,
		}, function(choice)
			if choice then
				M.selected_command = choice
				run_query(choice.alias, choice.cmd, query_text)
			end
		end)
	else
		run_query(M.selected_command.alias, M.selected_command.cmd, query_text)
	end
end

-- Register commands
vim.api.nvim_create_user_command("AddQueryCmd", M.add_command, {})
vim.api.nvim_create_user_command("RemoveQueryCmd", M.remove_command, {})
vim.api.nvim_create_user_command("SelectQueryCmd", M.select_command, {})
vim.api.nvim_create_user_command("ChangeDatabase", M.change_database, {})
vim.api.nvim_create_user_command("RunQuery", M.run_query, { range = true })

-- Set up keymaps
vim.keymap.set("v", "<leader>pr", ":RunQuery<CR>", { silent = true, desc = "Run query with selected backend" })
vim.keymap.set("n", "<leader>ps", ":SelectQueryCmd<CR>", { silent = true, desc = "Select query backend" })
vim.keymap.set("n", "<leader>pa", ":AddQueryCmd<CR>", { silent = true, desc = "Add query command" })
vim.keymap.set("n", "<leader>px", ":RemoveQueryCmd<CR>", { silent = true, desc = "Remove query command" })
vim.keymap.set("n", "<leader>pd", ":ChangeDatabase<CR>", { silent = true, desc = "Change MongoDB database" })

return M
