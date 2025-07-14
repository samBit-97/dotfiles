return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-go",
		{ "rcasia/neotest-java", version = "*" },
		"jfpedroza/neotest-elixir",
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
			},
		})
	end,
}
