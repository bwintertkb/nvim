return {
  {
    'saghen/blink.cmp',
    version = '*',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'saghen/blink.compat',
      'supermaven-inc/supermaven-nvim',
    },
	list = {
          selection = {
            preselect = true,   -- Automatically select the first item
            auto_insert = true  -- specific to blink: inserts immediately on selection
          }
        },

    opts = {
      keymap = { 
        preset = 'none',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
        kind_icons = {
          Text = '󰉿', Method = '󰊕', Function = '󰊕', Constructor = '󰒓',
          Field = '󰜢', Variable = '󰆦', Property = '󰖷', Class = '󰠱',
          Interface = '󰜰', Struct = '󰙅', Module = '󰏗', Unit = '󰪚',
          Value = '󰎠', Enum = '⾲', Keyword = '󰌋', Snippet = '󰅩',
          Color = '󰏘', File = '󰈔', Reference = '󰬲', Folder = '󰉋',
          Event = '󰏜', Operator = '󰆕', TypeParameter = '󰅲',
        },
      },

      completion = {
        -- :: NEW :: This controls the preview box on the right
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
             border = 'rounded',
          },
        },

        -- Optional: Shows the suggestion in gray text inline
        ghost_text = {
          enabled = false,
        },

        menu = {
          draw = {
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
          }
        }
      },

      sources = {
        default = { 'lsp', 'supermaven', 'path', 'snippets', 'buffer' },
        providers = {
          supermaven = {
            name = "supermaven",
            module = "blink.compat.source",
            score_offset = 100,
            async = true,
          },
          lsp = { name = 'LSP', module = 'blink.cmp.sources.lsp' },
          path = { name = 'Path', module = 'blink.cmp.sources.path' },
        },
      },
      
      signature = { enabled = true }
    },
  }
}
