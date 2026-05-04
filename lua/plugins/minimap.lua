return {
  {
    "nvim-mini/mini.map",
    version = false,
    event = { "BufReadPost", "BufNewFile" },
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
          encode = map.gen_encode_symbols.block("3x2"),
          scroll_line = "▌",
          scroll_view = "│",
        },
        window = {
          side = "right",
          width = 10,
          winblend = 15,
          show_integration_count = false,
          zindex = 10,
        },
      })

      vim.api.nvim_set_hl(0, "MiniMapNormal",       { link = "NormalFloat" })
      vim.api.nvim_set_hl(0, "MiniMapSymbolView",   { fg = "#7aa2f7", bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniMapSymbolLine",   { fg = "#bb9af7", bg = "NONE", bold = true })
      vim.api.nvim_set_hl(0, "MiniMapSymbolCount",  { fg = "#565f89", bg = "NONE" })

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
          else
            map.open()
          end
        end,
      })

      map.open()
    end,
  },
}
