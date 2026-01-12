return {
	{
		'saghen/blink.cmp',
		version = '*',
		enabled = true,
		dependencies = {
			'rafamadriz/friendly-snippets',
			-- The native bridge for Copilot (no blink.compat needed)
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

				-- !!! THE FIX: The Wake-Up Firewall (Preserved) !!!
				['<CR>'] = {
					function(cmp)
						-- 1. Command Mode: Standard behavior
						if vim.fn.mode() == 'c' then
							return cmp.accept() or cmp.select_and_accept()
						end

						-- 2. Insert Mode: Strict Protection against the "Idle Bug"
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
					Copilot = '', -- Added specific icon for Copilot
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
				-- Added 'copilot' to the default list
				default = { 'lsp', 'copilot', 'path', 'snippets', 'buffer' },
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						score_offset = 100,
						async = true,

						transform_items = function(_, items)
							local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
							-- Using 'Event' (or you could use 'Copilot' if your font supports it)
							local kind_idx = CompletionItemKind.Event

							for _, item in ipairs(items) do
								item.kind = kind_idx
								item.labelDetails = {
									detail = " " -- GitHub icon in the detail column
								}
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
