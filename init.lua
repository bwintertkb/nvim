vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")

-- Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
		lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Load Plugins
require("lazy").setup({
	spec = { { import = "plugins" } },
	checker = { enabled = true, notify = false },
})

-- Load Custom Configs
require('config.autocmds') -- This tells Neovim to read the file below
require('config.diagnostics')
require('config.keymaps')
require('vim-commands')
