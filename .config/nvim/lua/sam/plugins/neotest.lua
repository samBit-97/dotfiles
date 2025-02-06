return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-go", -- Go test adapter
		"rcasia/neotest-java", -- Java test adapter
	},
	config = function()
		require("neotest").setup({
			discovery = {
				enabled = true, -- Force-enable test discovery
			},
			adapters = {
				require("neotest-go")({
					experimental = { test_table = true },
					recursive = true,
					args = {
						"-count=1",
						"-timeout=30s",
					},
				}),
				require("neotest-java")({}), -- Java test integration
			},
		})
	end,
}
