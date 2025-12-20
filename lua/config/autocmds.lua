-- ~/.config/nvim/lua/config/autocmds.lua

local function set_inlay_hints()
  -- Use a noticeably lighter grey. 
  -- #C0C0C0 is Silver/Light Grey. 
  -- #909090 is Medium Grey.
  vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#808080", bg = "NONE" })
end

-- 1. Apply the color IMMEDIATELY (Fixes the startup issue)
set_inlay_hints()

-- 2. Apply the color whenever the colorscheme changes (Fixes theme switching)
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = set_inlay_hints,
})

-- Force enable Inlay Hints whenever an LSP attaches to a buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    
    -- Only enable if the server (like rust_analyzer) actually supports hints
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = "*.rs",
  callback = function()
    -- "Brute Force" enable: turning it on for the current buffer
    -- This runs every time you switch to a Rust window.
    vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
  end,
})

-- Force-enable hints on every text change in Normal and Insert mode
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  pattern = "*.rs",
  callback = function()
    -- We use pcall to safely ignore errors if the LSP isn't ready yet
    pcall(vim.lsp.inlay_hint.enable, true, { bufnr = 0 })
  end,
})
