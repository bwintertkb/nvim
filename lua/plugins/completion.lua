return {
	{
		'saghen/blink.cmp',
		version = '*', -- Keep Nightly for best text-edit support
		dependencies = {
			'rafamadriz/friendly-snippets',
			{ 'saghen/blink.compat', opts = { impersonate_nvim_cmp = true } },
			'supermaven-inc/supermaven-nvim',
		},

		opts = {
			keymap = {
				preset = 'default',
				['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
				['<Up>'] = { 'select_prev', 'fallback' },
				['<Down>'] = { 'select_next', 'fallback' },
				['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
				['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },

				-- Your "Firewall" Enter Key (Prevents New Line crashes)
				['<CR>'] = {
					function(cmp)
						if cmp.is_visible() and cmp.get_selected_item() then
							cmp.accept()
							return true
						end
					end,
					'fallback'
				},
			},

			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = 'mono',
				kind_icons = {
					Text = '󰉿',
					Method = '󰊕',
					Function = '󰊕',
					Constructor = '󰒓',
					Field = '󰜢',
					Variable = '󰆦',
					Property = '󰖷',
					Class = '󰠱',
					Interface = '󰜰',
					Struct = '󰙅',
					Module = '󰏗',
					Unit = '󰪚',
					Value = '󰎠',
					Enum = '⾲',
					Keyword = '󰌋',
					Snippet = '󰅩',
					Color = '󰏘',
					File = '󰈔',
					Reference = '󰬲',
					Folder = '󰉋',
					Event = '󰏜',
					Operator = '󰆕',
					TypeParameter = '󰅲',
				},
			},

			completion = {
				list = {
					selection = {
						preselect = false, -- Don't select automatically when menu opens

						-- !!! THE CHANGE !!!
						-- When you manually select an item (with Tab/Arrows),
						-- it immediately writes it to the buffer (Preview Mode).
						auto_insert = true
					}
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = { border = 'rounded' },
				},
				ghost_text = { enabled = false },
			},

			sources = {
				default = { 'lsp', 'supermaven', 'path', 'snippets', 'buffer' },
				providers = {
					supermaven = {
						name = "supermaven",
						module = "blink.compat.source",
						score_offset = 100,
						async = true,
						-- Force Snippet kind to fix text overwriting issues
						transform_items = function(_, items)
							for _, item in ipairs(items) do
								item.kind = require('blink.cmp.types').CompletionItemKind.Snippet
							end
							return items
						end,
					},
					lsp = { name = 'LSP', module = 'blink.cmp.sources.lsp' },
					path = { name = 'Path', module = 'blink.cmp.sources.path' },
				},
			},

			signature = { enabled = true }
		},
	}
}
