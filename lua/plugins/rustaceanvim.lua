return {
  "mrcjkb/rustaceanvim",
  version = "^5", -- Recommended
  lazy = false,   -- This plugin is already lazy-loaded by filetype (ft=rust) automatically
  
  config = function()
    -- We need to define 'caps' here so Blink can talk to rust-analyzer
    local caps = require('blink.cmp').get_lsp_capabilities()

    vim.g.rustaceanvim = {
      tools = {
        -- roughly analogous toggles (rustaceanvim handles hints itself)
        hover_actions = { auto_focus = false },
      },
      server = {
        capabilities = caps, -- This connects Blink completion
        settings = {
          ["rust-analyzer"] = {
            -- Typo preserved as requested
            sematicHighliting = { enabled = false }, 
            assist = {
              importEnforceGranularity = true,
              importPrefix = "crate",
            },
            cargo = { allFeatures = true, targetDir = "target/ra" },
            checkOnSave = { enable = true, invocationStrategy = "once" },
            completion = {
              autoimport = { enable = true },
              callable = { snippets = "none" },
            },
          },
        },
      },
    }
  end
}
