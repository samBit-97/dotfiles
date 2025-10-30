return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-go",
		{ "rcasia/neotest-java", version = "*" },
		"jfpedroza/neotest-elixir",
		"nvim-neotest/neotest-python",
		"alfaix/neotest-gtest",
	},
	config = function()
		local function find_elixir_app_dir(path)
			local app_dir = path:match("(.-/apps/[^/]+)")
			return app_dir or vim.fn.getcwd()
		end
		local neotest_ns = vim.api.nvim_create_namespace("neotest")
		vim.diagnostic.config({
			virtual_text = {
				format = function(diagnostic)
					local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
					return message
				end,
			},
		}, neotest_ns)

		require("neotest").setup({
			discovery = {
				enabled = true,
				concurrent = 0,
			},
			adapters = {
				require("neotest-go")({}),
				require("neotest-java")({}),
				require("neotest-elixir")({
					cwd = find_elixir_app_dir,
				}),
				require("neotest-python")({
					dap = { justMyCode = false },
					runner = "pytest",
				}),
				require("neotest-gtest").setup({}),
			},
		})

		-- Neotest Keymaps
		local neotest = require("neotest")

		vim.keymap.set("n", "<Leader>tt", function()
			neotest.run.run()
		end, { desc = "Run nearest test" })

		vim.keymap.set("n", "<Leader>tf", function()
			neotest.run.run(vim.fn.expand("%"))
		end, { desc = "Run all tests in file" })

		vim.keymap.set("n", "<Leader>ta", function()
			neotest.run.run(vim.fn.getcwd())
		end, { desc = "Run all tests in project" })

		vim.keymap.set("n", "<Leader>ts", function()
			neotest.summary.toggle()
		end, { desc = "Toggle test summary" })

		vim.keymap.set("n", "<Leader>to", function()
			neotest.output.open({ enter = true })
		end, { desc = "Show test output" })

		vim.keymap.set("n", "<Leader>tO", function()
			neotest.output_panel.toggle()
		end, { desc = "Toggle test output panel" })

		vim.keymap.set("n", "<Leader>tw", function()
			neotest.watch.toggle(vim.fn.expand("%"))
		end, { desc = "Toggle watch mode" })

		vim.keymap.set("n", "<Leader>tS", function()
			neotest.run.stop()
		end, { desc = "Stop running tests" })

		vim.keymap.set("n", "<Leader>td", function()
			neotest.run.run({ strategy = "dap" })
		end, { desc = "Debug nearest test" })
	end,
}
