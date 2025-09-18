return {
	"jeryldev/pyworks.nvim",
	dependencies = {
		{
			"GCBallesteros/jupytext.nvim",
			config = true,
		},
		{
			"benlubas/molten-nvim",
			build = ":UpdateRemotePlugins",
		},
		"3rd/image.nvim",
	},
	config = function()
		-- Keymap to switch Python interpreter dynamically
		vim.keymap.set("n", "<leader>pv", function()
			local venv = vim.fn.input("Path to Python interpreter: ", vim.g.pyworks_python_path or "python3", "file")
			if venv ~= "" then
				-- Update global var for reference
				vim.g.pyworks_python_path = venv
				-- Reconfigure Pyworks with new interpreter
				require("pyworks").setup({
					python = {
						use_uv = false, -- disable uv so we can manage manually
						python_path = venv,
					},
					image_backend = "kitty",
					skip_keymaps = true,
					jupytext = {
						preferred_format = "py:percent",
					},
				})
				print("✅ Switched Pyworks to: " .. venv)
			end
		end, { desc = "Switch Pyworks Python env" })

		require("pyworks").setup({
			python = {
				use_uv = true,
			},
			image_backend = "kitty",
			skip_keymaps = true,
			jupytext = {
				preferred_format = "py:percent",
			},
		})

		-- Enhanced Molten configuration
		vim.g.molten_use_border_highlights = false
		vim.g.molten_output_win_max_height = 25
		vim.g.molten_output_show_more = true
		vim.g.molten_wrap_output = true
		vim.g.molten_virt_text_output = true
		vim.g.molten_output_virt_lines = true
		vim.g.molten_auto_open_output = false -- Manual control
		vim.g.molten_output_crop_border = true

		local opts = { noremap = true, silent = true }

		-- Cell execution
		vim.keymap.set("n", "<S-CR>", ":MoltenEvaluateLine<CR>j", opts)
		vim.keymap.set("v", "<S-CR>", ":<C-u>MoltenEvaluateVisual<CR>gv", opts)
		vim.keymap.set("n", "<C-CR>", function()
			vim.cmd("MoltenEvaluateOperator")
			vim.api.nvim_feedkeys("ip", "n", false)
		end, opts)

		-- Cell selection and navigation
		vim.keymap.set("n", "<leader>cs", "vip", opts)
		vim.keymap.set("n", "<S-DOWN>", function()
			vim.fn.search("^# %%", "W")
		end, opts)
		vim.keymap.set("n", "<S-UP>", function()
			vim.fn.search("^# %%", "bW")
		end, opts)

		-- Pyworks management
		vim.keymap.set("n", "<leader>pi", ":PyworksInstall<CR>", opts)
		vim.keymap.set("n", "<leader>ps", ":PyworksStatus<CR>", opts)
		vim.keymap.set("n", "<leader>pc", ":PyworksClearCache<CR>", opts)

		-- Notebook creation
		vim.keymap.set("n", "<leader>np", ":PyworksNewPython ", { noremap = true })
		vim.keymap.set("n", "<leader>nn", ":PyworksNewPythonNotebook ", { noremap = true })

		-- Core Output management
		vim.keymap.set("n", "<leader>os", ":MoltenShowOutput<CR>", opts)
		vim.keymap.set("n", "<leader>oh", ":MoltenHideOutput<CR>", opts)
		vim.keymap.set("n", "<leader>oe", ":MoltenEnterOutput<CR>", opts)

		-- Helper function to find and access actual output buffer
		local function get_output_content()
			local current_buf = vim.api.nvim_get_current_buf()
			local current_win = vim.api.nvim_get_current_win()

			-- First try to show output to make sure it's visible
			vim.cmd("MoltenShowOutput")

			-- Look for Molten output buffers
			local output_content = nil
			local output_buf = nil

			-- Method 1: Look for buffers with molten in the name or specific buffer types
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) then
					local buf_name = vim.api.nvim_buf_get_name(buf)
					local buf_type = vim.api.nvim_buf_get_option(buf, "buftype")
					local buf_ft = vim.api.nvim_buf_get_option(buf, "filetype")

					-- Check if this looks like a molten output buffer
					if
						(buf_name:match("molten") or buf_type == "nofile" or buf_ft == "molten_output")
						and buf ~= current_buf
					then
						local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
						if #lines > 0 and lines[1] ~= "" then
							output_content = lines
							output_buf = buf
							break
						end
					end
				end
			end

			-- Method 2: Try MoltenEnterOutput and capture what we get
			if not output_content then
				local success = pcall(function()
					vim.cmd("MoltenEnterOutput")
					local new_buf = vim.api.nvim_get_current_buf()
					if new_buf ~= current_buf then
						local lines = vim.api.nvim_buf_get_lines(new_buf, 0, -1, false)
						if #lines > 0 then
							output_content = lines
							output_buf = new_buf
						end
					end
				end)
			end

			return output_content, output_buf
		end

		-- Fixed copy output function
		vim.keymap.set("n", "<leader>oc", function()
			local output_content, output_buf = get_output_content()

			if output_content and #output_content > 0 then
				-- Filter out empty lines at start/end and join
				local filtered_lines = {}
				local start_idx = 1
				local end_idx = #output_content

				-- Skip empty lines at the beginning
				while
					start_idx <= end_idx
					and (output_content[start_idx] == "" or output_content[start_idx]:match("^%s*$"))
				do
					start_idx = start_idx + 1
				end

				-- Skip empty lines at the end
				while
					end_idx >= start_idx and (output_content[end_idx] == "" or output_content[end_idx]:match("^%s*$"))
				do
					end_idx = end_idx - 1
				end

				-- Collect the actual content
				for i = start_idx, end_idx do
					table.insert(filtered_lines, output_content[i])
				end

				if #filtered_lines > 0 then
					local output_text = table.concat(filtered_lines, "\n")
					vim.fn.setreg("+", output_text)
					print("📋 Output copied to clipboard (" .. #filtered_lines .. " lines)")
				else
					print("❌ No output content found")
				end
			else
				print("❌ No output available to copy")
			end
		end, { desc = "Copy actual cell output to clipboard" })

		-- Fixed split output function
		vim.keymap.set("n", "<leader>of", function()
			local output_content, output_buf = get_output_content()

			if output_content and #output_content > 0 then
				-- Create a new buffer with the output content
				local new_buf = vim.api.nvim_create_buf(false, true)

				-- Set the output content
				vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, output_content)

				-- Open in vertical split
				vim.cmd("vsplit")
				local win = vim.api.nvim_get_current_win()
				vim.api.nvim_win_set_buf(win, new_buf)

				-- Configure the split window
				vim.api.nvim_win_set_width(win, 90)
				vim.api.nvim_win_set_option(win, "number", true)
				vim.api.nvim_win_set_option(win, "wrap", true)
				vim.api.nvim_win_set_option(win, "linebreak", true)
				vim.api.nvim_win_set_option(win, "scrolloff", 5)
				vim.api.nvim_win_set_option(win, "cursorline", true)

				-- Set buffer options
				vim.api.nvim_buf_set_option(new_buf, "buftype", "nofile")
				vim.api.nvim_buf_set_option(new_buf, "bufhidden", "wipe")
				vim.api.nvim_buf_set_option(new_buf, "swapfile", false)
				vim.api.nvim_buf_set_option(new_buf, "filetype", "python") -- For syntax highlighting
				vim.api.nvim_buf_set_name(new_buf, "Cell Output")

				-- Add keymaps for this buffer
				local buf_opts = { buffer = new_buf, noremap = true, silent = true }
				vim.keymap.set("n", "q", "<C-w>c", buf_opts)
				vim.keymap.set("n", "<Esc>", "<C-w>c", buf_opts)
				vim.keymap.set("n", "yy", function()
					vim.cmd(":%y+")
					print("📋 All output copied to clipboard")
				end, buf_opts)
				vim.keymap.set("v", "y", '"+y', buf_opts)

				print("📊 Output in split | q=close, yy=copy all")
			else
				print("❌ No output available to display")
			end
		end, { desc = "Open actual output in split" })

		-- Fixed tab output function
		vim.keymap.set("n", "<leader>ov", function()
			local output_content, output_buf = get_output_content()

			if output_content and #output_content > 0 then
				-- Create a new buffer with the output content
				local new_buf = vim.api.nvim_create_buf(false, true)

				-- Set the output content
				vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, output_content)

				-- Open in new tab
				vim.cmd("tabnew")
				local win = vim.api.nvim_get_current_win()
				vim.api.nvim_win_set_buf(win, new_buf)

				-- Configure the tab
				vim.api.nvim_win_set_option(win, "number", true)
				vim.api.nvim_win_set_option(win, "wrap", true)
				vim.api.nvim_win_set_option(win, "linebreak", true)
				vim.api.nvim_win_set_option(win, "scrolloff", 10)
				vim.api.nvim_win_set_option(win, "cursorline", true)

				-- Set buffer options
				vim.api.nvim_buf_set_option(new_buf, "buftype", "nofile")
				vim.api.nvim_buf_set_option(new_buf, "bufhidden", "wipe")
				vim.api.nvim_buf_set_option(new_buf, "swapfile", false)
				vim.api.nvim_buf_set_option(new_buf, "filetype", "python") -- For syntax highlighting
				vim.api.nvim_buf_set_name(new_buf, "Cell Output - Tab View")

				-- Add keymaps for this buffer
				local buf_opts = { buffer = new_buf, noremap = true, silent = true }
				vim.keymap.set("n", "q", ":tabclose<CR>", buf_opts)
				vim.keymap.set("n", "<Esc>", ":tabclose<CR>", buf_opts)
				vim.keymap.set("n", "yy", function()
					vim.cmd(":%y+")
					print("📋 All output copied to clipboard")
				end, buf_opts)
				vim.keymap.set("v", "y", '"+y', buf_opts)

				-- Enhanced navigation
				vim.keymap.set("n", "<C-d>", "<C-d>zz", buf_opts)
				vim.keymap.set("n", "<C-u>", "<C-u>zz", buf_opts)
				vim.keymap.set("n", "G", "Gzb", buf_opts)
				vim.keymap.set("n", "gg", "ggzt", buf_opts)

				print("📈 Output in tab | q=close, yy=copy, /=search")
			else
				print("❌ No output available to display")
			end
		end, { desc = "Open actual output in new tab" })

		-- Export actual output to file
		vim.keymap.set("n", "<leader>os", function()
			local output_content, output_buf = get_output_content()

			if output_content and #output_content > 0 then
				local filename = vim.fn.input("Save output to file: ", "output_" .. os.date("%Y%m%d_%H%M%S") .. ".txt")
				if filename ~= "" then
					-- Write the content to file
					local file = io.open(filename, "w")
					if file then
						for _, line in ipairs(output_content) do
							file:write(line .. "\n")
						end
						file:close()
						print("💾 Output saved to: " .. filename .. " (" .. #output_content .. " lines)")
					else
						print("❌ Failed to create file: " .. filename)
					end
				end
			else
				print("❌ No output available to export")
			end
		end, { desc = "Export actual output to file" })

		-- Other utility functions
		vim.keymap.set("n", "<leader>oi", function()
			local kernel_id = vim.g.molten_last_kernel_id or vim.b.molten_kernel_id
			if kernel_id then
				print("🐍 Active kernel: " .. kernel_id)
				pcall(function()
					vim.cmd("MoltenInfo")
				end)
			else
				print("❌ No active Molten kernel")
			end
		end, { desc = "Show Molten info" })

		vim.keymap.set("n", "<leader>ot", function()
			local output_visible = vim.g.molten_output_visible or false
			if output_visible then
				vim.cmd("MoltenHideOutput")
				vim.g.molten_output_visible = false
				print("🙈 Output hidden")
			else
				vim.cmd("MoltenShowOutput")
				vim.g.molten_output_visible = true
				print("👀 Output visible")
			end
		end, { desc = "Toggle output visibility" })

		-- vim.keymap.set("n", "<leader>oc", ":MoltenDelete<CR>", { desc = "Clear current cell output" })
		-- vim.keymap.set("n", "<leader>oC", function()
		-- 	local confirm = vim.fn.input("Clear ALL outputs? (y/N): ")
		-- 	if confirm:lower() == "y" then
		-- 		vim.cmd("MoltenDeinit")
		-- 		print("🧹 All outputs cleared")
		-- 	end
		-- end, { desc = "Clear all outputs" })

		-- Navigation
		vim.keymap.set("n", "<leader>on", function()
			vim.fn.search("^# %%", "W")
		end, { desc = "Next cell" })

		vim.keymap.set("n", "<leader>op", function()
			vim.fn.search("^# %%", "bW")
		end, { desc = "Previous cell" })

		-- Add environment info command
		vim.keymap.set("n", "<leader>pe", function()
			vim.cmd("PyworksStatus")
			print("System Python: " .. vim.fn.system("which python"))
			print("PyWorks environment: managed automatically per project")
		end, { desc = "Show Python environment info" })

		-- Minimal floating window for output navigation
		vim.keymap.set("n", "<leader>oo", function()
			local output_content, output_buf = get_output_content()

			if not output_content or #output_content == 0 then
				print("❌ No output available")
				return
			end

			-- Create floating buffer
			local float_buf = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, output_content)

			-- Calculate window size (80% of screen)
			local width = math.floor(vim.o.columns * 0.8)
			local height = math.floor(vim.o.lines * 0.8)
			local row = math.floor((vim.o.lines - height) / 2)
			local col = math.floor((vim.o.columns - width) / 2)

			-- Create floating window
			local float_win = vim.api.nvim_open_win(float_buf, true, {
				relative = "editor",
				width = width,
				height = height,
				row = row,
				col = col,
				border = "rounded",
				title = " Output ",
				title_pos = "center",
			})

			-- Basic window settings
			vim.api.nvim_win_set_option(float_win, "wrap", true)
			vim.api.nvim_win_set_option(float_win, "cursorline", true)

			-- Buffer settings
			vim.api.nvim_buf_set_option(float_buf, "buftype", "nofile")
			vim.api.nvim_buf_set_option(float_buf, "modifiable", false)

			-- Essential keymaps only
			local opts = { buffer = float_buf, noremap = true, silent = true }

			-- Close
			vim.keymap.set("n", "q", function()
				vim.api.nvim_win_close(float_win, true)
			end, opts)
			vim.keymap.set("n", "<Esc>", function()
				vim.api.nvim_win_close(float_win, true)
			end, opts)

			-- Navigation - up/down and top/bottom only
			vim.keymap.set("n", "j", "j", opts)
			vim.keymap.set("n", "k", "k", opts)
			vim.keymap.set("n", "<Up>", "k", opts)
			vim.keymap.set("n", "<Down>", "j", opts)
			vim.keymap.set("n", "gg", "gg", opts)
			vim.keymap.set("n", "G", "G", opts)

			-- Copy all
			vim.keymap.set("n", "yy", function()
				vim.cmd(":%y+")
				print("Output copied")
			end, opts)

			-- Save to file
			vim.keymap.set("n", "s", function()
				local filename = vim.fn.input("Save to: ", "output.txt")
				if filename ~= "" then
					local file = io.open(filename, "w")
					if file then
						for _, line in ipairs(output_content) do
							file:write(line .. "\n")
						end
						file:close()
						print("Saved to " .. filename)
					end
				end
			end, opts)

			print("q=close | yy=copy | s=save | gg/G=top/bottom")
		end, { desc = "Floating output window" })

		-- Help - minimal version
		vim.keymap.set("n", "<leader>o?", function()
			print("Output Navigation:")
			print("  <leader>oo - Floating window")
			print("  <leader>oc - Copy output")
			print("  <leader>os - Save to file")
		end, { desc = "Show help" })
	end,
	lazy = false,
	priority = 100,
}
