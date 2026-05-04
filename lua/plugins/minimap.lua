return {
  {
    "nvim-mini/mini.map",
    version = false,
    event = "VeryLazy",
    keys = {
      { "<leader>um", function() require("mini.map").toggle() end, desc = "Minimap: toggle" },
      { "<leader>uM", function() require("mini.map").toggle_focus() end, desc = "Minimap: toggle focus" },
    },
    config = function()
      local map = require("mini.map")
      map.setup({
        integrations = {
          map.gen_integration.builtin_search(),
          map.gen_integration.diagnostic({
            error = "DiagnosticFloatingError",
            warn  = "DiagnosticFloatingWarn",
            info  = "DiagnosticFloatingInfo",
            hint  = "DiagnosticFloatingHint",
          }),
          map.gen_integration.gitsigns(),
        },
        symbols = {
          encode = map.gen_encode_symbols.dot("4x2"),
          scroll_line = "█",
          scroll_view = "┃",
        },
        window = {
          side = "right",
          width = 12,
          winblend = 25,
          show_integration_count = false,
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "neo-tree", "snacks_dashboard", "alpha", "dashboard",
          "lazy", "mason", "TelescopePrompt", "help", "Trouble",
          "NeogitStatus", "NeogitPopup", "DiffviewFiles",
        },
        callback = function() vim.b.minimap_disable = true end,
      })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        callback = function()
          if vim.b.minimap_disable then
            map.close()
          end
        end,
      })
    end,
  },
}
