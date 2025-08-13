return {
	-- git and projects
	-- { 'ThePrimeagen/git-worktree.nvim' },
	-- { 'sindrets/diffview.nvim' },
	{
		"TimUntersberger/neogit",
		lazy = true,
		cmd = "Neogit",
		keys = {
			{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit" },
			{ "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Git commit" },
		},
		config = function()
			require("neogit").setup({
				disable_commit_confirmation = true,
				integrations = {
					diffview = true,
				},
			})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			-- Navigate hunks
			{ "]h", "<cmd>Gitsigns next_hunk<cr>", desc = "Next hunk" },
			{ "[h", "<cmd>Gitsigns prev_hunk<cr>", desc = "Previous hunk" },

			-- Basic actions
			{ "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage hunk" },
			{ "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset hunk" },
			{ "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview hunk" },
			{ "<leader>hS", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage entire file" },
		},
		config = function()
			require("gitsigns").setup({})
		end,
	},
	{
		"akinsho/git-conflict.nvim",
		event = "BufReadPre",
		keys = {
			{ "<leader>co", "<cmd>GitConflictChooseOurs<cr>", desc = "Choose ours" },
			{ "<leader>ct", "<cmd>GitConflictChooseTheirs<cr>", desc = "Choose theirs" },
		},
		config = function()
			require("git-conflict").setup({
				default_mappings = true,
				disable_diagnostics = true,
			})
		end,
	},
	{
		"f-person/git-blame.nvim",
		keys = {
			{ "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Toggle git blame" },
		},
	},

	-- Basic git add/commit commands
	{
		"nvim-lua/plenary.nvim", -- Already included in most setups
		keys = {
			{ "<leader>ga", "<cmd>!git add %<cr>", desc = "Git add current file" },
			{ "<leader>gA", "<cmd>!git add .<cr>", desc = "Git add all files" },
			{ "<leader>gp", "<cmd>!git push<cr>", desc = "Git push" },
		},
	},

	-- github PRs and the like with gh-cli
	-- { 'pwntester/octo.nvim', config = function()
	--   require "octo".setup()
	-- end },
}
