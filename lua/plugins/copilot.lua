return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
			debounce = 25,
			filetypes = {
				markdown = true,
				help = true,
			},
		},
	},
}
