return {
	{
		"saghen/blink.compat",
		version = "*",
		lazy = true,
		opts = {},
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"ray-x/cmp-sql",
			-- "hrsh7th/cmp-path", -- Optional: blink.cmp has built-in path completion
		},
		version = "1.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "super-tab",
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {

				menu = {
					border = "rounded",
				},

				ghost_text = {
					enabled = true,
					show_without_menu = true,
				},

				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
				},
			}
,
			signature = { enabled = true },
			sources = {
				-- Use built-in path completion (simpler) or add cmp_path for extended features
				default = { "lsp", "path", "snippets", "buffer", "sql" },
				providers = {
					sql = {
						name = "sql",
						module = "blink.compat.source",
						score_offset = -3,
						opts = {},
						should_show_items = function()
							return vim.tbl_contains({ "sql" }, vim.o.filetype)
						end,
					},
					-- Uncomment below if you want to use cmp-path instead of built-in path
					-- cmp_path = {
					-- 	name = "path",
					-- 	module = "blink.compat.source",
					-- 	score_offset = 15,
					-- 	opts = {
					-- 		trailing_slash = true,
					-- 		label_trailing_slash = true,
					-- 	},
					-- 	should_show_items = function()
					-- 		return true
					-- 	end,
					-- },
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
			opts_extend = { "sources.default" },
		},
	},
}
