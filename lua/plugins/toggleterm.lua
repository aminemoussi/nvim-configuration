-- Replace your entire vim-slime section with this ToggleTerm-based solution:

-- Remove the vim-slime plugin entirely and add these keymaps to your ToggleTerm config:

return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		size = 20,
		open_mapping = [[<c-\>]],
		hide_numbers = true,
		shade_terminals = true,
		start_in_insert = true,
		insert_mappings = true,
		persist_size = true,
		direction = "horizontal",
		close_on_exit = true,
		shell = vim.o.shell,
	},
	config = function(_, opts)
		require("toggleterm").setup(opts)

		local Terminal = require("toggleterm.terminal").Terminal

		-- Python/IPython terminal
		local python_term = Terminal:new({
			cmd = "ipython",
			dir = "git_dir",
			direction = "horizontal",
			count = 1,
		})

		vim.keymap.set("n", "<leader>tp", function()
			python_term:toggle()
		end, { desc = "toggle python terminal" })

		-- Jupyter lab terminal
		local jupyter_term = Terminal:new({
			cmd = "jupyter lab",
			dir = "git_dir",
			direction = "float",
			count = 2,
		})

		vim.keymap.set("n", "<leader>tJ", function()
			jupyter_term:toggle()
		end, { desc = "toggle jupyter lab" })

		-- ================ SLIME REPLACEMENT FUNCTIONS ================
		-- These replace all your vim-slime functionality with ToggleTerm

		-- Send common CV/AI imports
		vim.keymap.set("n", "<leader>si", function()
			if not python_term:is_open() then
				python_term:open()
			end

			-- Send imports one by one for better reliability
			python_term:send("import numpy as np")
			python_term:send("import matplotlib.pyplot as plt")
			python_term:send("import cv2")
			python_term:send("import torch")
			python_term:send("import pandas as pd")
		end, { desc = "send common CV/AI imports" })

		-- Send comprehensive imports
		vim.keymap.set("n", "<leader>sI", function()
			if not python_term:is_open() then
				python_term:open()
			end

			local imports = {
				"import numpy as np",
				"import matplotlib.pyplot as plt",
				"import cv2",
				"import torch",
				"import pandas as pd",
				"import seaborn as sns",
				"from sklearn.model_selection import train_test_split",
				"from sklearn.metrics import accuracy_score, classification_report",
			}

			for _, import_line in ipairs(imports) do
				python_term:send(import_line)
			end
		end, { desc = "send comprehensive CV/AI imports" })

		-- Send current line
		vim.keymap.set("n", "<c-c><c-c>", function()
			if not python_term:is_open() then
				python_term:open()
			end

			local line = vim.api.nvim_get_current_line()
			python_term:send(line)
		end, { desc = "send current line" })

		-- Send visual selection
		vim.keymap.set("v", "<c-c><c-c>", function()
			if not python_term:is_open() then
				python_term:open()
			end

			-- Get visual selection
			local start_pos = vim.fn.getpos("'<")
			local end_pos = vim.fn.getpos("'>")
			local lines = vim.fn.getline(start_pos[2], end_pos[2])

			-- Handle single line selection with character positions
			if #lines == 1 then
				lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
			end

			local text = table.concat(lines, "\n")
			python_term:send(text)
		end, { desc = "send visual selection" })

		-- Send current Quarto code chunk
		vim.keymap.set("n", "<leader>sc", function()
			if not python_term:is_open() then
				python_term:open()
			end

			-- Find current code chunk boundaries
			local line = vim.api.nvim_win_get_cursor(0)[1]
			local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
			local chunk_start, chunk_end = nil, nil

			-- Find chunk start (going backwards)
			for i = line, 1, -1 do
				if lines[i] and lines[i]:match("^```{") then
					chunk_start = i + 1
					break
				end
			end

			-- Find chunk end (going forwards)
			for i = line, #lines do
				if lines[i] and lines[i]:match("^```$") then
					chunk_end = i - 1
					break
				end
			end

			if chunk_start and chunk_end then
				-- Get chunk content and send it
				local chunk_lines = vim.api.nvim_buf_get_lines(0, chunk_start - 1, chunk_end, false)
				local chunk_text = table.concat(chunk_lines, "\n")
				python_term:send(chunk_text)
				print("Sent chunk to terminal")
			else
				print("No code chunk found at cursor")
			end
		end, { desc = "send current chunk to terminal" })

		-- Send paragraph (equivalent to vim-slime's paragraph send)
		vim.keymap.set("n", "<leader>sp", function()
			if not python_term:is_open() then
				python_term:open()
			end

			-- Save current position
			local pos = vim.api.nvim_win_get_cursor(0)

			-- Select paragraph
			vim.cmd("normal! vip")

			-- Get selection
			local start_pos = vim.fn.getpos("'<")
			local end_pos = vim.fn.getpos("'>")
			local lines = vim.fn.getline(start_pos[2], end_pos[2])
			local text = table.concat(lines, "\n")

			-- Restore position
			vim.api.nvim_win_set_cursor(0, pos)

			-- Send to terminal
			python_term:send(text)
		end, { desc = "send paragraph to terminal" })

		-- Quick matplotlib show
		vim.keymap.set("n", "<leader>plt", function()
			if not python_term:is_open() then
				python_term:open()
			end
			python_term:send("plt.show()")
		end, { desc = "show matplotlib plot" })

		-- Clear terminal
		vim.keymap.set("n", "<leader>tc", function()
			if python_term:is_open() then
				python_term:send("clear")
			end
		end, { desc = "clear terminal" })

		-- Restart IPython session
		vim.keymap.set("n", "<leader>tr", function()
			if python_term:is_open() then
				python_term:send("exit")
				vim.defer_fn(function()
					python_term:send("ipython")
				end, 1000)
			end
		end, { desc = "restart IPython session" })
	end,
}
