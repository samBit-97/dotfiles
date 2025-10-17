return {
	"LunarVim/bigfile.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		filesize = 2, -- 2MB threshold
		features = { -- features to disable for big files
			"indent_blankline",
			"illuminate",
			"lsp",
			"treesitter",
			"syntax",
			"matchparen",
			"vimopts",
			"filetype",
		},
	},
	config = function(_, opts)
		require("bigfile").setup(opts)
	end,
}
