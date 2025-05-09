return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"leoluz/nvim-dap-go",
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
				type = "dlv", -- Correct type for Delve adapter
				name = "Launch Go Package",
				request = "launch",
				program = "${workspaceFolder}/cmd/api/", -- Debug package in `cmd/api/`
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
		vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "Start/Continue Debugging" })
		vim.keymap.set("n", "<Leader>dx", dap.terminate, { desc = "Stop Debugging" })
		vim.keymap.set("n", "<F1>", dap.step_over, { desc = "Step Over" })
		vim.keymap.set("n", "<F2>", dap.step_into, { desc = "Step Into" })
		vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Step Out" })
		vim.keymap.set("n", "<F4>", dap.terminate, { desc = "Stop Debugging" })

		-- Debug Go tests easily
		vim.keymap.set("n", "<Leader>dgt", function()
			require("dap-go").debug_test()
		end, { desc = "Debug Go Test" })
	end,
}
