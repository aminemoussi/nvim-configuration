return {

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
}
