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
			-- .. " && echo 'Press any key to continue...' && read"
		)
	elseif filetype == "go" then
		vim.cmd(
			"FloatermNew --autoclose=0 --cwd="
				.. vim.fn.fnameescape(file_dir)
				.. " go run "
				.. vim.fn.shellescape(filename)
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

--testing shortcut
local function run_current_file_tests()
	local filetype = vim.bo.filetype
	local file_dir = vim.fn.expand("%:p:h")
	vim.cmd("w")

	if filetype == "rust" then
		vim.cmd(
			"FloatermNew --autoclose=0 --cwd=" .. vim.fn.fnameescape(file_dir) .. " cargo test"
			-- .. " && echo 'Press any key to continue...' && read"
		)
	elseif filetype == "python" then
		local filename = vim.fn.expand("%:t")
		vim.cmd(
			"FloatermNew --autoclose=0 --cwd="
				.. vim.fn.fnameescape(file_dir)
				.. " python3 -m pytest "
				.. vim.fn.shellescape(filename)
		)
	-- Add other languages as needed
	else
		print("No test configuration for filetype: " .. filetype)
	end
end

-- Add a separate keymapping for tests

-- vim.keymap.set("n", "<S-F9>", function()
-- 	print("F9 pressed!")
-- end)
vim.keymap.set("n", "<F9>", run_current_file_tests, { desc = "Run tests for current file" })

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
	insert_code_chunk("rust")
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
vim.keymap.set("n", "<leader>cr", insert_r_chunk, { desc = "Insert Rust chunk" })
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

local function new_terminal_ipython()
	new_terminal("ipython --no-confirm-exit --no-autoindent")
end

local function new_terminal_julia()
	new_terminal("julia")
end

local function new_terminal_shell()
	new_terminal("$SHELL")
end

-- local function new_terminal_rust()
-- 	local cargo_root = vim.fs.find("Cargo.toml", {
-- 		upward = true,
-- 		path = vim.fn.expand("%:p:h"),
-- 	})[1]
--
-- 	if cargo_root then
-- 		-- Found Cargo.toml, go to project root
-- 		local project_dir = vim.fn.fnamemodify(cargo_root, ":h")
-- 		new_terminal("cd " .. project_dir .. " && cargo run")
-- 	else
-- 		-- No Cargo.toml found, offer to create new project
-- 		local current_dir = vim.fn.expand("%:p:h")
-- 		local project_name = "rust_project_" .. os.time() -- Use current folder name
-- 		new_terminal("cd " .. current_dir .. " && cargo init --name " .. project_name .. " && cargo run")
-- 	end
-- end

-- Use <leader>t for terminal mappings
vim.keymap.set("n", "<leader>tp", new_terminal_python, { desc = "New Python terminal" })
vim.keymap.set("n", "<leader>ti", new_terminal_ipython, { desc = "New IPython terminal" })
vim.keymap.set("n", "<leader>tj", new_terminal_julia, { desc = "New Julia terminal" })
vim.keymap.set("n", "<leader>ts", new_terminal_shell, { desc = "New shell terminal" })
-- vim.keymap.set("n", "<leader>tr", new_terminal_rust, { desc = "New rust terminal" })

-- Enhanced window navigation that enters insert mode when moving to terminal
local function move_to_window(direction)
	vim.cmd("wincmd " .. direction)
	-- If we moved to a terminal window, enter insert mode
	if vim.bo.buftype == "terminal" then
		vim.cmd("startinsert")
	end
end

vim.keymap.set("n", "<C-Left>", function()
	move_to_window("h")
end, { desc = "Move to left window" })
vim.keymap.set("n", "<C-Down>", function()
	move_to_window("j")
end, { desc = "Move to window below" })
vim.keymap.set("n", "<C-Up>", function()
	move_to_window("k")
end, { desc = "Move to window above" })
vim.keymap.set("n", "<C-Right>", function()
	move_to_window("l")
end, { desc = "Move to right window" })

-- Arrow keys for terminal mode
vim.keymap.set("t", "<C-Left>", "<C-\\><C-n><C-w>h", { desc = "Move to left window from terminal" })
vim.keymap.set("t", "<C-Down>", "<C-\\><C-n><C-w>j", { desc = "Move to window below from terminal" })
vim.keymap.set("t", "<C-Up>", "<C-\\><C-n><C-w>k", { desc = "Move to window above from terminal" })
vim.keymap.set("t", "<C-Right>", "<C-\\><C-n><C-w>l", { desc = "Move to right window from terminal" })

vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>")

-- vim.keymap.set("n", "<leader>vh", ':execute "h " .. expand("<cword>")<CR>', { desc = "vim [h]elp for current word" })
vim.keymap.set("n", "<leader>vl", ":Lazy<CR>", { desc = "[l]azy package manager" })
vim.keymap.set("n", "<leader>vm", ":Mason<CR>", { desc = "[m]ason software installer" })
-- vim.keymap.set("n", "<leader>vs", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k<CR>", { desc = "[s]ettings, edit vimrc" })
-- vim.keymap.set("n", "<leader>vt", toggle_light_dark_theme, { desc = "[t]oggle light/dark theme" })
--

-- Quarto keymaps
vim.keymap.set("n", "<leader>qE", function()
	require("otter").export(true)
end, { desc = "[E]xport with overwrite" })

vim.keymap.set("n", "<leader>qa", ":QuartoActivate<CR>", { desc = "[a]ctivate" })
vim.keymap.set("n", "<leader>qe", require("otter").export, { desc = "[e]xport" })
vim.keymap.set("n", "<leader>qh", ":QuartoHelp<CR>", { desc = "[h]elp" })
vim.keymap.set("n", "<leader>qp", function()
	require("quarto").quartoPreview()
end, { desc = "[p]review" })

vim.keymap.set("n", "<leader>qu", function()
	require("quarto").quartoUpdatePreview()
end, { desc = "[u]pdate preview" })

vim.keymap.set("n", "<leader>qq", function()
	require("quarto").quartoClosePreview()
end, { desc = "[q]uiet preview" })

-- Run commands
vim.keymap.set("n", "<leader>qra", ":QuartoSendAll<CR>", { desc = "run [a]ll" })
vim.keymap.set("n", "<leader>qrb", ":QuartoSendBelow<CR>", { desc = "run [b]elow" })
vim.keymap.set("n", "<leader>qrr", ":QuartoSendAbove<CR>", { desc = "to cu[r]sor" })

vim.keymap.set("n", "<S-k>", vim.lsp.buf.hover, { desc = "Hover Documentation" })

local function send_to_terminal()
	-- Get the current buffer and cursor position
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local current_line = cursor[1]

	-- Find code chunk boundaries
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local chunk_start = nil
	local chunk_end = nil
	local chunk_lang = nil

	-- Find start of current chunk (look backwards)
	for i = current_line, 1, -1 do
		local line = lines[i]
		if line:match("^```{") then
			chunk_start = i
			-- Extract language from chunk header
			chunk_lang = line:match("^```{([^}]+)")
			if chunk_lang then
				chunk_lang = chunk_lang:match("([^,%s]+)") -- Get first language, ignore options
			end
			break
		elseif line:match("^```%s*$") then
			-- Hit end of previous chunk, current line is not in a chunk
			break
		end
	end

	-- Find end of current chunk (look forwards)
	if chunk_start then
		for i = current_line + 1, #lines do
			local line = lines[i]
			if line:match("^```%s*$") then
				chunk_end = i - 1
				break
			end
		end
		-- If no end found, use end of file
		if not chunk_end then
			chunk_end = #lines
		end
	end

	if not chunk_start or not chunk_end then
		vim.notify("Not inside a code chunk", vim.log.levels.WARN)
		return
	end

	-- Extract code from chunk (skip the ```{lang} line)
	local code_lines = {}
	for i = chunk_start + 1, chunk_end do
		table.insert(code_lines, lines[i])
	end

	if #code_lines == 0 then
		vim.notify("No code in current chunk", vim.log.levels.WARN)
		return
	end

	-- Find terminal window
	local terminal_win = nil
	local terminal_buf = nil

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then
			terminal_win = win
			terminal_buf = buf
			break
		end
	end

	if not terminal_win then
		vim.notify("No terminal window found. Open a terminal first.", vim.log.levels.WARN)
		return
	end

	-- Prepare code to send
	local code_to_send = table.concat(code_lines, "\n")

	-- Language-specific handling
	if chunk_lang == "python" then
		-- For Python, we might want to handle indentation
		code_to_send = code_to_send .. "\n"
	elseif chunk_lang == "r" then
		-- For R, just send as is
		code_to_send = code_to_send .. "\n"
	elseif chunk_lang == "julia" then
		-- For Julia, just send as is
		code_to_send = code_to_send .. "\n"
	else
		-- For other languages, just send as is
		code_to_send = code_to_send .. "\n"
	end

	-- Send code to terminal
	vim.api.nvim_chan_send(vim.api.nvim_buf_get_var(terminal_buf, "terminal_job_id"), code_to_send)

	-- Optional: Focus terminal window
	-- vim.api.nvim_set_current_win(terminal_win)
	-- vim.cmd('startinsert')

	vim.notify("Code sent to terminal", vim.log.levels.INFO)
end

vim.keymap.set("n", "<C-CR>", send_to_terminal, { desc = "Send code chunk to terminal" })
vim.keymap.set("n", "<leader><CR>", send_to_terminal, { desc = "Send code chunk to terminal" })
