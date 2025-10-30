return {
	"CRAG666/code_runner.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		local code_runner = require("code_runner")

		-- Helper function to check if file exists
		local function file_exists(path)
			return vim.fn.filereadable(path) == 1
		end

		-- Helper function to get project root directory
		local function get_project_root()
			local cwd = vim.fn.getcwd()
			return cwd
		end

		-- Java executor - handles both Maven projects and standalone files
		local function java_executor()
			local root = get_project_root()
			local has_pom = file_exists(root .. "/pom.xml")
			local has_gradle = file_exists(root .. "/build.gradle")

			if has_pom then
				return "cd $dir && mvn clean compile exec:java -Dexec.mainClass=" .. vim.fn.expand("%:r:t")
			elseif has_gradle then
				return "cd $dir && gradle run"
			else
				-- Standalone Java file
				return "cd $dir && javac $fileName && java $fileNameWithoutExt"
			end
		end

		-- Elixir executor - handles Mix projects and standalone scripts
		local function elixir_executor()
			local root = get_project_root()
			local has_mix = file_exists(root .. "/mix.exs")

			if has_mix then
				return "cd $dir && mix run $fileName"
			else
				-- Standalone Elixir file
				return "elixir $fileName"
			end
		end

		-- Go executor
		local function go_executor()
			return "cd $dir && go run $fileName"
		end

		-- C++ executor - handles CMake, Makefile, multi-file, and standalone projects
		local function cpp_executor()
			local root = get_project_root()
			local has_cmake = file_exists(root .. "/CMakeLists.txt")
			local has_makefile = file_exists(root .. "/Makefile")

			if has_cmake then
				-- CMake project - build and run
				return table.concat({
					"cd $dir && mkdir -p build",
					"cd build && cmake ..",
					"make && ./$(basename $(cd .. && pwd))",
				}, " && ")
			elseif has_makefile then
				-- Makefile project
				return "cd $dir && make && ./$(basename $dir)"
			else
				-- No build system detected - check for multiple .cpp files
				local current_dir = vim.fn.expand("%:p:h")
				local cpp_files = vim.fn.glob(current_dir .. "/*.cpp", false, true)

				-- Configuration
				local compiler = "/opt/homebrew/opt/llvm/bin/clang++"
				local flags = "-g -std=c++23 -Wall -Wextra"
				local build_dir = "./build"

				if #cpp_files > 1 then
					-- Multiple .cpp files detected - compile all together
					-- This handles projects with main.cpp + supporting files (log.cpp, utils.cpp, etc.)
					local all_cpp_files = table.concat(
						vim.tbl_map(function(f)
							return vim.fn.fnamemodify(f, ":t")
						end, cpp_files),
						" "
					)

					-- Try to find main.cpp to determine executable name
					local has_main = false
					for _, f in ipairs(cpp_files) do
						if vim.fn.fnamemodify(f, ":t") == "main.cpp" then
							has_main = true
							break
						end
					end
					local exe_name = has_main and "main" or "app"

					return table.concat({
						"cd $dir",
						"mkdir -p " .. build_dir,
						compiler .. " " .. flags .. " " .. all_cpp_files .. " -o " .. build_dir .. "/" .. exe_name,
						build_dir .. "/" .. exe_name
					}, " && ")
				else
					-- Single standalone C++ file - compile with clang to ./build/
					return "cd $dir && mkdir -p " .. build_dir .. " && " .. compiler .. " " .. flags .. " $fileName -o " .. build_dir .. "/$fileNameWithoutExt && " .. build_dir .. "/$fileNameWithoutExt"
				end
			end
		end

		-- Python executor
		local function python_executor()
			return "python3 -u $fileName"
		end

		-- Rust executor
		local function rust_executor()
			return "cd $dir && rustc $fileName && ./$fileNameWithoutExt"
		end

		-- Direct C++ single file executor (runs ONLY current file, ignores others)
		local function cpp_single_file_executor()
			return "cd $dir && mkdir -p ./build && /opt/homebrew/opt/llvm/bin/clang++ -g -std=c++23 -Wall -Wextra $fileName -o ./build/$fileNameWithoutExt && ./build/$fileNameWithoutExt"
		end

		-- Project-level executors (for <leader>rp - RunProject)
		local function java_project_executor()
			local root = get_project_root()
			local has_pom = file_exists(root .. "/pom.xml")
			local has_gradle = file_exists(root .. "/build.gradle")

			if has_pom then
				-- Maven project - build and run
				return "cd " .. root .. " && mvn clean package"
			elseif has_gradle then
				-- Gradle project - build
				return "cd " .. root .. " && gradle build"
			end
			return nil
		end

		local function go_project_executor()
			local root = get_project_root()
			-- Check for go.mod (Go module project)
			if file_exists(root .. "/go.mod") then
				return "cd " .. root .. " && go build -o ./bin/app && ./bin/app"
			end
			return nil
		end

		local function elixir_project_executor()
			local root = get_project_root()
			-- Check for mix.exs (Mix project)
			if file_exists(root .. "/mix.exs") then
				-- Check if it's a Phoenix app
				local phoenix_check = vim.fn.glob(root .. "/lib/*_web")
				if phoenix_check ~= "" then
					return "cd " .. root .. " && mix ecto.migrate && iex -S mix phx.server"
				else
					return "cd " .. root .. " && mix escript.build && mix run"
				end
			end
			return nil
		end

		local function cpp_project_executor()
			local root = get_project_root()
			local has_cmake = file_exists(root .. "/CMakeLists.txt")
			local has_makefile = file_exists(root .. "/Makefile")

			if has_cmake then
				return "cd " .. root .. " && mkdir -p build && cd build && cmake .. && make"
			elseif has_makefile then
				return "cd " .. root .. " && make"
			end
			return nil
		end

		code_runner.setup({
			mode = "toggleterm",
			focus = true,
			startinsert = true,
			term = {
				position = "belowright",
				size = 20,
			},
			filetype = {
				java = java_executor,
				elixir = elixir_executor,
				go = go_executor,
				cpp = cpp_executor,
				c = cpp_executor,
				python = python_executor,
				rust = rust_executor,
			},
		})

		-- Keymaps
		-- Run current file
		vim.keymap.set("n", "<leader>rc", ":RunCode<CR>", { desc = "Run Code (current file)" })

		-- Run single C++ file directly (ignores other files in directory)
		vim.keymap.set("n", "<leader>rcc", function()
			if vim.bo.filetype == "cpp" or vim.bo.filetype == "c" then
				local cmd = cpp_single_file_executor()
				require("code_runner.commands").run_from_fn(cmd)
			else
				vim.notify("[code-runner] Current file is not C/C++ (.c or .cpp)", vim.log.levels.WARN)
			end
		end, { desc = "Run C++ file (single file only)" })

		-- Run project
		vim.keymap.set("n", "<leader>rp", function()
			local filetype = vim.bo.filetype
			local executor = nil

			if filetype == "java" then
				executor = java_project_executor()
			elseif filetype == "go" then
				executor = go_project_executor()
			elseif filetype == "elixir" then
				executor = elixir_project_executor()
			elseif filetype == "cpp" or filetype == "c" then
				executor = cpp_project_executor()
			end

			if executor then
				require("code_runner.commands").run_from_fn(executor)
			else
				vim.notify("No project configuration found for " .. filetype, vim.log.levels.WARN)
			end
		end, { desc = "Run Project (smart detection)" })

		-- Toggle terminal
		vim.keymap.set("n", "<leader>rs", ":ToggleTerm<CR>", { desc = "Toggle Terminal" })
	end,
}
