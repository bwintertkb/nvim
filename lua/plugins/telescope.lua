return {
	'nvim-telescope/telescope.nvim',
	dependencies = { 'nvim-lua/plenary.nvim' },
	cmd = "Telescope",
	keys = {
		{ "<Tab>", "<cmd>Telescope oldfiles<cr>",        desc = "Recent files" },
		{ "gr",    "<cmd>Telescope lsp_references<cr>",  desc = "LSP references" },
		{ "<C-p>", "<cmd>Telescope find_files<cr>",      desc = "Find files" },
		{ "<C-u>", "<cmd>Telescope live_grep<cr>",       desc = "Live grep" },
		{ "<C-]>", "<cmd>Telescope lsp_definitions<cr>", desc = "LSP definitions" },
	},
	config = function()
		require('telescope').setup({
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
				preview = {
					treesitter = false,
				},
			}
		})
	end
}
