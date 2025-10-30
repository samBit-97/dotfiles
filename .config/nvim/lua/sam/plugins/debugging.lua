return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"leoluz/nvim-dap-go",
		"mfussenegger/nvim-dap-python",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Setup DAP-UI
		dapui.setup()

		-- Setup dap-go
		require("dap-go").setup()

		-- Setup dap-python
		require("dap-python").setup("/opt/homebrew/bin/python3")

		-- Setup nvim-dap-virtual-text for inline variable display
		require("nvim-dap-virtual-text").setup()

		-- Define Delve Adapter
		dap.adapters.dlv = {
			type = "server",
			host = "127.0.0.1",
			port = "34567",
			executable = {
				command = "dlv",
				args = { "dap", "-l", "127.0.0.1:34567", "--log", "--log-output=dap" },
			},
		}

		-- Debugging Configurations for Go
		dap.configurations.go = {
			{
				type = "dlv", -- Delve adapter
				name = "Launch Go Package",
				request = "launch",
				program = function()
					return vim.fn.input("Path to Go package or file: ", vim.fn.getcwd() .. "/cmd/api/", "file")
				end,
			},
			{
				type = "dlv", -- Correct type for Delve adapter
				name = "Launch Current File",
				request = "launch",
				program = "${file}", -- Debug the currently opened file
			},
			{
				type = "dlv", -- Correct type for Delve adapter
				name = "Attach to Process",
				request = "attach",
				processId = require("dap.utils").pick_process, -- Attach to a running process
			},
		}

		-- Debugging configurations for elixir
		dap.adapters.mix_task = {
			type = "executable",
			command = vim.fn.stdpath("data") .. "/mason/packages/elixir-ls/debug_adapter.sh",
		}

		dap.configurations.elixir = {
			{
				type = "mix_task",
				name = "mix test (DAP)",
				request = "launch",
				task = "test",
				taskArgs = { "--trace" },
				startApps = true,
				projectDir = "${workspaceFolder}",
				requireFiles = {
					"test/**/test_helper.exs",
					"test/**/*_test.exs",
				},
			},
			{
				type = "mix_task",
				name = "mix run (DAP)",
				request = "launch",
				task = "run",
				taskArgs = { "--no-halt" },
				startApps = true,
				projectDir = "${workspaceFolder}",
				requireFiles = {
					"lib/**/*.ex",
				},
			},
			{
				type = "mix_task",
				name = "mix phx.server (DAP)",
				request = "launch",
				task = "phx.server",
				taskArgs = {},
				startApps = true,
				projectDir = "${workspaceFolder}",
				requireFiles = {
					"lib/**/*.ex",
				},
			},
			{
				type = "mix_task",
				name = "Attach to running app",
				remoteNode = "debug@127.0.0.1",
				request = "attach",
				projectDir = "${workspaceFolder}",
			},
		}

		-- Debug listeners to manage DAP-UI
		dap.listeners.before.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		-- Keymaps for Debugging
		vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
		vim.keymap.set("n", "<Leader>dT", function()
			local condition = vim.fn.input("Breakpoint condition: ")
			if condition ~= "" then
				dap.set_breakpoint(condition)
				vim.notify("Conditional breakpoint set: " .. condition, vim.log.levels.INFO)
			else
				vim.notify("Breakpoint condition cancelled", vim.log.levels.WARN)
			end
		end, { desc = "Conditional Breakpoint" })
		vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "Start/Continue Debugging" })
		vim.keymap.set("n", "<Leader>dx", dap.terminate, { desc = "Stop Debugging" })
		vim.keymap.set("n", "<F1>", dap.step_over, { desc = "Step Over" })
		vim.keymap.set("n", "<F2>", dap.step_into, { desc = "Step Into" })
		vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Step Out" })
		vim.keymap.set("n", "<F4>", dap.terminate, { desc = "Stop Debugging" })

		-- LLDB Configuration for C/C++
		dap.adapters.lldb = {
			type = "executable",
			command = "/opt/homebrew/opt/llvm/bin/lldb-dap", -- or "lldb-mi" depending on your setup
		}

		dap.configurations.cpp = {
			{
				name = "Launch C++ Program",
				type = "lldb",
				request = "launch",
				program = function()
					local filename = vim.fn.expand("%:t:r")
					local dir = vim.fn.expand("%:h")
					return dir .. "/build/" .. filename
				end,
				cwd = function()
					return vim.fn.expand("%:h")
				end,
				stopOnEntry = false,
				args = {},
				runInTerminal = false,
				sourceLanguages = { "cpp" },
			},
			{
				name = "Launch C++ Program (Custom Path)",
				type = "lldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
				end,
				cwd = function()
					return vim.fn.getcwd()
				end,
				stopOnEntry = false,
				args = {},
				runInTerminal = false,
				sourceLanguages = { "cpp" },
			},
			{
				name = "Attach to Process",
				type = "lldb",
				request = "attach",
				pid = require("dap.utils").pick_process,
			},
		}

		-- C uses the same configurations as C++
		dap.configurations.c = dap.configurations.cpp

		-- Python debugging configurations (provided by nvim-dap-python)
		-- Already configured by require("dap-python").setup() above
		-- Default configurations available:
		-- - Launch file
		-- - Launch module
		-- - Attach to process
		-- - Pytest (if pytest installed)

	end,
}
