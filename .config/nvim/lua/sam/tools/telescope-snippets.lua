local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")
local themes = require("telescope.themes")

local M = {}

local function get_all_snippet_entries()
	local ls = require("luasnip")
	local entries = {}

	local all = ls.get_snippets()

	for ft, snippets in pairs(all) do
		for _, snip in ipairs(snippets) do
			if not snip.invalidated then
				local desc = snip.description
				if type(desc) == "table" then
					desc = table.concat(desc, " ")
				end
				desc = desc or ""

				local ok, docstring = pcall(function()
					return snip:get_docstring()
				end)
				if not ok then
					docstring = { "(preview unavailable)" }
				end

				table.insert(entries, {
					ft = ft,
					trigger = snip.trigger,
					description = desc,
					docstring = docstring,
				})
			end
		end
	end

	table.sort(entries, function(a, b)
		if a.ft ~= b.ft then
			return a.ft < b.ft
		end
		return a.trigger < b.trigger
	end)

	return entries
end

local function make_entry(entry)
	local display = string.format("%-8s  %-20s  %s", entry.ft, entry.trigger, entry.description)
	return {
		value = entry,
		display = display,
		ordinal = entry.ft .. " " .. entry.trigger .. " " .. entry.description,
	}
end

local snippet_previewer = previewers.new_buffer_previewer({
	title = "Snippet Preview",
	define_preview = function(self, entry)
		local data = entry.value
		local bufnr = self.state.bufnr

		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, data.docstring)
		vim.bo[bufnr].filetype = data.ft
	end,
})

function M.pick(opts)
	opts = opts or {}

	-- Ensure snippets are loaded even if InsertEnter hasn't fired yet
	pcall(function()
		require("luasnip.loaders.from_lua").load({
			paths = vim.fn.expand("~/.config/nvim/lua/snippets"),
		})
	end)

	local entries = get_all_snippet_entries()

	if vim.tbl_isempty(entries) then
		vim.notify("[snippets] No snippets loaded. Open a file of the target filetype first.", vim.log.levels.WARN)
		return
	end

	opts = themes.get_ivy(opts)

	pickers
		.new(opts, {
			prompt_title = "Snippets",
			finder = finders.new_table({
				results = entries,
				entry_maker = make_entry,
			}),
			sorter = conf.generic_sorter(opts),
			previewer = snippet_previewer,
			attach_mappings = function(prompt_bufnr, _map)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					if selection then
						vim.api.nvim_put({ selection.value.trigger }, "c", true, true)
					end
				end)
				return true
			end,
		})
		:find()
end

return M
