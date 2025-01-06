local M = {}

function M.get_winbar()
	local filename = vim.fn.expand("%:t") -- Get filename
	local extension = vim.fn.expand("%:e") -- Get file extension
	local filetype = vim.bo.filetype

	if filename == "" then
		return " No Name"
	end

	-- Get icon and highlight group from nvim-web-devicons
	local icon, icon_hl = require("nvim-web-devicons").get_icon(filename, extension, { default = true })
	if filetype == "go" then
		icon = "󰟓" -- Custom Go icon
		icon_hl = "Normal" -- Keep it simple or change to a custom highlight group if needed
	end
	-- Format the winbar: show modified flag + icon + filename
	local modified = vim.bo.modified and " [+] " or ""
	return string.format("%%#%s#%s%%* %s%s", icon_hl or "Normal", icon or "", filename, modified)
end

return M
