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
        -- ẩn gợi ý Codeium khi popup completion (blink/nvim-cmp) đang mở
        filter = function()
          local ok_blink, blink = pcall(require, "blink.cmp")
          if ok_blink and blink.is_visible and blink.is_visible() then
            return false
          end
          local ok_cmp, cmp = pcall(require, "cmp")
          if ok_cmp and cmp.visible() then
            return false
          end
          return true
        end,
      })

      local map = vim.keymap.set
      map("i", "<C-f>", function() neocodeium.accept() end, { desc = "Codeium: accept" })
      map("i", "<C-y>", function() neocodeium.accept_word() end, { desc = "Codeium: accept word" })
      map("i", "<C-l>", function() neocodeium.accept_line() end, { desc = "Codeium: accept line" })
      map("i", "<C-]>", function() neocodeium.cycle_or_complete() end, { desc = "Codeium: next" })
      map("i", "<C-b>", function() neocodeium.cycle_or_complete(-1) end, { desc = "Codeium: prev" })
      map("i", "<C-q>", function() neocodeium.clear() end, { desc = "Codeium: dismiss" })
    end,
  },
}
