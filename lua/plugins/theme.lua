return {
  {
    "bwintertkb/no-clown-fiesta.nvim",
    -- dir = "/home/bwintertkb/tp/no-clown-fiesta.nvim", -- REMOVED THIS LINE
    lazy = false,
    priority = 1000,
    config = function()
      local plugin = require("no-clown-fiesta")
      local plain = { bold = false, italic = false }

      plugin.setup({
        theme = "dim", 
        transparent = false, 
        styles = {
          comments = plain,
          functions = plain,
          keywords = plain,
          lsp = plain,
          match_paren = plain,
          type = plain,
          variables = plain,
        },
      })

      plugin.load()
      
      -- (Keep your style overrides here if you still want them)
      local groups = vim.fn.getcompletion("", "highlight")
      for _, group in ipairs(groups) do
        local hl = vim.api.nvim_get_hl(0, { name = group })
        if hl.bold or hl.italic then
          hl.bold = false
          hl.italic = false
          vim.api.nvim_set_hl(0, group, hl)
        end
      end
    end,
  },
}
