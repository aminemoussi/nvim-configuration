return {
	{
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
			require("pyworks").setup({
				python = {
					use_uv = true,
					-- Specify which Python to use (optional)
					-- python_path = "python3",  -- or specific path
				},
				image_backend = "kitty",
				skip_keymaps = true,

				-- Add Jupytext configuration to handle the error
				jupytext = {
					-- Force specific format to avoid compatibility issues
					preferred_format = "py:percent",
					-- Optional: Set specific jupytext command if needed
					-- command = "jupytext",
				},
			})

			vim.g.molten_use_border_highlights = false
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

			-- Output management (similar to Jupyter's output controls)
			vim.keymap.set("n", "<leader>os", ":MoltenShowOutput<CR>", opts) -- Show output
			vim.keymap.set("n", "<leader>oh", ":MoltenHideOutput<CR>", opts) -- Hide output
			-- vim.keymap.set("n", "<leader>oc", ":MoltenDelete<CR>", opts) -- Clear cell output
			-- vim.keymap.set("n", "<leader>oC", ":MoltenClearImages<CR>", opts) -- Clear all images
			-- vim.keymap.set("n", "<leader>oe", ":MoltenEnterOutput<CR>", opts) -- Enter output window

			-- Add environment info command
			vim.keymap.set("n", "<leader>pe", function()
				-- Show which environment is being used
				vim.cmd("PyworksStatus")
				print("System Python: " .. vim.fn.system("which python"))
				print("PyWorks environment: managed automatically per project")
			end, { desc = "Show Python environment info" })
		end,
		lazy = false,
		priority = 100,
	},
}
