return {
  "ray-x/go.nvim",
  dependencies = {  -- go.nvim requires these to function correctly
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("go").setup()

    -- Format on save (Autocmd moved here)
    local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        require('go.format').goimport()
      end,
      group = format_sync_grp,
    })
  end,
  event = { "CmdlineEnter" }, -- Load when you start typing a command
  ft = { "go", 'gomod' },     -- Load when opening a go file
  build = ':lua require("go.install").update_all_sync()' -- Auto-install binaries
}
