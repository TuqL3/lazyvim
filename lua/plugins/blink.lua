-- Override keymap của blink.cmp:
-- Dùng Tab/Shift-Tab để di chuyển trong menu completion (thay cho Ctrl-n/Ctrl-p)
return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
      },
    },
  },
}
