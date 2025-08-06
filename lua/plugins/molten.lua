return {
	"benlubas/molten-nvim",
	version = "^1.0.0",
	build = ":UpdateRemotePlugins",
	dependencies = { "3rd/image.nvim" },
	ft = { "quarto", "qmd", "python", "ipynb" },
	init = function()
		-- Core molten settings
		vim.g.molten_image_provider = "image.nvim"
		vim.g.molten_output_win_max_height = 25
		vim.g.molten_auto_open_output = true
		vim.g.molten_wrap_output = true
		vim.g.molten_virt_text_output = true
		vim.g.molten_virt_lines_off_by_1 = true
		vim.g.molten_use_border_highlights = true
		vim.g.molten_tick_rate = 100

		-- Enhanced settings for CV/AI work
		vim.g.molten_output_show_more = true
		vim.g.molten_output_crop_border = true
		vim.g.molten_cover_empty_lines = false
		vim.g.molten_split_direction = "right"
		vim.g.molten_split_size = 40
	end,
	config = function()
		-- Core molten mappings
		vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>", { desc = "initialize molten" })
		vim.keymap.set("n", "<leader>md", ":MoltenDeinit<CR>", { desc = "stop molten" })
		vim.keymap.set("n", "<leader>me", ":MoltenEvaluateOperator<CR>", { desc = "evaluate operator" })
		vim.keymap.set("n", "<leader>ml", ":MoltenEvaluateLine<CR>", { desc = "evaluate line" })
		vim.keymap.set("v", "<leader>mr", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "execute visual selection" })
		vim.keymap.set("n", "<leader>mp", ":MoltenImagePopup<CR>", { desc = "show image popup" })
		vim.keymap.set("n", "<leader>mh", ":MoltenHideOutput<CR>", { desc = "hide output" })
		vim.keymap.set("n", "<leader>ms", ":MoltenShowOutput<CR>", { desc = "show output" })

		-- -- WORKING Jupyter-like cell execution using text objects
		-- vim.keymap.set("n", "<leader>RC", function()
		-- 	-- Use vim text objects to select inside code block
		-- 	vim.cmd("normal! vib")
		-- 	vim.cmd("MoltenEvaluateVisual")
		-- 	-- Move to next chunk
		-- 	vim.cmd("normal! /```{.*}<CR>")
		-- end, { desc = "run chunk and move to next" })

		-- vim.keymap.set("n", "<C-Enter>", function()
		-- 	-- Select inside code block and execute
		-- 	vim.cmd("normal! vib")
		-- 	vim.cmd("MoltenEvaluateVisual")
		-- end, { desc = "run current chunk" })

		-- Alternative method using MoltenEvaluateOperator with text objects
		-- vim.keymap.set("n", "<leader>mcc", ":MoltenEvaluateOperator<CR>ib", { desc = "run code chunk" })

		-- CV/AI specific shortcuts
		vim.keymap.set("n", "<leader>cv", function()
			vim.cmd("normal! vib")
			vim.cmd("MoltenEvaluateVisual")
			vim.cmd("MoltenImagePopup")
		end, { desc = "evaluate and show image" })

		-- Quick matplotlib display
		vim.keymap.set("n", "<leader>plt", function()
			vim.api.nvim_input("aplt.show()<Esc>:MoltenEvaluateLine<CR>")
		end, { desc = "show matplotlib plot" })

		-- Clear all outputs (like Jupyter)
		vim.keymap.set("n", "<leader>mc", ":MoltenReevaluateAll<CR>", { desc = "clear and re-run all" })
	end,
}
