return {
	"williamboman/mason.nvim",
	event = "BufReadPre",
	cmd = "Mason",
	dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
	config = function()
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		require("mason-tool-installer").setup({
			ensure_installed = {
				-- LSP servers (mason package names)
				"html-lsp",
				"css-lsp",
				"tailwindcss-language-server",
				"lua-language-server",
				"graphql-language-service-cli",
				"pyright",
				"gopls",
				"typescript-language-server",
				"jdtls",
				"lemminx",
				"terraform-ls",
				"elixir-ls",
				"emmet-ls",
				"clangd",
				-- Tools
				"prettier",
				"stylua",
				"isort",
				"black",
				"pylint",
				"eslint_d",
				"java-test",
				"java-debug-adapter",
				"goimports",
				"gofumpt",
				"golangci-lint",
				"delve",
				"xmlformatter",
				"clang-format",
			},
		})
	end,
}
