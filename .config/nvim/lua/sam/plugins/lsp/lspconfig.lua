return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See :help vim.lsp.* for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Show LSP references in quickfix"
				keymap.set("n", "grr", vim.lsp.buf.references, opts) -- show references in quickfix list

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspconfig.setup_handlers({
			-- default handler for installed servers
			function(server_name)
				if server_name ~= "jdtls" then
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end
			end,
			["ts_ls"] = function()
				lspconfig["ts_ls"].setup({
					capabilities = capabilities,
					init_options = {
						disableSuggestions = true,
					},
					settings = {
						completions = {
							completeFunctionCalls = true,
						},
					},
				})
			end,
			["emmet_ls"] = function()
				-- configure emmet language server
				lspconfig["emmet_ls"].setup({
					capabilities = capabilities,
					filetypes = {
						"html",
						"typescriptreact",
						"javascriptreact",
						"css",
						"sass",
						"scss",
						"less",
						"svelte",
						"heex",
					},
				})
			end,
			["gopls"] = function()
				lspconfig["gopls"].setup({
					capabilities = capabilities,
					settings = {
						gopls = {
							completeUnimported = true,
							usePlaceholders = true,
							analyses = {
								unusedparams = true,
								shadow = true,
							},
							hints = {
								assignVariableTypes = true, -- Show variable types when assigning
								compositeLiteralFields = true, -- Show field names in composite literals
								compositeLiteralTypes = true, -- Show types in composite literals
								constantValues = true, -- Show constant values
								functionTypeParameters = true, -- Show function type parameters
								parameterNames = true, -- Show parameter names
								rangeVariableTypes = true, -- Show types of range variables
							},
							staticcheck = true,
						},
					},
				})
			end,
			["lua_ls"] = function()
				-- configure lua server (with special settings)
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,
			["pyright"] = function()
				lspconfig["pyright"].setup({
					capabilities = capabilities,
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "basic",
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
							},
						},
					},
				})
			end,
			["terraformls"] = function()
				lspconfig["terraformls"].setup({
					capabilities = capabilities,
				})
			end,

			-- Elixir lspconfig
			["elixirls"] = function()
				lspconfig.elixirls.setup({
					capabilities = capabilities,
					cmd = {
						vim.fn.stdpath("data") .. "/mason/packages/elixir-ls/language_server.sh",
					},
					settings = {
						elixirLS = {
							dialyzerEnabled = false,
							fetchDeps = false,
							experimentalFeatures = {
								codeGen = true, -- this is needed for "generate stub" code actions
							},
						},
					},
				})
			end,
			["clangd"] = function()
				lspconfig.clangd.setup({
					capabilities = capabilities,
					cmd = {
						"/opt/homebrew/opt/llvm/bin/clangd",
						"--offset-encoding=utf-16",
						"--header-insertion=iwyu", -- Include What You Use
						"--clang-tidy", -- Enable clang-tidy checks
						"--clang-tidy-checks=*",
						"--completion-style=detailed",
						"--enable-config", -- Load .clang-tidy and .clang-format from project
					},
					cmd_env = {
						PATH = "/opt/homebrew/opt/llvm/bin:" .. vim.env.PATH,
					},
					filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
					root_dir = function(fname)
						-- First try project-level patterns
						local root =
							lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")(fname)
						-- If no project root found, use home directory to pick up global compile_flags.txt
						return root or os.getenv("HOME")
					end,
					settings = {
						clangd = {
							-- C++23 support with libc++
							CompileFlags = {
								Add = { "-std=c++23", "-stdlib=libc++" },
							},
						},
					},
					on_attach = function(client, bufnr)
						-- Enable inlay hints for clangd
						if client.server_capabilities.inlayHintProvider then
							vim.lsp.inlay_hint.enable(false)
						end
					end,
				})
			end,
		})
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("InlayHints", {}),
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client.server_capabilities.inlayHintProvider then
					vim.lsp.inlay_hint.enable(false) -- Use the enable function
				end
			end,
		})
	end,
}
