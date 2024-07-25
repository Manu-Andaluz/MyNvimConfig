-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

vim.opt.scrolloff = 999

vim.opt.winblend = 0
vim.opt.pumblend = 0
vim.opt.termguicolors = true

vim.opt.cursorline = true
vim.opt.cursorlineopt = "both"
