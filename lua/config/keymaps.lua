vim.api.nvim_set_keymap('i', 'jk', '<ESC>', { noremap = true })
vim.keymap.set('n', '<leader>;', 'A;', { noremap = true })

-- Add new line above/below
vim.keymap.set('n', '<leader>=', 'O<ESC>j', { noremap = true })
vim.keymap.set('n', '<leader>-', 'o<ESC>k', { noremap = true })

-- Restart nvim (Note: This is less useful with Lazy, but I kept it)
vim.keymap.set('n', '<leader>sr', ':luafile %<CR>', { noremap = true })

-- Map move to start/end of line
vim.keymap.set({ 'n', 'v' }, 'H', '^', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'L', '$', { noremap = true })

-- Use unix line endings
vim.keymap.set("n", "<C-M>", [[:%s/\r//g<CR>]], { desc = "Remove ^M (CR) chars" })

-- Jump backward/forward
vim.keymap.set('n', '<C-j>', '<C-o>', { noremap = true })
vim.keymap.set('n', '<C-_>', '<C-i>')

-- 1. Map 'jk' to exit Terminal Insert Mode (go to Normal Mode)
-- This allows you to navigate the terminal output like a normal buffer
vim.keymap.set("t", "jk", "<C-\\><C-n>", { desc = "Exit Terminal Mode" })

-- 2. Map <C-j> to open a Vertical Terminal on the Right (30% width)
vim.keymap.set({ "n", "t" }, "<C-j>", function()
	-- 'rightbelow vnew' creates a clean vertical split on the far right
	vim.cmd("rightbelow vnew")

	-- Start the terminal in the new window
	vim.cmd("terminal")

	-- Calculate 25% of the total screen width
	local width = math.floor(vim.o.columns * 0.30)
	vim.cmd("vertical resize " .. width)

	-- Automatically enter Insert mode so you can type immediately
	vim.cmd("startinsert")
end, { desc = "Open Vertical Terminal" })
