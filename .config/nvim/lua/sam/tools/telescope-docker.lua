local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

-- Get list of Docker containers (only running)
local function get_containers()
	local handle = io.popen("docker ps --format '{{.ID}}|{{.Names}}|{{.Status}}|{{.Image}}'")
	if not handle then
		return {}
	end

	local result = handle:read("*a")
	handle:close()

	local containers = {}
	for line in result:gmatch("[^\r\n]+") do
		local id, name, status, image = line:match("([^|]+)|([^|]+)|([^|]+)|([^|]+)")
		if id and name then
			-- Show running status
			local status_short = "🟢 Up"

			-- Shorten image name (remove registry/tag if too long)
			local image_short = image:match("([^/:]+)") or image
			if #image_short > 25 then
				image_short = image_short:sub(1, 22) .. "..."
			end

			table.insert(containers, {
				id = id,
				name = name,
				status = status,
				image = image,
				display = string.format("%-7s %-40s %s", status_short, name, image_short),
			})
		end
	end

	return containers
end

-- Docker containers picker
function M.containers(opts)
	opts = opts or {}

	pickers
		.new(opts, {
			prompt_title = "Docker Containers (Enter: logs | <C-e>: bash/sh | <C-s>: start/stop | <C-x>: remove)",
			finder = finders.new_table({
				results = get_containers(),
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry.display,
						ordinal = entry.name .. " " .. entry.status .. " " .. entry.image,
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				-- Default action: streaming logs (follow mode)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)

					if selection then
						local container = selection.value
						vim.cmd("split")
						vim.cmd("terminal docker logs -f --tail 100 " .. container.id)
						vim.cmd("startinsert")
					end
				end)

				-- Bash/sh into container
				map("i", "<C-e>", function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)

					if selection then
						local container = selection.value
						local is_running = container.status:match("Up") ~= nil

						if not is_running then
							vim.notify("Container is not running: " .. container.name, vim.log.levels.WARN)
							return
						end

						-- Try bash first, fallback to sh
						vim.cmd("split")
						vim.cmd(
							"terminal docker exec -it "
								.. container.id
								.. " bash 2>/dev/null || docker exec -it "
								.. container.id
								.. " sh"
						)
						vim.cmd("startinsert")
					end
				end)

				-- Start/Stop container
				map("i", "<C-s>", function()
					local selection = action_state.get_selected_entry()
					if selection then
						local container = selection.value
						local is_running = container.status:match("Up") ~= nil

						if is_running then
							vim.fn.system("docker stop " .. container.id)
							vim.notify("Stopped container: " .. container.name, vim.log.levels.INFO)
						else
							vim.fn.system("docker start " .. container.id)
							vim.notify("Started container: " .. container.name, vim.log.levels.INFO)
						end

						-- Refresh the picker
						local current_picker = action_state.get_current_picker(prompt_bufnr)
						current_picker:refresh(finders.new_table({
							results = get_containers(),
							entry_maker = function(entry)
								return {
									value = entry,
									display = entry.display,
									ordinal = entry.name .. " " .. entry.status .. " " .. entry.image,
								}
							end,
						}))
					end
				end)

				-- Remove container
				map("i", "<C-x>", function()
					local selection = action_state.get_selected_entry()
					if selection then
						local container = selection.value
						local confirm = vim.fn.input("Remove container '" .. container.name .. "'? (y/N): ")
						if confirm:lower() == "y" then
							vim.fn.system("docker rm -f " .. container.id)
							vim.notify("Removed container: " .. container.name, vim.log.levels.INFO)

							-- Refresh the picker
							local current_picker = action_state.get_current_picker(prompt_bufnr)
							current_picker:refresh(finders.new_table({
								results = get_containers(),
								entry_maker = function(entry)
									return {
										value = entry,
										display = entry.display,
										ordinal = entry.name .. " " .. entry.status .. " " .. entry.image,
									}
								end,
							}))
						end
					end
				end)

				return true
			end,
		})
		:find()
end

return M
