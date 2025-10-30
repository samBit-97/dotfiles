return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				file_ignore_patterns = {
					-- Version control
					".git/",
					".hg/",
					".svn/",

					-- Dependencies & packages
					"node_modules/",
					"vendor/",
					"deps/",
					"_build/",
					".elixir_ls/",

					-- Build outputs
					"dist/",
					"build/",
					"target/",
					"out/",
					"%.class",
					"%.jar",
					"%.war",

					-- Python
					"__pycache__/",
					"%.pyc",
					"%.pyo",
					"%.egg%-info/",
					".pytest_cache/",
					".venv/",
					"venv/",
					"env/",

					-- Go
					"%.exe",
					"%.test",
					"%.out",

					-- Terraform
					".terraform/",
					"%.tfstate",
					"%.tfstate.backup",

					-- IDE & editors
					".idea/",
					".vscode/",
					"%.swp",
					"%.swo",
					"%.swn",

					-- OS
					".DS_Store",
					"Thumbs.db",

					-- Logs
					"%.log",
				},
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
			pickers = {
				find_files = {
					theme = "ivy",
				},
				oldfiles = {
					theme = "ivy",
				},
				buffers = {
					theme = "ivy",
				},
				live_grep = {
					theme = "ivy",
				},
				grep_string = {
					theme = "ivy",
				},
				lsp_document_symbols = {
					theme = "ivy",
				},
				lsp_workspace_symbols = {
					theme = "ivy",
				},
				git_commits = {
					theme = "ivy",
				},
				git_branches = {
					theme = "ivy",
				},
				git_status = {
					theme = "ivy",
				},
				help_tags = {
					theme = "ivy",
				},
				keymaps = {
					theme = "ivy",
				},
				commands = {
					theme = "ivy",
				},
			},
		})

		telescope.load_extension("fzf")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		-- File searching
		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fb", "<cmd>Telescope buffers sort_mru=true<cr>", { desc = "Find buffers" })

		-- Text searching
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

		-- LSP symbol searching
		keymap.set("n", "<leader>fd", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Find symbols in document" })
		keymap.set(
			"n",
			"<leader>fw",
			"<cmd>Telescope lsp_workspace_symbols<cr>",
			{ desc = "Find symbols in workspace" }
		)
		keymap.set(
			"n",
			"<leader>fm",
			"<cmd>Telescope lsp_document_symbols symbols=method<cr>",
			{ desc = "Find methods in document" }
		)
		keymap.set(
			"n",
			"<leader>fM",
			"<cmd>Telescope lsp_workspace_symbols symbols=method<cr>",
			{ desc = "Find methods in workspace" }
		)

		-- Git searching
		keymap.set("n", "<leader>fgc", "<cmd>Telescope git_commits<cr>", { desc = "Find git commits" })
		keymap.set("n", "<leader>fgb", "<cmd>Telescope git_branches<cr>", { desc = "Find git branches" })
		keymap.set("n", "<leader>fgs", "<cmd>Telescope git_status<cr>", { desc = "Find git status" })

		-- Other useful pickers
		keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Find help tags" })
		keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })
		keymap.set("n", "<leader>fC", "<cmd>Telescope commands<cr>", { desc = "Find commands" })
	end,
}
