return {
	"mrcjkb/rustaceanvim",
	version = "^5", -- Recommended
	lazy = false, -- This plugin is already lazy-loaded by filetype (ft=rust) automatically

	config = function()
		-- 1. Start with default Neovim capabilities
		local caps = vim.lsp.protocol.make_client_capabilities()

		-- 2. Safely try to load Blink
		local has_blink, blink = pcall(require, 'blink.cmp')

		-- 3. If Blink exists, upgrade the capabilities
		if has_blink then
			caps = blink.get_lsp_capabilities()
		end

		vim.g.rustaceanvim = {
			tools = {
				-- roughly analogous toggles (rustaceanvim handles hints itself)
				hover_actions = { auto_focus = false },
			},
			server = {
				capabilities = caps, -- Uses Blink if enabled, defaults otherwise
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
