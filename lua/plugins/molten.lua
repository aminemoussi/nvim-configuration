return {
	"benlubas/molten-nvim",
	version = "^1.0.0",
	build = ":UpdateRemotePlugins",
	--dependencies = { "3rd/image.nvim" },
	ft = { "quarto", "qmd", "python", "ipynb" },
	init = function()
		-- Core molten settings (unchanged)
		-- vim.g.molten_image_provider = "image.nvim"
		vim.g.molten_output_win_max_height = 25
		vim.g.molten_auto_open_output = true
		vim.g.molten_wrap_output = true
		vim.g.molten_virt_text_output = true
		vim.g.molten_virt_lines_off_by_1 = true
		vim.g.molten_use_border_highlights = true
		vim.g.molten_tick_rate = 100
		-- Enhanced settings for CV/AI work (unchanged)
		vim.g.molten_output_show_more = true
		vim.g.molten_output_crop_border = true
		vim.g.molten_cover_empty_lines = false
		vim.g.molten_split_direction = "right"
		vim.g.molten_split_size = 40
	end,
	config = function()
		-- Core molten mappings (unchanged)
		vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>", { desc = "initialize molten" })
		vim.keymap.set("n", "<leader>md", ":MoltenDeinit<CR>", { desc = "stop molten" })
		vim.keymap.set("n", "<leader>me", ":MoltenEvaluateOperator<CR>", { desc = "evaluate operator" })
		vim.keymap.set("n", "<leader>ml", ":MoltenEvaluateLine<CR>", { desc = "evaluate line" })
		vim.keymap.set("v", "<leader>mr", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "execute visual selection" })
		-- vim.keymap.set("n", "<leader>mp", ":MoltenImagePopup<CR>", { desc = "show image popup" })
		vim.keymap.set("n", "<leader>mh", ":MoltenHideOutput<CR>", { desc = "hide output" })
		vim.keymap.set("n", "<leader>ms", ":MoltenShowOutput<CR>", { desc = "show output" })

		-- Quarto chunk execution and navigation
		vim.keymap.set("n", "<leader>rr", function()
			-- Save current cursor position
			local cursor_pos = vim.api.nvim_win_get_cursor(0)
			local current_line = cursor_pos[1]

			-- Check if we're currently on a chunk start line
			local current_line_content = vim.api.nvim_buf_get_lines(0, current_line - 1, current_line, false)[1]
			local chunk_start_line

			if current_line_content and current_line_content:match("^```{.*}") then
				chunk_start_line = current_line
			else
				-- Search backward for the start of the current chunk
				local start_pos = vim.fn.search("^```{.*}", "bcnW")
				if start_pos == 0 then
					print("No code chunk found")
					return
				end
				chunk_start_line = start_pos
			end

			-- Search forward from the chunk start for the closing ```
			local end_pos = vim.fn.search("^```$", "nW")
			if end_pos == 0 then
				print("No closing chunk marker found")
				return
			end

			-- Verify the cursor was actually inside this chunk
			if current_line < chunk_start_line or current_line >= end_pos then
				print("Cursor not inside a code chunk")
				vim.api.nvim_win_set_cursor(0, cursor_pos)
				return
			end

			-- Calculate the actual code lines (excluding the chunk markers)
			local code_start_line = chunk_start_line + 1
			local code_end_line = end_pos - 1

			-- Check if there's actually code to execute
			if code_start_line > code_end_line then
				print("Empty code chunk")
				vim.api.nvim_win_set_cursor(0, cursor_pos)
				return
			end

			-- Set visual selection using nvim_buf_set_mark
			vim.fn.setpos("'<", { 0, code_start_line, 1, 0 })
			vim.fn.setpos("'>", { 0, code_end_line, vim.fn.col({ code_end_line, "$" }) - 1, 0 })

			-- Execute the visual selection
			vim.cmd("normal! gv")
			vim.cmd("MoltenEvaluateVisual")
			vim.cmd("normal! <Esc>") -- Add this line to exit visual mode

			-- Restore cursor position (this is the key fix - do it immediately after execution)
			vim.api.nvim_win_set_cursor(0, cursor_pos)

			-- Optional: Just check if there's a next chunk without moving cursor
			local next_chunk = vim.fn.search("^```{.*}", "nW") -- Use 'n' flag to not move cursor
			if next_chunk == 0 then
				print("No more chunks found")
			else
				print("Next chunk available at line " .. next_chunk)
			end
		end, { desc = "run quarto chunk" })

		-- vim.keymap.set("n", "<C-Enter>", function()
		-- 	-- Save current cursor position
		-- 	local cursor_pos = vim.api.nvim_win_get_cursor(0)
		-- 	-- Search backward for the start of the current chunk
		-- 	if vim.fn.search("^```[{].*$", "bcW") == 0 then
		-- 		print("No code chunk found")
		-- 		return
		-- 	end
		-- 	-- Move to the line after the opening ```{...}
		-- 	vim.cmd("normal! j")
		-- 	-- Mark the start of the code
		-- 	local start_line = vim.fn.line(".")
		-- 	-- Search forward for the closing ```
		-- 	if vim.fn.search("^```$", "W") == 0 then
		-- 		print("No closing chunk marker found")
		-- 		vim.api.nvim_win_set_cursor(0, cursor_pos)
		-- 		return
		-- 	end
		-- 	-- Move back to the line before the closing ```
		-- 	local end_line = vim.fn.line(".") - 1
		-- 	-- Select the entire code block
		-- 	vim.cmd("normal! " .. start_line .. "GV" .. end_line .. "G")
		-- 	vim.cmd("MoltenEvaluateVisual")
		-- 	-- Restore cursor position
		-- 	vim.api.nvim_win_set_cursor(0, cursor_pos)
		-- end, { desc = "run current quarto chunk" })

		-- Navigate to next/previous chunk (unchanged)
		-- vim.keymap.set("n", "<leader>rj", function()
		-- 	vim.fn.search("^```[{].*$", "W")
		-- end, { desc = "jump to next quarto chunk" })
		--
		-- vim.keymap.set("n", "<leader>rk", function()
		-- 	vim.fn.search("^```[{].*$", "bW")
		-- end, { desc = "jump to previous quarto chunk" })
		--
		-- CV/AI specific shortcuts (unchanged)
		-- vim.keymap.set("n", "<leader>cv", function()
		-- 	vim.cmd("normal! vib")
		-- 	vim.cmd("MoltenEvaluateVisual")
		-- 	vim.cmd("MoltenImagePopup")
		-- end, { desc = "evaluate and show image" })
		--
		-- Quick matplotlib display (unchanged)
		-- vim.keymap.set("n", "<leader>plt", function()
		-- 	vim.api.nvim_input("aplt.show()<Esc>:MoltenEvaluateLine<CR>")
		-- end, { desc = "show matplotlib plot" })
		--
		-- Clear all outputs (unchanged)
		vim.keymap.set("n", "<leader>mc", ":MoltenReevaluateAll<CR>", { desc = "clear and re-run all" })
	end,
}
