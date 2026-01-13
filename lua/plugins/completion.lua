return {
	{
		'saghen/blink.cmp',
		version = '*',
		enabled = true,
		dependencies = {
			'rafamadriz/friendly-snippets',
			'giuxtaposition/blink-cmp-copilot',
		},

		opts = {
			keymap = {
				preset = 'default',
				['<C-l>'] = { 'select_and_accept' },
				['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
				['<Up>'] = { 'select_prev', 'fallback' },
				['<Down>'] = { 'select_next', 'fallback' },
				['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
				['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },

				-- !!! THE FIX: The Wake-Up Firewall !!!
				['<CR>'] = {
					function(cmp)
						if vim.fn.mode() == 'c' then
							return cmp.accept() or cmp.select_and_accept()
						end
						if cmp.is_visible() then
							if cmp.get_selected_item() then
								cmp.accept()
							else
								cmp.select_and_accept()
							end
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
					Copilot = '', -- Fallback definition
				},
			},

			completion = {
				list = {
					selection = {
						preselect = false,
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
				default = { 'lsp', 'copilot', 'path', 'snippets', 'buffer' },
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						score_offset = 100,
						async = true,

						transform_items = function(_, items)
							local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
							local kind_idx = CompletionItemKind.Copilot or CompletionItemKind.Text

							for _, item in ipairs(items) do
								-- 1. Set kind to something safe (Text or Copilot)
								item.kind = kind_idx
								-- 2. NUCLEAR OVERRIDE: Directly set the icon property
								-- This forces Blink to use this character, ignoring all theme tables
								item.kind_icon = ""
							end
							return items
						end,
					},
					lsp = {
						name = 'LSP',
						module = 'blink.cmp.sources.lsp',
						timeout_ms = 5000,
					},
					path = { name = 'Path', module = 'blink.cmp.sources.path' },
				},
			},

			signature = { enabled = true }
		},
	}
}
