return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" }, -- Load when opening a file
	opts = {
		-- The Magic: Formatting on Save
		format_on_save = {
			-- These options control how aggressive the formatting is
			lsp_fallback = true, -- If no formatter is found, use the LSP (Crucial for Rust!)
			async = false, -- False = wait for formatting to finish before saving
			timeout_ms = 1000, -- Kill the process if it takes too long
		},

		-- Define which tools to use for which filetype
		formatters_by_ft = {
			-- specific languages
			lua = { "stylua" }, -- You'll need to install stylua (via Mason or DNF)
			rust = { "rustfmt" },
			-- Generic fallbacks
			["_"] = { "trim_whitespace" }, -- Run on filetypes without a specific formatter
		},
	},
}
