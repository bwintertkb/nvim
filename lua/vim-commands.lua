-- Enable mouse support
vim.opt.mouse = "a"

-- Terminal navigation (Exit terminal mode easily)
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })
vim.keymap.set('t', '<leader><Esc>', '<C-\\><C-n>', { noremap = true })

-- Window Navigation (Move between splits with arrows)
vim.keymap.set('n', '<Up>', '<C-w><Up>', { noremap = true })
vim.keymap.set('n', '<Down>', '<C-w><Down>', { noremap = true })
vim.keymap.set('n', '<Left>', '<C-w><Left>', { noremap = true })
vim.keymap.set('n', '<Right>', '<C-w><Right>', { noremap = true })

-- Center screen when jumping up/down
vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true })
