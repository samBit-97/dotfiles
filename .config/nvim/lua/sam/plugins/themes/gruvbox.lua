return {
	"sainnhe/gruvbox-material",
	priority = 1000,
	config = function()
		-- Configuration options
		vim.g.gruvbox_material_background = "medium" -- 'hard', 'medium', 'soft'
		vim.g.gruvbox_material_foreground = "material" -- 'material', 'mix', 'original'
		vim.g.gruvbox_material_enable_italic = 1
		vim.g.gruvbox_material_enable_bold = 1
		vim.g.gruvbox_material_transparent_background = 1
		vim.g.gruvbox_material_diagnostic_text_highlight = 1
		vim.g.gruvbox_material_diagnostic_line_highlight = 1
		vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
		vim.g.gruvbox_material_better_performance = 1

		-- Better colors for specific highlights
		vim.g.gruvbox_material_colors_override = {
			bg0 = { "#1d2021", "234" }, -- darker background
		}

		-- Apply colorscheme
		vim.cmd.colorscheme("gruvbox-material")

		-- Additional highlight customizations
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "gruvbox-material",
			callback = function()
				-- Make comments more visible
				vim.cmd([[highlight Comment gui=italic guifg=#928374]])
				-- Better function colors
				vim.cmd([[highlight Function gui=bold guifg=#b8bb26]])
				-- Better keyword colors
				vim.cmd([[highlight Keyword gui=italic guifg=#fb4934]])
			end,
		})

		-- Toggle background transparency
		vim.keymap.set("n", "<leader>bg", function()
			if vim.g.gruvbox_material_transparent_background == 1 then
				vim.g.gruvbox_material_transparent_background = 0
			else
				vim.g.gruvbox_material_transparent_background = 1
			end
			vim.cmd.colorscheme("gruvbox-material")
		end, { noremap = true, silent = true, desc = "Toggle background transparency" })

		-- Toggle background hardness (hard/medium/soft)
		vim.keymap.set("n", "<leader>th", function()
			local backgrounds = { "hard", "medium", "soft" }
			local current = vim.g.gruvbox_material_background or "medium"
			local current_index = 1
			for i, bg in ipairs(backgrounds) do
				if bg == current then
					current_index = i
					break
				end
			end
			local next_index = (current_index % #backgrounds) + 1
			vim.g.gruvbox_material_background = backgrounds[next_index]
			vim.cmd.colorscheme("gruvbox-material")
			vim.notify("Background: " .. backgrounds[next_index], vim.log.levels.INFO)
		end, { noremap = true, silent = true, desc = "Toggle background hardness" })
	end,
}
