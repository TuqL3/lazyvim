local header_color = "#8be9fd" -- cyan

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "LukasHeader", { fg = header_color, bold = true })
  end,
})
vim.api.nvim_set_hl(0, "LukasHeader", { fg = header_color, bold = true })

local lines = {
  "██╗     ██╗   ██╗██╗  ██╗ █████╗ ███████╗",
  "██║     ██║   ██║██║ ██╔╝██╔══██╗██╔════╝",
  "██║     ██║   ██║█████╔╝ ███████║███████╗",
  "██║     ██║   ██║██╔═██╗ ██╔══██║╚════██║",
  "███████╗╚██████╔╝██║  ██╗██║  ██║███████║",
  "╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝",
}

local header_text = {}
for _, line in ipairs(lines) do
  table.insert(header_text, { line .. "\n", hl = "LukasHeader" })
end

local quotes = {
  "  Stay hungry, stay foolish.  - Steve Jobs",
  "  First, solve the problem. Then, write the code.",
  "  Talk is cheap. Show me the code.  - Linus Torvalds",
  "  Make it work, make it right, make it fast.",
  "  Simplicity is the ultimate sophistication.",
  "  Programs must be written for people to read.",
  "  The best way to predict the future is to invent it.",
  "  Code never lies, comments sometimes do.",
  "  It always seems impossible until it's done.",
  "  Premature optimization is the root of all evil.",
}
math.randomseed(os.time())
local quote = quotes[math.random(#quotes)]

return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      sections = {
        { text = header_text, align = "center", padding = 1 },
        { section = "recent_files", title = "  Recent Files", icon = " ", padding = 1, limit = 5 },
        { section = "projects", title = "  Projects", icon = " ", padding = 1, limit = 5 },
        { section = "startup" },
        {
          text = { { quote, hl = "SnacksDashboardSpecial" } },
          align = "center",
          padding = 1,
        },
      },
    },
  },
}
