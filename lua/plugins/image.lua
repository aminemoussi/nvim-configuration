return {
	"3rd/image.nvim",
	lazy = true,
	opts = {
		max_height_window_percentage = 50,
		hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
	},
	config = function()
		require("image").setup({
			backend = "kitty", -- or "ueberzug" or "sixel"
		})
	end,
}
