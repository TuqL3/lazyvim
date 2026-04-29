-- Cheatsheet float tự bật khi file có conflict, tự tắt khi resolve xong
local hint_state = { win = nil, buf = nil, tracked = {} }

local function close_hint()
  if hint_state.win and vim.api.nvim_win_is_valid(hint_state.win) then
    pcall(vim.api.nvim_win_close, hint_state.win, true)
  end
  if hint_state.buf and vim.api.nvim_buf_is_valid(hint_state.buf) then
    pcall(vim.api.nvim_buf_delete, hint_state.buf, { force = true })
  end
  hint_state.win, hint_state.buf = nil, nil
end

local function open_hint()
  if hint_state.win and vim.api.nvim_win_is_valid(hint_state.win) then return end

  local lines = {
    "  Conflict resolution  ",
    "                        ",
    "  co   choose Ours      ",
    "  ct   choose Theirs    ",
    "  cb   choose Both      ",
    "  c0   choose None      ",
    "                        ",
    "  ]x   next conflict    ",
    "  [x   prev conflict    ",
    "                        ",
    "  <leader>gd  Diffview  ",
    "  q  close this hint    ",
  }

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"

  local width, height = 26, #lines
  local win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    width = width,
    height = height,
    row = vim.o.lines - height - 4,
    col = vim.o.columns - width - 2,
    style = "minimal",
    border = "rounded",
    focusable = false,
    zindex = 50,
    noautocmd = true,
  })
  vim.wo[win].winhl = "Normal:NormalFloat,FloatBorder:DiagnosticWarn"
  vim.wo[win].winblend = 10

  -- highlight các phím
  local ns = vim.api.nvim_create_namespace("conflict_hint")
  for i, line in ipairs(lines) do
    local s, e = line:find("%S+%s+%S+")
    if s and i > 1 then
      vim.api.nvim_buf_add_highlight(buf, ns, "Special", i - 1, 0, 6)
    end
  end
  vim.api.nvim_buf_add_highlight(buf, ns, "Title", 0, 0, -1)

  hint_state.win, hint_state.buf = win, buf

  -- bấm q ở cửa sổ chính cũng đóng hint
  vim.keymap.set("n", "<leader>cq", close_hint, { desc = "Close conflict hint", silent = true })
end

-- Bật/tắt theo event của git-conflict.nvim
local group = vim.api.nvim_create_augroup("ConflictHint", { clear = true })

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "GitConflictDetected",
  callback = function(args)
    hint_state.tracked[args.buf] = true
    if vim.api.nvim_get_current_buf() == args.buf then
      open_hint()
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "GitConflictResolved",
  callback = function(args)
    hint_state.tracked[args.buf] = nil
    if vim.tbl_isempty(hint_state.tracked) then
      close_hint()
    end
  end,
})

-- Khi chuyển buffer: nếu buffer mới có conflict thì show, không thì ẩn
vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = function(args)
    if hint_state.tracked[args.buf] then
      open_hint()
    else
      close_hint()
    end
  end,
})

return {
  -- Resolve conflict markers ngay trong file: co/ct/cb/c0 + ]x/[x
  {
    "akinsho/git-conflict.nvim",
    event = "BufReadPre",
    version = "*",
    opts = {
      default_mappings = true,
      default_commands = true,
      disable_diagnostics = true,
      list_opener = "copen",
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    },
  },

  -- 3-way merge view: ours | result | theirs
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: open" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview: close" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: file history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: branch history" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        merge_tool = {
          layout = "diff3_mixed",
          disable_diagnostics = true,
        },
      },
    },
  },

  -- Đăng ký với which-key: bấm `c` ở normal mode, sau ~200ms hiện co/ct/cb/c0
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "co", desc = "Conflict: choose Ours" },
        { "ct", desc = "Conflict: choose Theirs" },
        { "cb", desc = "Conflict: choose Both" },
        { "c0", desc = "Conflict: choose None" },
        { "]x", desc = "Conflict: next" },
        { "[x", desc = "Conflict: prev" },
      },
    },
  },
}
