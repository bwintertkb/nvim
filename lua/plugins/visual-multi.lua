return {
  {
    "mg979/vim-visual-multi",
    branch = "master",
    lazy = false, -- Must load immediately to set up keymaps
    init = function()
      -- Optional: Custom settings or keymaps
      -- By default, it uses <C-n> to select the word under cursor
      vim.g.VM_theme = 'ocean' 
    end,
  },
}
