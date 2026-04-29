-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Tắt format on save mặc định của LazyVim
vim.g.autoformat = false
-- Tắt ESLint auto-fix on save (LazyVim's eslint extras)
vim.g.lazyvim_eslint_auto_format = false

-- Giảm I/O cho tsserver trên project lớn / WSL
vim.opt.updatetime = 1000
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
