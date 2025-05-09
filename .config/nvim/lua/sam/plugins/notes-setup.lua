return {
	-- Obsidian.nvim - Manage your coding notes
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "coding",
					path = "~/Documents/coding-notes",
				},
			},
			ui = {
				enable = false,
			},
			completion = {
				nvim_cmp = true,
			},
		},
	},

	-- Render markdown beautifully
	{
		"MeanderingProgrammer/markdown.nvim",
		name = "render-markdown",
		ft = "markdown",
		opts = {
			highlights = {
				heading = "Title",
				bullet = "SpecialChar",
				quote = "Comment",
			},
			bullet_signs = { "•", "◦", "▪", "‣" },
			quote_signs = { "┃", "│", "▏" },
			render_bullets = true,
			render_quotes = true,
			render_headings = true,
			always_render = true,
			follow_url_func = function(url)
				vim.fn.jobstart({ "open", url }, { detach = true }) -- Mac
				-- Or if Linux: vim.fn.jobstart({ "xdg-open", url }, { detach = true })
			end,
		},
	},
}
