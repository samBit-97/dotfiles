return {
	-- Replaces neodev.nvim for Neovim 0.11+
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	-- LSP file operations (rename, move awareness)
	{ "antosha417/nvim-lsp-file-operations", config = true },

	-- cmp-nvim-lsp: provides completion capabilities — must be eager so
	-- capabilities are available before any LSP server attaches
	{ "hrsh7th/cmp-nvim-lsp", lazy = false },

	-- Main LSP setup as a local dir spec — Lazy loads it as a local plugin
	-- (no install/update), config runs early due to priority + lazy=false.
	{
		name = "lsp-setup",
		dir = vim.fn.stdpath("config"),
		lazy = false,
		priority = 200,
		config = function()
			-- Shim for telescope 0.1.x calling the deprecated jump_to_location
			-- (removed in Neovim 0.11). Delegates to the new show_document API.
			if not vim.lsp.util.jump_to_location then
				vim.lsp.util.jump_to_location = function(location, offset_encoding, reuse_win)
					return vim.lsp.util.show_document(location, offset_encoding, { reuse_win = reuse_win, focus = true })
				end
			end

			local keymap = vim.keymap

			-- LSP keymaps on attach
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }

					opts.desc = "Show LSP references"
					keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

					opts.desc = "Show LSP references in quickfix"
					keymap.set("n", "grr", vim.lsp.buf.references, opts)

					opts.desc = "Go to declaration"
					keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

					opts.desc = "Show LSP definitions"
					keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

					opts.desc = "Show LSP implementations"
					keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

					opts.desc = "Show LSP type definitions"
					keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

					opts.desc = "See available code actions"
					keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

					opts.desc = "Smart rename"
					keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

					opts.desc = "Show buffer diagnostics"
					keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

					opts.desc = "Show line diagnostics"
					keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

					opts.desc = "Go to previous diagnostic"
					keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

					opts.desc = "Go to next diagnostic"
					keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

					opts.desc = "Show documentation for what is under cursor"
					keymap.set("n", "K", vim.lsp.buf.hover, opts)

					opts.desc = "Restart LSP"
					keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
				end,
			})

			-- Diagnostic signs (Neovim 0.11+ API)
			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN]  = " ",
						[vim.diagnostic.severity.HINT]  = "󰠠 ",
						[vim.diagnostic.severity.INFO]  = " ",
					},
				},
			})

			local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"
			local mason_pkg = vim.fn.stdpath("data") .. "/mason/packages/"

			-- Get cmp capabilities once
			local capabilities = (function()
				local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
				return ok and cmp_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()
			end)()

			-- Helper: start a server, reusing existing client if already running
			local function start(config)
				config.capabilities = capabilities
				vim.lsp.start(config)
			end

			-- Server definitions: filetype pattern -> start function
			local servers = {
				-- Web
				{ ft = { "html" }, fn = function()
					start({ name = "html", cmd = { mason_bin .. "vscode-html-language-server", "--stdio" } })
				end },
				{ ft = { "css", "scss", "less" }, fn = function()
					start({ name = "cssls", cmd = { mason_bin .. "vscode-css-language-server", "--stdio" } })
				end },
				{ ft = { "html", "css", "scss", "javascript", "typescript", "typescriptreact", "javascriptreact", "svelte", "heex" }, fn = function()
					start({ name = "tailwindcss", cmd = { mason_bin .. "tailwindcss-language-server", "--stdio" } })
				end },
				{ ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" }, fn = function()
					start({
						name = "ts_ls",
						cmd = { mason_bin .. "typescript-language-server", "--stdio" },
						init_options = { disableSuggestions = true },
						settings = { completions = { completeFunctionCalls = true } },
						root_dir = vim.fs.root(0, { "tsconfig.json", "jsconfig.json", "package.json", ".git" }),
					})
				end },
				{ ft = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte", "heex" }, fn = function()
					start({ name = "emmet_ls", cmd = { mason_bin .. "emmet-ls", "--stdio" } })
				end },
				{ ft = { "graphql", "gql" }, fn = function()
					start({ name = "graphql", cmd = { mason_bin .. "graphql-lsp", "server", "-m", "stream" },
						root_dir = vim.fs.root(0, { ".graphqlrc", ".graphqlrc.json", "graphql.config.js", ".git" }) })
				end },
				-- Go
				{ ft = { "go", "gomod", "gowork", "gotmpl" }, fn = function()
					start({
						name = "gopls",
						cmd = { mason_bin .. "gopls" },
						root_dir = vim.fs.root(0, { "go.mod", "go.work", ".git" }),
						settings = {
							gopls = {
								completeUnimported = true,
								usePlaceholders = true,
								analyses = { unusedparams = true, shadow = true },
								hints = {
									assignVariableTypes = true,
									compositeLiteralFields = true,
									compositeLiteralTypes = true,
									constantValues = true,
									functionTypeParameters = true,
									parameterNames = true,
									rangeVariableTypes = true,
								},
								staticcheck = true,
							},
						},
					})
				end },
				-- Lua
				{ ft = { "lua" }, fn = function()
					start({
						name = "lua_ls",
						cmd = { mason_bin .. "lua-language-server" },
						root_dir = vim.fs.root(0, { ".luarc.json", ".stylua.toml", ".git" }),
						settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
								completion = { callSnippet = "Replace" },
							},
						},
					})
				end },
				-- Python
				{ ft = { "python" }, fn = function()
					local root = vim.fs.root(0, { "pyrightconfig.json", "pyproject.toml", "setup.cfg", "setup.py", "requirements.txt", ".git" })
						or vim.fs.dirname(vim.api.nvim_buf_get_name(0))
					local pythonPath = vim.fn.exepath("python3") or "python"
					-- detect venv
					for _, venv in ipairs({ "venv", ".venv", "env", ".env" }) do
						local p = root .. "/" .. venv .. "/bin/python"
						if vim.fn.filereadable(p) == 1 then pythonPath = p; break end
					end
					start({
						name = "pyright",
						cmd = { mason_bin .. "pyright-langserver", "--stdio" },
						root_dir = root,
						settings = {
							python = {
								pythonPath = pythonPath,
								analysis = {
									typeCheckingMode = "basic",
									autoSearchPaths = true,
									useLibraryCodeForTypes = true,
									diagnosticMode = "workspace",
									autoImportCompletions = true,
								},
							},
						},
					})
				end },
				-- Elixir
				{ ft = { "elixir", "eelixir", "heex", "surface" }, fn = function()
					start({
						name = "elixirls",
						cmd = { mason_pkg .. "elixir-ls/language_server.sh" },
						root_dir = vim.fs.root(0, { "mix.exs", ".git" }),
						settings = {
							elixirLS = { dialyzerEnabled = false, fetchDeps = false },
						},
					})
				end },
				-- C/C++
				{ ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" }, fn = function()
					local brew = "/opt/homebrew/opt/llvm/bin/clangd"
					local bin = vim.fn.executable(brew) == 1 and brew or mason_bin .. "clangd"
					start({
						name = "clangd",
						cmd = { bin, "--offset-encoding=utf-16", "--header-insertion=iwyu", "--clang-tidy", "--completion-style=detailed", "--enable-config" },
						root_dir = vim.fs.root(0, { "compile_commands.json", "compile_flags.txt", ".git" }),
						on_attach = function(client, _)
							if client.server_capabilities.inlayHintProvider then
								vim.lsp.inlay_hint.enable(false)
							end
						end,
					})
				end },
				-- XML / Terraform
				{ ft = { "xml", "xsd", "xsl", "xslt", "svg" }, fn = function()
					start({ name = "lemminx", cmd = { mason_bin .. "lemminx" } })
				end },
				{ ft = { "terraform", "tf", "terraform-vars" }, fn = function()
					start({ name = "terraformls", cmd = { mason_bin .. "terraform-ls", "serve" },
						root_dir = vim.fs.root(0, { ".terraform", ".git" }) })
				end },
			}

			-- Register a BufReadPre autocmd for each server's filetypes
			for _, server in ipairs(servers) do
				vim.api.nvim_create_autocmd("FileType", {
					pattern = server.ft,
					callback = server.fn,
				})
			end
		end,
	},
}
