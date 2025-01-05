local attach_to_buffer = function(filename, path)
	local command = {
		"docker",
		"container",
		"run",
		"--rm",
		"-v",
		path .. ":/liquibase/social-db", -- Replace with actual paths
		"liquibase/liquibase", -- Replace with your Docker image
		"--defaultsFile=/liquibase/social-db/liquibase.properties",
		"update", -- Example Liquibase command
	}
	-- print("Running..", command)

	vim.api.nvim_create_autocmd("BufWritePost", {
		group = vim.api.nvim_create_augroup("Autorun", { clear = true }),
		pattern = filename,
		callback = function()
			-- Create or reuse the buffer for output
			local buf = vim.fn.bufnr("Output", true) -- Reuse if exists, otherwise create
			vim.api.nvim_buf_set_name(buf, "Output")
			-- Clear the buffer before running the command
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
			local append_data = function(_, data)
				if data then
					vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
				end
			end

			vim.api.nvim_buf_set_lines(buf, 0, 0, false, { "Liquibase : Output" })
			vim.fn.jobstart(command, {
				stdout_buffered = true,
				on_stdout = append_data,
				on_stderr = append_data,
			})
			vim.cmd("vsplit | buffer " .. buf)
			vim.cmd("w!")
		end,
	})
	print("Configuration saved")
end

vim.api.nvim_create_user_command("LiquibaseRun", function()
	local filename = vim.fn.input("Filename: ")
	local path = vim.fn.input("Path: ")
	attach_to_buffer(filename, path)
end, {})
