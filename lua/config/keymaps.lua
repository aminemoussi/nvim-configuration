vim.keymap.set({"n"}, "<leader>-", "<cmd>Oil --float<CR>")  --might wanna exclude/include insert mode


vim.keymap.set({"n"}, "gl", function() vim.diagnostic.open_float() end, {desc = "Open diagnostics in a float"})

vim.keymap.set({"n"}, "<leader>cf", function() require('conform').format() end, {desc = "Reformat code"})


vim.keymap.set({"n"}, "<leader>w", "<cmd>:w<CR>")


vim.keymap.set({"n"}, "<leader>q", "<cmd>:q<CR>")

vim.keymap.set({"n", "v"}, "<leader>ri", ":normal gg=G<CR>")    --line reindentation


-- yank to clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
