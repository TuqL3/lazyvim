-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Ép tất cả terminal dùng zsh
vim.o.shell = "/bin/zsh"

local zsh = "/bin/zsh"

-- 3 terminal float riêng biệt (zsh) — to ~85% màn hình
local float_win = { position = "float", width = 0.85, height = 0.85, border = "rounded" }
map("n", "<leader>t1", function() Snacks.terminal.toggle(zsh, { win = float_win, env = { id = "1" } }) end, { desc = "Terminal 1" })
map("n", "<leader>t2", function() Snacks.terminal.toggle(zsh, { win = float_win, env = { id = "2" } }) end, { desc = "Terminal 2" })
map("n", "<leader>t3", function() Snacks.terminal.toggle(zsh, { win = float_win, env = { id = "3" } }) end, { desc = "Terminal 3" })

-- Terminal toggle: bấm lần nữa để ẩn
map("n", "<leader>th", function()
  Snacks.terminal.toggle(zsh, { win = { position = "bottom", height = 0.4 }, env = { id = "hsplit" } })
end, { desc = "Terminal horizontal (toggle)" })

map("n", "<leader>tv", function()
  Snacks.terminal.toggle(zsh, { win = { position = "right", width = 0.5 }, env = { id = "vsplit" } })
end, { desc = "Terminal vertical (toggle)" })

-- Thoát insert mode trong terminal nhanh hơn (Esc thay vì Ctrl-\ Ctrl-n)
map("t", "<esc><esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Smart gd: dùng LSP nếu đã ready, nếu chưa thì fallback sang grep word dưới cursor
map("n", "gd", function()
  local clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/definition" })
  local ready = false
  for _, c in ipairs(clients) do
    if not c.initializing then ready = true break end
  end
  if ready then
    vim.lsp.buf.definition()
  else
    local word = vim.fn.expand("<cword>")
    if word == "" then return end
    if pcall(require, "snacks") and Snacks and Snacks.picker then
      Snacks.picker.grep_word({ search = word })
    else
      vim.cmd("silent grep! " .. vim.fn.shellescape(word) .. " | copen")
    end
  end
end, { desc = "Goto definition (LSP or grep fallback)" })

-- Git hunk: discard / preview / nhảy hunk
map({ "n", "v" }, "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Discard hunk (reset)" })
map("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<cr>", { desc = "Discard cả file" })
map("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview hunk" })
map("n", "]h", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next hunk" })
map("n", "[h", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Prev hunk" })

