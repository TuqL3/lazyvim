-- AI completion miễn phí dùng Codeium (qua neocodeium - async, nhanh hơn codeium.nvim chính thức)
-- Lần đầu chạy: mở Neovim, gõ `:NeoCodeium auth` để lấy token (login qua trình duyệt)
return {
  {
    "monkoose/neocodeium",
    event = "InsertEnter",
    config = function()
      local neocodeium = require("neocodeium")
      neocodeium.setup({
        manual = false, -- false = tự động gợi ý; true = chỉ khi gọi tay
        silent = true,
        -- ẩn gợi ý Codeium khi popup completion (nvim-cmp/blink) đang mở
        filter = function()
          local ok, cmp = pcall(require, "cmp")
          if ok and cmp.visible() then
            return false
          end
          return true
        end,
      })

      local map = vim.keymap.set
      map("i", "<A-f>", function() neocodeium.accept() end, { desc = "Codeium: accept" })
      map("i", "<A-w>", function() neocodeium.accept_word() end, { desc = "Codeium: accept word" })
      map("i", "<A-l>", function() neocodeium.accept_line() end, { desc = "Codeium: accept line" })
      map("i", "<A-]>", function() neocodeium.cycle_or_complete() end, { desc = "Codeium: next" })
      map("i", "<A-[>", function() neocodeium.cycle_or_complete(-1) end, { desc = "Codeium: prev" })
      map("i", "<A-c>", function() neocodeium.clear() end, { desc = "Codeium: dismiss" })
    end,
  },
}
