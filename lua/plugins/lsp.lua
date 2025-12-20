return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"saghen/blink.cmp",
	},
	config = function()
		-- 1. General Keymaps (Run when ANY LSP attaches)
		vim.api.nvim_create_autocmd('LspAttach', {
			desc = 'LSP actions',
			callback = function(event)
				local opts = { buffer = event.buf, noremap = true, silent = true }
				vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
				vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
				vim.keymap.set('n', '<leader>.', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
				-- Add your other keymaps here...
			end,
		})

		-- 2. Setup Mason (The Installer)
		require("mason").setup({
			ui = { icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" } }
		})

		-- 3. Setup Mason-LSPConfig (The Downloader ONLY)
		-- We removed 'handlers' to prevent it from calling deprecated code.
		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls", "gopls" },
			automatic_installation = true,
		})

		-- 4. Manual Server Setup (Native 0.11 Way)
		-- We explicitly configure only the servers we want.
		local capabilities = require('blink.cmp').get_lsp_capabilities()

		-- --- Lua LS Setup ---
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } }
				}
			}
		})
		vim.lsp.enable("lua_ls")

		-- --- Gopls Setup (if you want it controlled here) ---
		-- If you are using go.nvim, skip this block.
		-- Otherwise, uncomment to enable native handling:
		-- vim.lsp.config("gopls", { capabilities = capabilities })
		-- vim.lsp.enable("gopls")

		-- --- Rust Analyzer Setup (For your Fedora System) ---
		-- Since you use rustup, we point specifically to the wrapper we found earlier.
		-- We generally don't need to specify 'cmd' if it's in your path,
		-- but this ensures we use the correct one.
		vim.lsp.config("rust_analyzer", {
			capabilities = capabilities,
			cmd = { "rustup", "run", "stable", "rust-analyzer" },
		})
		vim.lsp.enable("rust_analyzer")
	end
}
