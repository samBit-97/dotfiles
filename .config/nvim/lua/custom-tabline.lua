local M = {}

function M.generateTabline()
	local tabline = ""
	for i = 1, vim.fn.tabpagenr("$") do
		local win = vim.fn.tabpagewinnr(i)
		local buf = vim.fn.tabpagebuflist(i)[win]
		local name = vim.fn.fnamemodify(vim.fn.bufname(buf), ":t") -- Get only the file name
		local modified = vim.fn.getbufvar(buf, "&modified") == 1 and "[+]" or "" -- Add [+] if modified
		local hl = (i == vim.fn.tabpagenr()) and "%#TabLineSel#" or "%#TabLine#"
		local tab_number = (i == vim.fn.tabpagenr()) and (i .. ": ") or (i .. ": ") -- Add tab number with colon
		tabline = tabline .. hl .. " " .. tab_number .. "" .. (name == "" and "[No Name]" or name) .. modified .. " "
	end
	return tabline .. "%#TabLineFill#"
end

return M
