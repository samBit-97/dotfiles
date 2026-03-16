return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPost", "BufNewFile" },
	main = "ibl",
	opts = {
		indent = {
			char = "▏",
		},
		scope = {
			enabled = true,
			show_start = true,
			show_end = true,
			show_exact_scope = false,
		},
		whitespace = {
			remove_blankline_trail = true,
		},
		exclude = {
			filetypes = {
				"help",
				"startify",
				"dashboard",
				"packer",
				"neogitstatus",
				"NvimTree",
				"Trouble",
			},
			buftypes = {
				"terminal",
				"nofile",
				"quickfix",
				"prompt",
			},
		},
	},
}
