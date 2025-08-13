return {
	--THEME
	{
		{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
		{
			"baliestri/aura-theme",
			lazy = false,
			priority = 1000,
			transparent = true,
			config = function(plugin)
				vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
				vim.cmd([[colorscheme aura-dark]])
				---transparancy
				vim.api.nvim_set_hl(0, "Normal", { bg = "none" }) --main editor area to transparent.
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }) --popups like autocompletion
				vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
				vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
			end,
		},
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				css = { css_fn = true, css = true },
				"javascript",
				"html",
				"r",
				"rmd",
				"qmd",
				"markdown",
				"python",
			})
		end,
	},

	{ -- nice quickfix list
		"stevearc/quicker.nvim",
		event = "FileType qf",
		opts = {
			winfixheight = false,
			wrap = true,
		},
	},

	{
		"RRethy/vim-illuminate",
		config = function()
			require("illuminate").configure({
				-- providers: provider used to get references in the buffer, ordered by priority
				providers = {
					"lsp",
					"treesitter",
					"regex",
				},
				delay = 10,
				filetype_overrides = {},
				filetypes_denylist = {
					"dirvish",
					"fugitive",
				},
				under_cursor = true,
			})
		end,
	},

	{
		"Bekaboo/dropbar.nvim",
		dependencies = {
			"ibhagwan/fzf-lua", -- fzf-lua for the picker
		},
		opts = false, -- ❗ prevent auto-setup
		config = function()
			local dropbar_enabled = true

			-- fzf-lua picker implementation
			local function fzf_picker(items, opts)
				local fzf = require("fzf-lua")
				fzf.fzf_exec(
					vim.tbl_map(function(item)
						return item.name
					end, items),
					{
						prompt = "Dropbar> ",
						actions = {
							["default"] = function(selected)
								local idx
								for i, item in ipairs(items) do
									if item.name == selected[1] then
										idx = i
										break
									end
								end
								if idx then
									opts.on_choice(items[idx], idx)
								end
							end,
						},
					}
				)
			end

			-- Toggle Dropbar
			vim.keymap.set("n", "<leader>tb", function()
				if dropbar_enabled then
					vim.opt.winbar = nil
					dropbar_enabled = false
					print("Dropbar: hidden")
				else
					require("dropbar").setup({
						bar = {
							pick = { picker = fzf_picker },
						},
					})
					dropbar_enabled = true
					print("Dropbar: shown")
				end
			end, { desc = "Toggle Dropbar" })

			-- Shortcut to pick symbols (works only if Dropbar is enabled)
			vim.keymap.set("n", "<leader>ls", function()
				if dropbar_enabled then
					require("dropbar.api").pick()
				else
					print("Dropbar is disabled — press <leader>tb to enable it.")
				end
			end, { desc = "[s]ymbols" })

			-- Start with winbar off
			vim.opt.winbar = nil
		end,
	},

	{ -- highlight markdown headings and code blocks etc.
		"MeanderingProgrammer/render-markdown.nvim",
		enabled = true,
		ft = { "quarto", "markdown" },
		-- ft = { "markdown" },
		-- dependencies = { 'nvim-treesitter/nvim-treesitter' },
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			render_modes = { "n", "c", "t" },
			completions = {
				lsp = { enabled = false },
			},
			heading = {
				enabled = false,
			},
			paragraph = {
				enabled = false,
			},
			code = {
				enabled = true,
				style = "full",
				border = "thin",
				sign = false,
				render_modes = { "i", "v", "V" },
			},
			signs = {
				enabled = false,
			},
		},
	},
}
