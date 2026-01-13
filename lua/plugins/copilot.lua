return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			-- Start disabled
			enabled = false,
			suggestion = { enabled = false },
			panel = { enabled = false },
			filetypes = {
				markdown = true,
				help = true,
			},
		},
		config = function(_, opts)
			require("copilot").setup(opts)

			local function toggle_copilot()
				local client = require("copilot.client")
				local command = require("copilot.command")

				if client.is_disabled() then
					command.enable()
					vim.api.nvim_echo({ { "    Copilot Enabled  ", "MoreMsg" } }, false, {})
				else
					command.disable()
					vim.api.nvim_echo({ { "    Copilot Disabled  ", "WarningMsg" } }, false, {})
				end

				-- Clear message after 1.5s
				vim.defer_fn(function()
					vim.api.nvim_echo({}, false, {})
				end, 1500)
			end

			vim.keymap.set("n", "<M-g>", toggle_copilot, { desc = "Toggle Copilot (Alt)" })
		end,
	},
}
