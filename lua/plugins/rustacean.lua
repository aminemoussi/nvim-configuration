return {
	"mrcjkb/rustaceanvim",
	ft = "rust",
	version = "^4",
	config = function()
		vim.g.rustaceanvim = {
			tools = {
				autoSetHints = true,
				hover_with_actions = true,
			},
		}
	end,
}
