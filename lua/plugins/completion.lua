return {
	{
		'saghen/blink.cmp',
		version = '*', -- Keep Nightly
		enabled = false,
		dependencies = {
			'rafamadriz/friendly-snippets',
			{ 'saghen/blink.compat', opts = { impersonate_nvim_cmp = false } },
			'supermaven-inc/supermaven-nvim',
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
						-- 1. Command Mode: Standard behavior (Enter executes command)
						if vim.fn.mode() == 'c' then
							return cmp.accept() or cmp.select_and_accept()
						end

						-- 2. Insert Mode: Strict Protection against the "Idle Bug"
						if cmp.is_visible() then
							-- Try to accept the current item
							if cmp.get_selected_item() then
								cmp.accept()
							else
								-- If state is stale (nothing selected despite menu open), force it
								cmp.select_and_accept()
							end
							-- CRITICAL: Always return true if menu was visible.
							-- This stops the "New Line" fallback even if the engine glitches.
							return true
						end
					end,
					'fallback' -- Only insert new line if menu was completely closed
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
						preselect = false,
						auto_insert = true -- Keeping your preference
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
						-- Added timeout to prevent hanging on wake-up
						timeout_ms = 3000,

						transform_items = function(_, items)
							local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
							local kind_idx = CompletionItemKind.Snippet

							for _, item in ipairs(items) do
								item.kind = kind_idx
								item.labelDetails = {
									detail = " "
								}
							end
							return items
						end,
					},
					lsp = {
						name = 'LSP',
						module = 'blink.cmp.sources.lsp',
						-- Added timeout for Rust Analyzer/LSPs waking up
						timeout_ms = 5000,
					},
					path = { name = 'Path', module = 'blink.cmp.sources.path' },
				},
			},

			signature = { enabled = true }
		},
	}
}
