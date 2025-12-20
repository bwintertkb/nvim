return {
  'nvim-telescope/telescope.nvim',
  -- branch = '0.1.x', -- Keep this commented out (use master branch)
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = "Telescope",
  keys = {
    { "<Tab>", "<cmd>Telescope oldfiles<cr>" },
    { "gr", "<cmd>Telescope lsp_references<cr>" },
    { "<C-p>", "<cmd>Telescope find_files<cr>" },
    { "<C-u>", "<cmd>Telescope live_grep<cr>" },
    { "<C-]>", "<cmd>Telescope lsp_definitions<cr>" },
  },
  opts = {
    extensions = {
      aerial = {
        show_nesting = { ['_'] = false, json = true, yaml = true }
      }
    },
    defaults = {
      vimgrep_arguments = {
        'rg', '--color=never', '--no-heading', '--with-filename',
        '--line-number', '--column', '--smart-case'
      },
      mappings = {},
      
      -- !!! ADD THIS SECTION !!!
      -- This stops the crash by using standard vim syntax instead of treesitter
      preview = {
        treesitter = false,
      },
    }
  }
}
