return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			python = { "pylint" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				-- Only lint if we can find a linter config file
				local ft = vim.bo.filetype
				if ft == "javascript" or ft == "typescript" or ft == "javascriptreact" or ft == "typescriptreact" then
					-- Check if eslint config exists in project root
					local config_files = {
						".eslintrc",
						".eslintrc.js",
						".eslintrc.json",
						".eslintrc.yml",
						"eslint.config.js",
					}
					local root = vim.fn.getcwd()
					local has_config = false
					for _, config in ipairs(config_files) do
						if vim.fn.filereadable(root .. "/" .. config) == 1 then
							has_config = true
							break
						end
					end
					if has_config then
						lint.try_lint()
					end
				else
					-- For other filetypes, lint normally
					lint.try_lint()
				end
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
