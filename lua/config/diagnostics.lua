-- =========================================
-- 3. DIAGNOSTICS CONFIG (Unchanged)
-- =========================================
vim.diagnostic.config({
  virtual_text = {
    source = "if_many",
    prefix = '●',
    spacing = 4,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
