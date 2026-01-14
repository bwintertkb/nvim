return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			-- suggestion/panel settings must be true for them to work WHEN enabled
			suggestion = { enabled = true, auto_trigger = false },
			panel = { enabled = true },
			filetypes = {
				markdown = true,
				help = true,
			},
		},
		config = function(_, opts)
			require("copilot").setup(opts)

			-- FORCE DISABLE ON STARTUP
			require("copilot.command").disable()

			local function toggle_copilot()
				local client = require("copilot.client")
				local command = require("copilot.command")

				-- Since we force disabled on start, this logic now tracks correctly
				if client.is_disabled() then
					command.enable()
					vim.api.nvim_echo({ { "    Copilot Enabled  ", "MoreMsg" } }, false, {})
				else
					command.disable()
					vim.api.nvim_echo({ { "    Copilot Disabled  ", "WarningMsg" } }, false, {})
				end

				vim.defer_fn(function()
					vim.api.nvim_echo({}, false, {})
				end, 1500)
			end

			vim.keymap.set("n", "<M-g>", toggle_copilot, { desc = "Toggle Copilot (Alt)" })
		end,
	},
}
