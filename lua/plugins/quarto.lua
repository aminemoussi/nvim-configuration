return {
	{
		"quarto-dev/quarto-nvim",
		dependencies = {
			"jmbuhr/otter.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("quarto").setup({
				lspFeatures = {
					enabled = true,
					languages = { "python", "julia", "rust", "c", "cpp" },
					diagnostics = {
						enabled = true,
						triggers = { "BufWrite" },
					},
					completion = {
						enabled = true,
					},
				},
			})
		end,
	},
	-- send code from python/r/qmd documents to a terminal
	-- like ipython, R, bash
	{ "jpalardy/vim-slime" },
}
