return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	-- dependencies = { "nvim-tree/nvim-web-devicons" },
	-- or if using mini.icons/mini.nvim
	dependencies = { "echasnovski/mini.icons" },
	config = function()
		require("fzf-lua").setup({
			-- Configure buffer display options
			buffers = {
				prompt = "Buffers❯ ",
				file_icons = true,
				color_icons = true,
				sort_lastused = true,
				show_all_buffers = true,
				ignore_current_buffer = false,
				cwd_only = false,
				actions = {
					["default"] = require("fzf-lua").actions.buf_edit,
					["ctrl-s"] = require("fzf-lua").actions.buf_split,
					["ctrl-v"] = require("fzf-lua").actions.buf_vsplit,
					["ctrl-t"] = require("fzf-lua").actions.buf_tabedit,
					["ctrl-d"] = require("fzf-lua").actions.buf_del,
				},
			},
		})
	end,
	keys = {
		{
			"<leader>ff",
			function()
				require("fzf-lua").files()
			end,
			desc = "Find files in current directory",
		},
		{
			"<leader>fg",
			function()
				require("fzf-lua").live_grep()
			end,
			desc = "Find by grepping current dir",
		},
		{
			"<leader>fc",
			function()
				require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Find in nvim conf dir",
		},
		{
			"<leader>fb",
			function()
				require("fzf-lua").builtin()
			end,
			desc = "Find built in fuzzy finders list",
		},
		{
			"<leader>fk",
			function()
				require("fzf-lua").keymaps()
			end,
			desc = "Find keymaps",
		},
		{
			"<leader>fw",
			function()
				require("fzf-lua").grep_cword()
			end,
			desc = "Find a word, like grep but u could look inside a specific file/dir",
		},
		{
			"<leader>fd",
			function()
				require("fzf-lua").diagnostics_document()
			end,
			desc = "Find diagnostic doc",
		},
		{
			"<leader>fr",
			function()
				require("fzf-lua").resume()
			end,
			desc = "Find resume from last search",
		},
		{
			"<leader>fh",
			function()
				require("fzf-lua").helptags()
			end,
			desc = "Nvim help menu",
		},
		-- Enhanced buffer navigation
		{
			"<leader>bh",
			function()
				require("fzf-lua").buffers({
					query = "term://",
					prompt = "Hidden Buffers❯ ",
				})
			end,
			desc = "Show hidden/terminal buffers",
		},
		{
			"<leader><leader>",
			function()
				require("fzf-lua").buffers({
					show_all_buffers = true,
					include_current_buffer = true,
					prompt = "All Buffers (terminals highlighted)❯ ",
					-- This will show all buffers but you can easily spot terminals by their name
				})
			end,
			desc = "Show ALL buffers (terminals highlighted)",
		},
		-- Quick buffer switching
		{
			"<leader>/",
			function()
				require("fzf-lua").lgrep_curbuf()
			end,
			desc = "Search something in current file",
		},
	},
}
