return {
	{
		'saghen/blink.cmp',
		version = '*', -- Keep Nightly for best text-edit support
		dependencies = {
			'rafamadriz/friendly-snippets',
			{ 'saghen/blink.compat', opts = { impersonate_nvim_cmp = false } },
			'supermaven-inc/supermaven-nvim',
		},

		opts = {
			keymap = {
				preset = 'default',
				['<C-l>'] = {
					'select_and_accept'
				},
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
						transform_items = function(_, items)
							local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
							local kind_idx = CompletionItemKind.Snippet

							for _, item in ipairs(items) do
								-- 1. Keep your fix for text overwriting
								item.kind = kind_idx

								-- 2. Add a visual marker (Star symbol) to LabelDetails
								-- This appears in the menu next to the suggestion
								item.labelDetails = {
									detail = " "
								}
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
