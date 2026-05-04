-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Ép tất cả terminal dùng Git Bash — tìm bash.exe ở các vị trí thường gặp
local function find_git_bash()
  local candidates = {
    "C:\\Program Files\\Git\\bin\\bash.exe",
    "C:\\Program Files (x86)\\Git\\bin\\bash.exe",
    vim.env.LOCALAPPDATA and (vim.env.LOCALAPPDATA .. "\\Programs\\Git\\bin\\bash.exe") or nil,
    vim.env.USERPROFILE and (vim.env.USERPROFILE .. "\\scoop\\apps\\git\\current\\bin\\bash.exe") or nil,
    "C:\\msys64\\usr\\bin\\bash.exe",
  }
  for _, p in ipairs(candidates) do
    if p and vim.fn.filereadable(p) == 1 then return p end
  end
  local ep = vim.fn.exepath("bash")
  if ep ~= "" then return ep end
  return "bash"
end

local bash = find_git_bash()
vim.o.shell = bash
vim.o.shellcmdflag = "-s"
vim.o.shellxquote = ""
vim.o.shellquote = ""
vim.o.shellredir = ">%s 2>&1"
vim.o.shellpipe = "2>&1| tee"

-- Terminal: 2 layout chính + tạo/switch nhiều terminal
local float_win = { position = "float", width = 0.85, height = 0.85, border = "rounded" }
local split_win = { position = "bottom", height = 0.4 }

local term_counter = 0
local function new_terminal()
  term_counter = term_counter + 1
  Snacks.terminal.toggle({ bash, "-i", "-l" }, { win = split_win, env = { id = "term" .. term_counter } })
end

local function list_terminals()
  local terms = Snacks.terminal.list()
  if #terms == 0 then return vim.notify("No terminals open", vim.log.levels.INFO) end
  vim.ui.select(terms, {
    prompt = "Switch terminal:",
    format_item = function(t)
      local name = vim.api.nvim_buf_get_name(t.buf)
      local id = (t.opts and t.opts.env and t.opts.env.id) or "?"
      return ("[%s] %s"):format(id, name)
    end,
  }, function(choice)
    if not choice then return end
    for _, t in ipairs(terms) do
      if t ~= choice and t:win_valid() then t:hide() end
    end
    choice:show():focus()
  end)
end

-- Toggle terminal split (dưới) — dùng được ở normal/insert/terminal mode
map({ "n", "i", "t" }, "<C-_>", function()
  Snacks.terminal.toggle({ bash, "-i", "-l" }, { win = split_win, env = { id = "main" } })
end, { desc = "Toggle terminal (split)" })

-- Toggle terminal float — dùng được ở normal/insert/terminal mode
map({ "n", "i", "t" }, "<C-\\>", function()
  Snacks.terminal.toggle({ bash, "-i", "-l" }, { win = float_win, env = { id = "float" } })
end, { desc = "Toggle terminal (float)" })

map("n", "<leader>tn", new_terminal, { desc = "New terminal" })
map("n", "<leader>tl", list_terminals, { desc = "List terminals" })

-- Esc 1 lần để thoát insert mode trong terminal
map("t", "<esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

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

