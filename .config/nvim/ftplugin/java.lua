local home = os.getenv("HOME")
local jdtls = require("jdtls")

-- Find the root directory FIRST
-- For multi-module projects, prefer .git over pom.xml to find the true root
local root_dir = require("jdtls.setup").find_root({ ".git" })
	or require("jdtls.setup").find_root({ "mvnw", "gradlew" })
	or require("jdtls.setup").find_root({ "pom.xml", "build.gradle" })

-- Exit if no root found
if not root_dir then
	vim.notify("jdtls: No project root found", vim.log.levels.WARN)
	return
end

-- Use root_dir for workspace and .m2 checks
local workspace_path = home .. "/.local/share/nvim/jdtls-workspace/"
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = workspace_path .. project_name

-- Check for project-local .m2 folder at root
local project_m2_settings = root_dir .. "/.m2/settings.xml"
local project_m2_repo = root_dir .. "/.m2/repository"
local has_local_m2 = vim.fn.filereadable(project_m2_settings) == 1

local mason_path = vim.fn.stdpath("data") .. "/mason/packages/"
local bundles = {
	vim.fn.glob(mason_path .. "java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
}
-- Comment out java-test bundles due to OSGi dependency issues
-- vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "java-test/extension/server/*.jar"), "\n"))

-- Build cmd with conditional maven.repo.local
local cmd = {
	"java",
	"-Declipse.application=org.eclipse.jdt.ls.core.id1",
	"-Dosgi.bundles.defaultStartLevel=4",
	"-Declipse.product=org.eclipse.jdt.ls.core.product",
	"-Dlog.protocol=true",
	"-Dlog.level=ALL",
	"-Xmx1g",
	"--add-modules=ALL-SYSTEM",
	"--add-opens",
	"java.base/java.util=ALL-UNNAMED",
	"--add-opens",
	"java.base/java.lang=ALL-UNNAMED",
}

-- Add local maven repo if exists
if has_local_m2 then
	table.insert(cmd, "-Dmaven.repo.local=" .. project_m2_repo)
end

-- Add remaining args
vim.list_extend(cmd, {
	"-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
	"-jar",
	vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
	"-configuration",
	home .. "/.local/share/nvim/mason/packages/jdtls/config_mac",
	"-data",
	workspace_dir,
})

local config = {
	cmd = cmd,
	root_dir = root_dir,

	settings = {
		java = {
			signatureHelp = { enabled = true },
			import = {
				maven = {
					enabled = true,
				},
			},
			maven = {
				downloadSources = true,
				userSettings = has_local_m2 and project_m2_settings or nil,
			},
			configuration = {
				maven = has_local_m2 and {
					userSettings = project_m2_settings,
				} or nil,
				runtimes = {
					{ name = "JavaSE-11", path = os.getenv("HOME") .. "/.sdkman/candidates/java/11.0.28-amzn" },
					{ name = "JavaSE-17", path = os.getenv("HOME") .. "/.sdkman/candidates/java/17.0.13-amzn" },
					{ name = "JavaSE-21", path = os.getenv("HOME") .. "/.sdkman/candidates/java/21.0.6-tem" },
				},
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
			inlayHints = {
				parameterNames = {
					enabled = "all", -- literals, all, none
				},
			},
			format = {
				enabled = false,
			},
		},
	},

	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	flags = {
		allow_incremental_sync = true,
	},
	init_options = {
		bundles = bundles,
		extendedClientCapabilities = jdtls.extendedClientCapabilities,
	},
}

config["on_attach"] = function(client, bufnr)
	jdtls.setup_dap({ hotcodereplace = "auto" })
	require("jdtls.dap").setup_dap_main_class_configs()
end

require("jdtls").start_or_attach(config)

vim.keymap.set("n", "<leader>co", "<Cmd>lua require'jdtls'.organize_imports()<CR>", { desc = "Organize Imports" })
vim.keymap.set("n", "<leader>crv", "<Cmd>lua require('jdtls').extract_variable()<CR>", { desc = "Extract Variable" })
vim.keymap.set(
	"v",
	"<leader>crv",
	"<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
	{ desc = "Extract Variable" }
)
vim.keymap.set("n", "<leader>crc", "<Cmd>lua require('jdtls').extract_constant()<CR>", { desc = "Extract Constant" })
vim.keymap.set(
	"v",
	"<leader>crc",
	"<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>",
	{ desc = "Extract Constant" }
)
vim.keymap.set(
	"v",
	"<leader>crm",
	"<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
	{ desc = "Extract Method" }
)
vim.keymap.set("n", "<leader>tc", function()
	if vim.bo.filetype == "java" then
		require("jdtls").test_class()
	end
end)

vim.keymap.set("n", "<leader>tm", function()
	if vim.bo.filetype == "java" then
		require("jdtls").test_nearest_method()
	end
end)
