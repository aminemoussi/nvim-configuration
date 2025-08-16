return { -- paste an image from the clipboard or drag-and-drop
	"HakonHarnes/img-clip.nvim",
	event = "BufEnter",
	ft = { "markdown", "quarto", "latex" },
	opts = {
		default = {
			dir_path = "img",
		},
		filetypes = {
			quarto = {
				url_encode_path = true,
				template = "![$CURSOR]($FILE_PATH)",
				dir_path = function()
					return vim.fn.expand("%:p:h") .. "/img" -- Creates img/ in same directory as current file
				end,
				drag_and_drop = {
					download_images = false,
				},
			},
			markdown = {
				url_encode_path = true,
				template = "![$CURSOR]($FILE_PATH)",
				dir_path = function()
					return vim.fn.expand("%:p:h") .. "/img" -- Creates img/ in same directory as current file
				end,
				drag_and_drop = {
					download_images = false,
				},
			},
		},
	},
	config = function(_, opts)
		require("img-clip").setup(opts)
		vim.keymap.set("n", "<leader>ii", ":PasteImage<cr>", { desc = "insert [i]mage from clipboard" })
	end,
}
