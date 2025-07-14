return {
	"LunarVim/bigfile.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		filesize = 2,
	},
	config = function(_, opts)
		require("bigfile").setup(opts)
	end,
}
