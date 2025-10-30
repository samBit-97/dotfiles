return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
				go = { "gofmt" },
				xml = { "xmlformatter" },
				java = { "google-java-format" },
				terraform = { "terraform_fmt" },
				tf = { "terraform_fmt" },
				c = { "clang-format" },
				cpp = { "clang-format" },
			},
			formatters = {
				["google-java-format"] = {
					command = "google-java-format",
					args = { "--aosp", "-" },
					stdin = true,
				},
				["terraform_fmt"] = {
					command = "terraform",
					args = { "fmt", "-" },
					stdin = true,
				},
				["clang-format"] = {
					command = "/opt/homebrew/opt/llvm/bin/clang-format",
					stdin = true,
				},
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
		})

		-- Ensure Java files follow Google Java Format style for tabs and new lines
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = function()
				vim.bo.expandtab = false -- Use tabs instead of spaces
				vim.bo.shiftwidth = 4 -- Indentation width
				vim.bo.tabstop = 4 -- Tab width
				vim.bo.softtabstop = 4 -- Tab behavior
			end,
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
