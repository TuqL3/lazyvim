-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("StdinReadPre", {
  group = vim.api.nvim_create_augroup("auto_restore_session_stdin", { clear = true }),
  callback = function()
    vim.g.started_with_stdin = true
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("auto_restore_session", { clear = true }),
  nested = true,
  callback = function()
    if vim.fn.argc() > 0 or vim.g.started_with_stdin then
      return
    end
    require("persistence").load()
  end,
})

