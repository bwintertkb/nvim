return {
  -- 1. Disable the default Lualine
  { "nvim-lualine/lualine.nvim", enabled = false },

  -- 2. Install Vim-Airline and its themes
  {
    "vim-airline/vim-airline",
    dependencies = { "vim-airline/vim-airline-themes" },
    lazy = false, -- Load immediately
    config = function()
      vim.g.airline_theme = "dark" -- or 'solarized', 'badwolf', etc.
      vim.g.airline_powerline_fonts = 1 -- if you have patched fonts
      
      -- Enable tabline (top bar) if you want it
      -- vim.g['airline#extensions#tabline#enabled'] = 1
    end,
  },
}
