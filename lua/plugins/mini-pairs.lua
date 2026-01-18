return {
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		opts = {
			modes = { insert = true, command = true, terminal = false },
			-- skip_next = [=[[%w%%%'%[%"%.%`%$]]=], -- optional: skip if next char is alphanumeric
			-- skip_ts = { "string" }, -- optional: skip in treesitter strings
			-- skip_unbalanced = true, -- optional: skip if you have unbalanced brackets
			markdown = true,
		},
		config = function(_, opts)
			require("mini.pairs").setup(opts)
		end,
	}
}
