local M = {}

function M.get_winbar()
	local filename = vim.fn.expand("%:t") -- Get filename
	local extension = vim.fn.expand("%:e") -- Get file extension

	if filename == "" then
		return " No Name"
	end

	-- Get icon and highlight group from nvim-web-devicons
	local icon, icon_hl = require("nvim-web-devicons").get_icon(filename, extension, { default = true })

	-- Format the winbar: show modified flag + icon + filename
	local modified = vim.bo.modified and " [+] " or ""
	return string.format("%%#%s#%s%%* %s%s", icon_hl or "Normal", icon or "", filename, modified)
end

return M
