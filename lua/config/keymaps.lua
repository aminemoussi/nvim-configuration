vim.keymap.set({"n"}, "<leader>-", "<cmd>Oil --float<CR>")  --might wanna exclude/include insert mode

vim.keymap.set({"n"}, "<leader>w", "<cmd>:w<CR>")


vim.keymap.set({"n"}, "<leader>q", "<cmd>:q<CR>")

vim.keymap.set({"n", "v"}, "<leader>ri", ":normal gg=G<CR>")    --line reindentation


-- yank to clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
