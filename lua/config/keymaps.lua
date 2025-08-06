vim.keymap.set({ "n" }, "<leader>-", "<cmd>Oil --float<CR>") --might wanna exclude/include insert mode

vim.keymap.set({ "n" }, "gl", function()
	vim.diagnostic.open_float()
end, { desc = "Open diagnostics in a float" })

vim.keymap.set({ "n" }, "<leader>cf", function()
	require("conform").format()
end, { desc = "Reformat code" })

vim.keymap.set({ "n" }, "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "Toggle Breakpoint" })

vim.keymap.set({ "n" }, "<leader>dpr", function()
	require("dap-python").test_method()
end, { desc = "Launch debugging" })

vim.keymap.set({ "n" }, "<leader>w", "<cmd>:w<CR>")

vim.keymap.set({ "n" }, "<leader>qw", "<cmd>:wq<CR>")

vim.keymap.set({ "n", "v" }, "<leader>ri", ":normal gg=G<CR>") --line reindentation

-- yank to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

-- Global run function for multiple file types
local function run_current_file()
	local filetype = vim.bo.filetype
	local full_filepath = vim.fn.expand("%:p") -- Full absolute path
	local filename = vim.fn.expand("%:t") -- Just filename
	local filename_no_ext = vim.fn.expand("%:t:r") -- Filename without extension
	local file_dir = vim.fn.expand("%:p:h") -- Directory path

	vim.cmd("w")
	local file_ext = vim.fn.expand("%:e")

	-- Use file extension as fallback if filetype detection fails
	if filetype == "cpp" or file_ext == "cpp" or file_ext == "cxx" or file_ext == "cc" then
		vim.cmd(
			"FloatermNew --autoclose=0 --cwd="
				.. vim.fn.fnameescape(file_dir) -- ✅ safer for directory paths
				.. " g++ "
				.. vim.fn.shellescape(filename) -- ✅ this is fine because it's passed to shell
				.. " -o "
				.. vim.fn.shellescape(filename_no_ext)
				.. " && ./"
				.. vim.fn.shellescape(filename_no_ext)
			--.. " && echo 'Press any key to continue...' && read"
		)
	elseif filetype == "c" or file_ext == "c" then
		vim.cmd(
			"FloatermNew --autoclose=0 --cwd="
				.. vim.fn.fnameescape(file_dir)
				.. " gcc "
				.. vim.fn.shellescape(filename)
				.. " -o "
				.. vim.fn.shellescape(filename_no_ext)
				.. " && ./"
				.. vim.fn.shellescape(filename_no_ext)
			--.. " && echo 'Press any key to continue...' && read"
		)
	elseif filetype == "python" then
		vim.cmd(
			"FloatermNew --autoclose=0 --cwd="
				.. vim.fn.fnameescape(file_dir)
				.. " python3 "
				.. vim.fn.shellescape(filename)
			--.. " && echo 'Press any key to continue...' && read"
		)
	elseif filetype == "rust" then
		vim.cmd(
			"FloatermNew --autoclose=0 --cwd="
				.. vim.fn.fnameescape(file_dir)
				.. " rustc "
				.. vim.fn.shellescape(filename)
				.. " -o "
				.. vim.fn.shellescape(filename_no_ext)
				.. " && ./"
				.. vim.fn.shellescape(filename_no_ext)
				.. " && echo 'Press any key to continue...' && read"
		)
	elseif filetype == "go" then
		vim.cmd(
			"FloatermNew --autoclose=0 --cwd="
				.. vim.fn.fnameescape(file_dir)
				.. " go run "
				.. vim.fn.shellescape(filename)
				.. " && echo 'Press any key to continue...' && read"
		)
	elseif filetype == "java" then
		local classname = vim.fn.expand("%:t:r")
		vim.cmd(
			"FloatermNew --autoclose=0 --cwd="
				.. vim.fn.fnameescape(file_dir)
				.. " javac "
				.. vim.fn.shellescape(filename)
				.. " && java "
				.. vim.fn.shellescape(classname)
				.. " && echo 'Press any key to continue...' && read"
		)
	elseif filetype == "sh" or filetype == "bash" then
		vim.cmd(
			"FloatermNew --autoclose=0 --cwd="
				.. vim.fn.fnameescape(file_dir)
				.. " chmod +x "
				.. vim.fn.shellescape(filename)
				.. " && ./"
				.. vim.fn.shellescape(filename)
			--.. " && echo 'Press any key to continue...' && read"
		)
	else
		print("(see keymaps.lua) No run configuration for filetype: " .. filetype)
	end
end

-- Global F5 mapping
vim.keymap.set("n", "<F5>", run_current_file, { desc = "Run current file" })

-- Code chunk insertion functions for Quarto

local is_code_chunk = function()
	local current_line = vim.api.nvim_get_current_line()
	local line_num = vim.api.nvim_win_get_cursor(0)[1]

	-- Look backwards for code chunk start
	for i = line_num, 1, -1 do
		local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1] or ""
		if line:match("^```{") then
			-- Found start, now look forward for end
			for j = line_num, vim.api.nvim_buf_line_count(0) do
				local end_line = vim.api.nvim_buf_get_lines(0, j - 1, j, false)[1] or ""
				if end_line:match("^```%s*$") then
					return true -- We're inside a chunk
				end
			end
		end
	end
	return false
end

--- Insert code chunk of given language
--- Splits current chunk if already within a chunk
--- @param lang string
local insert_code_chunk = function(lang)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", true)
	local keys
	if is_code_chunk() then
		keys = [[o```<cr><cr>```{]] .. lang .. [[}<esc>o]]
	else
		keys = [[o```{]] .. lang .. [[}<cr>```<esc>O]]
	end
	keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
end

local insert_r_chunk = function()
	insert_code_chunk("r")
end
local insert_py_chunk = function()
	insert_code_chunk("python")
end
local insert_lua_chunk = function()
	insert_code_chunk("lua")
end
local insert_julia_chunk = function()
	insert_code_chunk("julia")
end
local insert_bash_chunk = function()
	insert_code_chunk("bash")
end
local insert_ojs_chunk = function()
	insert_code_chunk("ojs")
end

-- Keymaps for code chunk insertion
vim.keymap.set("n", "<leader>cr", insert_r_chunk, { desc = "Insert R chunk" })
vim.keymap.set("n", "<leader>cp", insert_py_chunk, { desc = "Insert Python chunk" })
vim.keymap.set("n", "<leader>cl", insert_lua_chunk, { desc = "Insert Lua chunk" })
vim.keymap.set("n", "<leader>cj", insert_julia_chunk, { desc = "Insert Julia chunk" })
vim.keymap.set("n", "<leader>cb", insert_bash_chunk, { desc = "Insert Bash chunk" })
vim.keymap.set("n", "<leader>co", insert_ojs_chunk, { desc = "Insert OJS chunk" })

-- Terminal functions
local function new_terminal(lang)
	vim.cmd("vsplit term://" .. lang)
end

local function new_terminal_python()
	new_terminal("python")
end

local function new_terminal_r()
	new_terminal("R --no-save")
end

local function new_terminal_ipython()
	new_terminal("ipython --no-confirm-exit --no-autoindent")
end

local function new_terminal_julia()
	new_terminal("julia")
end

local function new_terminal_shell()
	new_terminal("$SHELL")
end

-- Use <leader>t for terminal mappings
vim.keymap.set("n", "<leader>tp", new_terminal_python, { desc = "New Python terminal" })
vim.keymap.set("n", "<leader>tr", new_terminal_r, { desc = "New R terminal" })
vim.keymap.set("n", "<leader>ti", new_terminal_ipython, { desc = "New IPython terminal" })
vim.keymap.set("n", "<leader>tj", new_terminal_julia, { desc = "New Julia terminal" })
vim.keymap.set("n", "<leader>ts", new_terminal_shell, { desc = "New shell terminal" })

local nmap = function(key, effect, desc)
	vim.keymap.set("n", key, effect, { silent = true, remap = false, desc = desc })
end

nmap("<C-h>", "<C-W>h", "Move to left window")
nmap("<C-l>", "<C-W>l", "Move to right window")
