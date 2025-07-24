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
			vim.keymap.set("n", "]q", function()
				vim.cmd("normal! /```{.*}<CR>")
			end, { desc = "next quarto chunk" })

			vim.keymap.set("n", "[q", function()
				vim.cmd("normal! ?```{.*}<CR>")
			end, { desc = "previous quarto chunk" })

			-- CORRECT chunk execution using quarto runner
			vim.keymap.set("n", "<leader>rc", function()
				runner.run_cell()
			end, { desc = "run current chunk" })

			vim.keymap.set("n", "<leader>ra", function()
				runner.run_all()
			end, { desc = "run all chunks" })

			-- Alternative: Send current chunk to runner
			vim.keymap.set("n", "<leader>cc", function()
				runner.run_range(vim.api.nvim_win_get_cursor(0)[1], vim.api.nvim_win_get_cursor(0)[1])
			end, { desc = "run current line/cell" })
		end,
	},

	-- Enhanced Slime configuration for better REPL integration
	{
		"jpalardy/vim-slime",
		init = function()
			vim.g.slime_target = "tmux"
			vim.g.slime_no_mappings = 1
			vim.g.slime_python_ipython = 1
			vim.g.slime_dont_ask_default = 1 -- Auto-connect to last session
			vim.g.slime_preserve_curpos = 1 -- Keep cursor position
		end,
		config = function()
			vim.keymap.set("n", "<c-c><c-c>", "<plug>slimeparagraphsend", { desc = "send paragraph" })
			vim.keymap.set("n", "<c-c>v", "<plug>slimeconfig", { desc = "slime config" })
			vim.keymap.set("x", "<c-c><c-c>", "<plug>slimeregionsend", { desc = "send selection" })

			-- CV/AI specific mappings
			vim.keymap.set("n", "<leader>si", function()
				vim.fn["slime#send"](
					"import numpy as np\nimport matplotlib.pyplot as plt\nimport cv2\nimport torch\nimport pandas as pd\n"
				)
			end, { desc = "send common CV/AI imports" })

			-- Slime cell execution for quarto (alternative method)
			vim.keymap.set("n", "<leader>sc", function()
				-- Find current code chunk and send to slime
				local line = vim.api.nvim_win_get_cursor(0)[1]
				local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
				local chunk_start, chunk_end = nil, nil

				-- Find chunk boundaries
				for i = line, 1, -1 do
					if lines[i] and lines[i]:match("^```{") then
						chunk_start = i + 1
						break
					end
				end

				for i = line, #lines do
					if lines[i] and lines[i]:match("^```$") then
						chunk_end = i - 1
						break
					end
				end

				if chunk_start and chunk_end then
					-- Select chunk content
					vim.api.nvim_win_set_cursor(0, { chunk_start, 0 })
					vim.cmd("normal! V")
					vim.api.nvim_win_set_cursor(0, { chunk_end, 0 })
					vim.cmd("SlimeRegionSend")
				end
			end, { desc = "send current chunk to slime" })
		end,
	},

	-- Enhanced image support with better CV integration
	{
		"3rd/image.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			backend = "kitty", -- or "ueberzug" for non-kitty terminals
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = false,
					filetypes = { "markdown", "vimwiki", "quarto", "ipynb" },
				},
			},
			max_width = 100,
			max_height = 50,
			max_width_window_percentage = 80,
			max_height_window_percentage = 60,
			window_overlap_clear_enabled = true,
			window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
			editor_only_render_when_focused = false,
			tmux_show_only_in_active_window = false,
			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.bmp", "*.tiff" },
		},
	},

	-- Enhanced Molten configuration for Jupyter-like experience
	{
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

	-- Add better terminal integration
	{
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

			vim.keymap.set("n", "<leader>tj", function()
				jupyter_term:toggle()
			end, { desc = "toggle jupyter lab" })
		end,
	},
}
