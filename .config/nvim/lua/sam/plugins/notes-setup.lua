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
					path = "~/Documents/second-brain",
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

	-- Live Markdown preview in browser
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && npm install",
		ft = { "markdown" },
		cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
		init = function()
			vim.g.mkdp_auto_start = 0
			vim.g.mkdp_auto_close = 1
			vim.g.mkdp_filetypes = { "markdown" }
		end,
	},
}
