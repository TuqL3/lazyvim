return {
  "akinsho/git-conflict.nvim",
  version = "*",
  event = "BufReadPre",
  config = function()
    require("git-conflict").setup({
      default_mappings = true,
      default_commands = true,
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    })
  end,
}
