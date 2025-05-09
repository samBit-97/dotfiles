return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	opts = function()
		-- Set up the base configuration for mason, mason-lspconfig, and mason-tool-installer.
		require("mason").setup()
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		-- Configure mason
		local base_opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		}

		-- Configure mason-lspconfig for installing LSP servers
		mason_lspconfig.setup({
			automatic_installation = false,
			ensure_installed = {
				"html",
				"cssls",
				"tailwindcss",
				"lua_ls",
				"graphql",
				"pyright",
				"gopls",
				"ts_ls",
				"jdtls",
				"lemminx",
				"terraformls",
			},
		})

		-- Configure mason-tool-installer for additional tools and formatters
		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"pylint",
				"eslint_d",
				"java-test",
				"java-debug-adapter",
				"goimports",
				"gofumpt",
				"golangci-lint",
				"delve",
				"xmlformatter",
			},
		})
		return base_opts
	end,
}
