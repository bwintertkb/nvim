return {
  -- Conoline (Cursor Line Highlight)
  {
    "miyakogi/conoline.vim",
    config = function()
      -- Vimscript "let g:..." becomes "vim.g..." in Lua
      vim.g.conoline_auto_enable = 1
      vim.g.conoline_color_normal_dark = 'guibg=#1a1e22'
      vim.g.conoline_color_normal_nr_dark = 'guibg=#1a1e22'
      vim.g.conoline_color_insert_dark = 'guibg=#1c2024'
      vim.g.conoline_color_insert_nr_dark = 'guibg=#1c2024'
    end
  },

  -- Fidget (LSP Progress notification)
  {
    "j-hui/fidget.nvim",
    opts = {} -- setup()
  }
}
