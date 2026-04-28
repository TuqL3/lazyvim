return {
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = false,
      format_after_save = false,
    },
  },
  -- Tắt LSP format on save mặc định của LazyVim
  {
    "LazyVim/LazyVim",
    opts = {
      autoformat = false,
    },
  },
}
