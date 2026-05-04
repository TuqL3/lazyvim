-- Chỉ mở 1 file duy nhất, tắt multi-select hoàn toàn
return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        keys = {
          -- Tắt Tab và các phím có thể chọn nhiều file
          ["<Tab>"] = false,
          ["<S-Tab>"] = false,
        },
        actions = {
          -- Đảm bảo confirm chỉ mở file đang chọn, không mở tất cả file đã chọn
          confirm = function(self)
            local item = self:current()
            if not item then return end
            self:close()
            local file = item.file or (item[1] and item[1].file) or item[1] or ""
            if file ~= "" then
              vim.cmd("edit " .. vim.fn.fnameescape(file))
            end
          end,
        },
      },
    },
  },
}
