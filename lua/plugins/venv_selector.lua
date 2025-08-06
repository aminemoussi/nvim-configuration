return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"mfussenegger/nvim-dap",
	},
	lazy = false,
	--branch = "regexp", -- Ensure you are on the correct branch
	config = function()
		require("venv-selector").setup({
			fd_binary_name = "fd", -- now installed
			name = ".venv",
			auto_refresh = true,
			parents = {
				--"~/PycharmProjects", -- project-based venvs
				"~/anaconda3/envs", -- conda envs
				--"~/.virtualenvs", -- standard virtualenvwrapper
			},
		})
	end,
	keys = {
		{ "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select Python Environment" },
	},
}
