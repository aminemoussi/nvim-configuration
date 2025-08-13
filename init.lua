require("config.lazy")
require("config.keymaps")
require("config.options")

-- Fix terminal key codes
vim.opt.termguicolors = true
vim.opt.ttimeoutlen = 0
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- Ensure proper key code recognition
if vim.fn.has("termguicolors") == 1 then
	vim.opt.termguicolors = true
end

--vim.opt.autochdir = true
