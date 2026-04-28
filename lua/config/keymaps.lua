-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- 3 terminal float riêng biệt
map("n", "<leader>t1", function() Snacks.terminal.toggle("bash", { win = { position = "float" }, env = { id = "1" } }) end, { desc = "Terminal 1" })
map("n", "<leader>t2", function() Snacks.terminal.toggle("bash", { win = { position = "float" }, env = { id = "2" } }) end, { desc = "Terminal 2" })
map("n", "<leader>t3", function() Snacks.terminal.toggle("bash", { win = { position = "float" }, env = { id = "3" } }) end, { desc = "Terminal 3" })

-- Terminal split (toggle: bấm lần nữa để ẩn)
map("n", "<leader>tv", function() Snacks.terminal.toggle("bash", { win = { position = "right" } }) end, { desc = "Terminal vertical (toggle)" })
map("n", "<leader>th", function() Snacks.terminal.toggle("bash", { win = { position = "bottom" } }) end, { desc = "Terminal horizontal (toggle)" })

-- Thoát insert mode trong terminal nhanh hơn (Esc thay vì Ctrl-\ Ctrl-n)
map("t", "<esc><esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
