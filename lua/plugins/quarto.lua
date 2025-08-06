return {
	{
		"quarto-dev/quarto-nvim",
		dependencies = {
			"jmbuhr/otter.nvim",
			"neovim/nvim-lspconfig",
		},
		ft = { "quarto", "qmd" },
		config = function()
			require("quarto").setup({
				lspfeatures = {
					enabled = true,
					languages = { "r", "python", "julia", "bash", "lua" },
					chunks = "curly",
					diagnostics = {
						enabled = true,
						triggers = { "bufwritepost" },
					},
					completion = {
						enabled = true,
					},
				},
				codeRunner = {
					enabled = true,
					default_method = "molten", -- Use molten for better notebook experience
					ft_runners = {
						python = "molten",
					},
				},
				keymap = {
					hover = "K", -- Changed to capital K (standard LSP hover)
					definition = "gd",
					type_definition = "gD", -- Changed to capital D
					rename = "<leader>lr",
					format = "<leader>lf",
					references = "gr",
					document_symbols = "gs",
				},
			})

			local quarto = require("quarto")
			local runner = require("quarto.runner")

			vim.keymap.set("n", "<leader>qp", quarto.quartoPreview, { desc = "quarto preview" })
			vim.keymap.set("n", "<leader>qq", quarto.quartoClosePreview, { desc = "quarto close preview" })
			vim.keymap.set("n", "<leader>qh", ":QuartoHelp ", { desc = "quarto help" })
			vim.keymap.set("n", "<leader>qe", ":lua require'otter'.export()<cr>", { desc = "quarto export" })
			vim.keymap.set(
				"n",
				"<leader>qE",
				":lua require'otter'.export(true)<cr>",
				{ desc = "quarto export overwrite" }
			)

			-- Correct chunk navigation using otter
			-- Go to next code chunk
			vim.keymap.set("n", "<C-Down>", function()
				vim.fn.search("^```{", "W")
			end, { desc = "Next Quarto chunk" })

			-- Go to previous code chunk
			vim.keymap.set("n", "<C-Up>", function()
				vim.fn.search("^```{", "bW")
			end, { desc = "Previous Quarto chunk" })

			-- CORRECT chunk execution using quarto runner
			-- vim.keymap.set("n", "<leader>rc", function()
			-- 	runner.run_cell()
			-- end, { desc = "run current chunk" })

			vim.keymap.set("n", "<leader>r", function()
				runner.run_cell()
			end, { desc = "run current chunk" })

			vim.keymap.set("n", "<leader>ra", function()
				runner.run_all()
			end, { desc = "run all chunks" })

			-- Alternative: Send current chunk to runner
			-- vim.keymap.set("n", "<leader>cc", function()
			-- 	runner.run_range(vim.api.nvim_win_get_cursor(0)[1], vim.api.nvim_win_get_cursor(0)[1])
			-- end, { desc = "run current line/cell" })
		end,
	},

	-- Enhanced jupytext for better notebook conversion
	{
		"gcballesteros/jupytext.nvim",
		opts = {
			style = "percent",
			output_extension = "qmd",
			force_ft = "quarto",
			custom_language_formatting = {
				python = {
					extension = "qmd",
					style = "percent",
					force_ft = "quarto",
				},
				r = {
					extension = "qmd",
					style = "percent",
					force_ft = "quarto",
				},
			},
		},
		config = function(_, opts)
			require("jupytext").setup(opts)
			vim.keymap.set(
				"n",
				"<leader>jc",
				":lua require('jupytext').convert()<CR>",
				{ desc = "convert to notebook" }
			)
		end,
	},

	-- Enhanced image clipboard with CV-specific features
	{
		"HakonHarnes/img-clip.nvim",
		event = "VeryLazy",
		ft = { "markdown", "quarto", "latex", "ipynb" },
		opts = {
			default = {
				dir_path = "assets/images",
				file_name = "%Y-%m-%d_%H-%M-%S",
			},
			filetypes = {
				markdown = {
					url_encode_path = true,
					template = "![$CURSOR]($FILE_PATH)",
					drag_and_drop = {
						download_images = true,
					},
				},
				quarto = {
					url_encode_path = true,
					template = "![$CURSOR]($FILE_PATH)",
					drag_and_drop = {
						download_images = true,
					},
				},
			},
		},
		config = function(_, opts)
			require("img-clip").setup(opts)
			vim.keymap.set("n", "<leader>ii", ":PasteImage<cr>", { desc = "insert image from clipboard" })
			vim.keymap.set("n", "<leader>id", ":PasteImage --download<cr>", { desc = "download and insert image" })
		end,
	},

	-- Add data visualization plugin
	{
		"goerz/jupytext.vim",
		ft = { "ipynb" },
		config = function()
			vim.g.jupytext_fmt = "qmd"
			vim.g.jupytext_style = "percent"
		end,
	},

	-- Add better Python support for AI/ML
	{
		"Vimjas/vim-python-pep8-indent",
		ft = { "python" },
	},
}
