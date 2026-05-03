return {
  -- Diffview: side-by-side diff (dùng làm dependency cho Neogit, vẫn gọi được trực tiếp)
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
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

  -- Neogit: UI git giống VS Code Source Control
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>DiffviewOpen<cr>",                 desc = "Git: 3-panel diff (files | original | change)" },
      { "<leader>gG", "<cmd>DiffviewClose<cr>",                desc = "Git: close diff" },
      { "<leader>gs", "<cmd>Neogit<cr>",                       desc = "Neogit: status (stage/commit)" },
      { "<leader>gc", "<cmd>Neogit commit<cr>",                desc = "Neogit: commit" },
      { "<leader>gp", "<cmd>Neogit pull<cr>",                  desc = "Neogit: pull" },
      { "<leader>gP", "<cmd>Neogit push<cr>",                  desc = "Neogit: push" },
      { "<leader>gl", "<cmd>Neogit log<cr>",                   desc = "Neogit: log" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>",        desc = "Diffview: file history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>",          desc = "Diffview: branch history" },
    },
    opts = {
      integrations = {
        diffview = true,
        telescope = true,
      },
      graph_style = "unicode",
      kind = "tab",
      commit_editor = { kind = "tab" },
      popup = { kind = "split" },
      signs = {
        hunk = { "", "" },
        item = { "", "" },
        section = { "", "" },
      },
      disable_commit_confirmation = false,
      disable_insert_on_commit = "auto",
    },
  },
}
