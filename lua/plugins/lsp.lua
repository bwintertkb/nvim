return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"saghen/blink.cmp", -- Currently commented out
	},
	config = function()
		-- 1. Keymaps (Run when an LSP attaches to a buffer)
		vim.api.nvim_create_autocmd('LspAttach', {
			desc = 'LSP actions',
			callback = function(event)
				local opts = { buffer = event.buf, noremap = true, silent = true }
				vim.keymap.set('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
				vim.keymap.set('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
				vim.keymap.set('n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
				vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
				vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
				vim.keymap.set('n', 'gc', '<cmd>lua vim.lsp.buf.incoming_calls()<cr>', opts)
				vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
				vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.document_symbol()<cr>', opts)
				vim.keymap.set('n', 'gw', '<cmd>lua vim.lsp.buf.workspace_symbol()<cr>', opts)
				vim.keymap.set('n', '[x', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
				vim.keymap.set('n', ']x', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
				vim.keymap.set('n', ']s', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
				vim.keymap.set('n', '<leader>.', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
				vim.keymap.set('n', '<leader>p', '<cmd>lua vim.lsp.buf.format()<cr>', opts)
			end,
		})

		-- 2. Setup Mason (The Installer)
		require("mason").setup({
			ui = { icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" } }
		})

		-- 3. Setup Mason-LSPConfig (The Downloader ONLY)
		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls", "gopls" },
			automatic_installation = true,
		})

		-- 4. Manual Server Setup (Native 0.11 Way)
		-- FAILSAFE: Start with defaults, only use Blink if it loads
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local has_blink, blink = pcall(require, 'blink.cmp')

		if has_blink then
			capabilities = blink.get_lsp_capabilities()
		end

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
		-- vim.lsp.config("gopls", { capabilities = capabilities })
		-- vim.lsp.enable("gopls")

		-- --- Rust Analyzer Setup (For your Fedora System) ---
		vim.lsp.config("rust_analyzer", {
			capabilities = capabilities,
			cmd = { "rustup", "run", "stable", "rust-analyzer" },
		})
		vim.lsp.enable("rust_analyzer")

		-- Zig
		vim.lsp.config("zls", {
			capabilities = capabilities,
		})
		vim.lsp.enable("zls")
	end
}
