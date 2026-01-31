vim.g.mapleader = " "

-- [Global general keymaps] Map jk as escape key in insert mode
vim.api.nvim_set_keymap('i', 'jk', '<ESC>', { noremap = true })
-- H goes to first non-blank character, L goes to end of line
vim.api.nvim_set_keymap('n', 'H', '^', { noremap = true })
vim.api.nvim_set_keymap('n', 'L', '$', { noremap = true })
-- Better indenting in visual mode (stay in visual mode after indent)
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })
-- Playback macro in register with capital Q
vim.keymap.set('n', 'Q', '@q', { desc = 'Play macro q' })
-- Use jk to for Insert -> Normal in Terminal mode
vim.keymap.set("t", "jk", [[<C-\><C-n>]], { noremap = true, silent = true })
-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

-- [Cursor]
-- Keep cursor a block in normal and insert mode
vim.opt.guicursor = "n-v-c:block-Cursor-blinkon0,i-ci-ve:block-CursorInsert-blinkon0,r-cr-o:block-CursorReplace-blinkon0"
vim.o.cursorline = true

local normal_bg = "#1a1f20"
local insert_bg = "#252a2b"

vim.api.nvim_set_hl(0, "CursorLine", { bg = normal_bg })

vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
        vim.api.nvim_set_hl(0, "CursorLine", { bg = insert_bg })
    end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
        vim.api.nvim_set_hl(0, "CursorLine", { bg = normal_bg })
    end,
})

-- [Options]
vim.o.clipboard = "unnamedplus"
vim.o.number = true
vim.o.relativenumber = true
vim.o.confirm = true
vim.o.tabstop = 4
vim.o.shiftwidth = 5
vim.o.smarttab = true
vim.o.softtabstop = 4
vim.o.scrolloff = 10
vim.o.wildmenu = true
vim.o.wildmode = 'full'
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"
vim.o.autoindent = true
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.backspace = "indent,eol,start"
vim.opt.statuscolumn = ""
-- Use ripgrep as grep default
vim.o.grepprg = "rg --vimgrep --smart-case"
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.autochdir = false

-- [Shell]
-- User command with completion and history
vim.api.nvim_create_user_command("R", function(opts)
	local output = vim.fn.systemlist(opts.args)
	vim.cmd("botright 15new")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
	vim.bo.swapfile = false
	vim.bo.filetype = "sh"
end, {
	nargs = "+",
	complete = function(arglead, cmdline, cursorpos)
		-- Get file completions
		local files = vim.fn.getcompletion(arglead, "file")
		-- Get shell command completions (for first argument)
		local parts = vim.split(cmdline, "%s+")
		if #parts <= 2 then -- still on first arg (command name)
			local cmds = vim.fn.getcompletion(arglead, "shellcmd")
			for _, cmd in ipairs(cmds) do
				table.insert(files, cmd)
			end
		end
		return files
	end,
})

vim.keymap.set("n", "<leader>r", ":R ", { desc = "Run shell command" })

-- [Terminal]
local function open_term(opts)
    opts = opts or {}
    local fullscreen = opts.fullscreen or false

    if fullscreen then
        vim.cmd("tabnew | terminal")
    else
        vim.cmd("botright vsplit | terminal")
        local width = math.floor(vim.o.columns * 0.35)
        vim.api.nvim_win_set_width(0, width)
    end

    local buf = vim.api.nvim_get_current_buf()

    -- Optional: make it look cleaner
    vim.bo[buf].buflisted = false
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"

    -- Shift+Q: close the terminal window (works from terminal insert too)
    vim.keymap.set("t", "Q", [[<C-\><C-n>:close<CR>]], { buffer = buf, noremap = true, silent = true })
    vim.keymap.set("n", "Q", [[<cmd>close<CR>]], { buffer = buf, noremap = true, silent = true })

    vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("T", function()
    open_term({ fullscreen = false })
end, {})

vim.api.nvim_create_user_command("TF", function()
    open_term({ fullscreen = true })
end, {})

-- [Tab + Terminal Workflow]
-- Mimic tmux prefix (C-a) for tab operations
local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = true
    opts.silent = true
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- C-a as "prefix" - we'll use it directly in combos
-- Tab navigation: C-a + h/l for prev/next tab
map({'n', 't'}, '<C-a>h', '<cmd>tabprevious<CR>')
map({'n', 't'}, '<C-a>l', '<cmd>tabnext<CR>')
vim.keymap.set({'n', 't'}, '<C-a>n', '<cmd>tabnext<CR>', { noremap = true, silent = true })
vim.keymap.set({'n', 't'}, '<C-a>p', '<cmd>tabprevious<CR>', { noremap = true, silent = true })

-- C-a + number to jump to tab (like tmux windows)
for i = 1, 9 do
    map({'n', 't'}, '<C-a>' .. i, '<cmd>tabnext ' .. i .. '<CR>')
end

-- C-a + c to create new tab with terminal
map({'n', 't'}, '<C-a>c', '<cmd>tabnew | terminal<CR>')

-- C-a + x to close current tab
map({'n', 't'}, '<C-a>x', '<cmd>tabclose<CR>')

-- Split navigation with C-hjkl (works from terminal mode too)
map('t', '<C-h>', [[<C-\><C-n><C-w>h]])
map('t', '<C-j>', [[<C-\><C-n><C-w>j]])
map('t', '<C-k>', [[<C-\><C-n><C-w>k]])
map('t', '<C-l>', [[<C-\><C-n><C-w>l]])
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- [Persistant undo directory]
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")
local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end

-- [Packages]
vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/y9san9/y9nika.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/junegunn/fzf",
	"https://github.com/junegunn/fzf.vim",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/chrisgrieser/nvim-lsp-endhints",
	"https://github.com/bwintertkb/visual_wrap.nvim",
	"https://github.com/zbirenbaum/copilot.lua",
	"https://github.com/saghen/blink.cmp",
	"https://github.com/giuxtaposition/blink-cmp-copilot",
	"https://github.com/nvimtools/hydra.nvim",
	"https://github.com/vim-airline/vim-airline",
	"https://github.com/vim-airline/vim-airline-themes",
	"https://github.com/tpope/vim-fugitive",
})

-- [Hydra] Pane resizing
local Hydra = require('hydra')
Hydra({
	name = 'Resize',
	mode = 'n',
	body = '<C-w>',
	heads = {
		{ 'H',     '<cmd>vertical resize -5<cr>' },
		{ 'L',     '<cmd>vertical resize +5<cr>' },
		{ 'K',     '<cmd>resize +5<cr>' },
		{ 'J',     '<cmd>resize -5<cr>' },
		{ '<Esc>', nil,                          { exit = true, nowait = true } },
	},
})

-- [File explorer]
require("oil").setup({
	default_file_explorer = true,
	columns = {
	},
	buf_options = {
		buflisted = false,
		bufhidden = "hide",
	},
	win_options = {
		statuscolumn = "",
		signcolumn = "no",
		number = true,
		relativenumber = true,
		conceallevel = 3,
		concealcursor = "nvic",
	},
	delete_to_trash = false,
	skip_confirm_for_simple_edits = false,
	prompt_save_on_select_new_entry = true,
	cleanup_delay_ms = 2000,
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = false,
	},
	constrain_cursor = "editable",
	watch_for_changes = false,
	keymaps = {
		["g?"] = { "actions.show_help", mode = "n" },
		["<CR>"] = "actions.select",
		["<C-s>"] = { "actions.select", opts = { vertical = true } },
		["<C-h>"] = { "actions.select", opts = { horizontal = true } },
		["<C-t>"] = { "actions.select", opts = { tab = true } },
		["<C-p>"] = "actions.preview",
		["<C-c>"] = { "actions.close", mode = "n" },
		["<C-l>"] = "actions.refresh",
		["-"] = { "actions.parent", mode = "n" },
		["_"] = { "actions.open_cwd", mode = "n" },
		["`"] = false,  -- disabled to prevent cwd changes
		["g~"] = false, -- disabled to prevent cwd changes
		["gs"] = { "actions.change_sort", mode = "n" },
		["gx"] = "actions.open_external",
		["g."] = { "actions.toggle_hidden", mode = "n" },
		["g\\"] = { "actions.toggle_trash", mode = "n" },
	},
	use_default_keymaps = true,
	view_options = {
		show_hidden = true,
		is_hidden_file = function(name, bufnr)
			return name:match("^%.") ~= nil
		end,
		is_always_hidden = function(name, bufnr)
			return false
		end,
		natural_order = "fast",
		case_insensitive = false,
		sort = {
			{ "type", "asc" },
			{ "name", "asc" },
		},
		highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
			return nil
		end,
	},
	extra_scp_args = {},
	extra_s3_args = {},
	git = {
		add = function(path) return false end,
		mv = function(src_path, dest_path) return false end,
		rm = function(path) return false end,
	},
	float = {
		padding = 2,
		max_width = 0,
		max_height = 0,
		border = nil,
		win_options = {
			winblend = 0,
		},
		get_win_title = nil,
		preview_split = "auto",
		override = function(conf) return conf end,
	},
	preview_win = {
		update_on_cursor_moved = true,
		preview_method = "fast_scratch",
		disable_preview = function(filename) return false end,
		win_options = {},
	},
	confirmation = {
		max_width = 0.9,
		min_width = { 40, 0.4 },
		width = nil,
		max_height = 0.9,
		min_height = { 5, 0.1 },
		height = nil,
		border = nil,
		win_options = {
			winblend = 0,
		},
	},
	progress = {
		max_width = 0.9,
		min_width = { 40, 0.4 },
		width = nil,
		max_height = { 10, 0.9 },
		min_height = { 5, 0.1 },
		height = nil,
		border = nil,
		minimized_border = "none",
		win_options = {
			winblend = 0,
		},
	},
	ssh = {
		border = nil,
	},
	keymaps_help = {
		border = nil,
	},
})

vim.api.nvim_set_keymap('n', '=', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "oil",
	callback = function()
		vim.wo.statuscolumn = ""
		vim.wo.signcolumn = "no"
		vim.wo.conceallevel = 3
		vim.wo.concealcursor = "nvic"
	end,
})

-- [Project Root Management]
-- Auto-detect project root on startup based on common markers
local function find_project_root()
	local markers = { '.git', 'Cargo.toml', 'package.json', 'Makefile', '.project_root' }
	local path = vim.fn.expand('%:p:h')
	if path == '' then path = vim.fn.getcwd() end

	for _ = 1, 20 do -- max depth
		for _, marker in ipairs(markers) do
			if vim.fn.isdirectory(path .. '/' .. marker) == 1 or vim.fn.filereadable(path .. '/' .. marker) == 1 then
				return path
			end
		end
		local parent = vim.fn.fnamemodify(path, ':h')
		if parent == path then break end
		path = parent
	end
	return nil
end

-- Set project root on VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local root = find_project_root()
		if root then
			vim.g.project_root = root
			vim.cmd("cd " .. vim.fn.fnameescape(root))
		else
			vim.g.project_root = vim.fn.getcwd()
		end
	end,
})

-- Manual commands
vim.api.nvim_create_user_command("SetRoot", function()
    local dir
    if vim.bo.filetype == "oil" then
        dir = require("oil").get_current_dir()
    else
        dir = vim.fn.expand('%:p:h')
    end
    if dir and dir ~= "" then
        vim.g.project_root = dir
        vim.cmd("cd " .. vim.fn.fnameescape(dir))
        vim.notify("Project root: " .. dir)
    end
end, {})
vim.keymap.set('n', '<leader>sd', '<cmd>SetRoot<CR>', { desc = 'set project root' })

vim.api.nvim_create_user_command("CdRoot", function()
	if vim.g.project_root then
		vim.cmd("cd " .. vim.fn.fnameescape(vim.g.project_root))
		vim.notify("cd " .. vim.g.project_root)
	else
		vim.notify("No project root set", vim.log.levels.WARN)
	end
end, {})

vim.keymap.set('n', '<leader>cd', '<cmd>CdRoot<CR>', { desc = 'cd to project root' })

-- File explorer for all files with fzf
-- Use fd instead
-- File explorer for all files with fzf
vim.env.FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'
vim.env.FZF_DEFAULT_OPTS = '--bind=tab:up,shift-tab:down'
vim.g.fzf_layout = { down = '35%' }

vim.keymap.set('n', '<C-p>', '<CMD>Files<CR>', {
	desc = 'Find files (fzf)'
})
vim.keymap.set('n', '<TAB>', '<CMD>History<CR>', {
	desc = 'Recent files (fzf)'
})
vim.keymap.set('n', '<C-u>', '<CMD>Rg<CR>', { desc = 'Grep project' })

-- [Visual wrap]
require("visual_wrap").setup()

-- [Theme]
-- Treesitter highlights
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		if vim.bo.filetype ~= "oil" then
			pcall(vim.treesitter.start)
		end
	end,
})

vim.o.termguicolors = true

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		local hl = vim.api.nvim_set_hl
		hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#ff5555" })
		hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#f1fa8c" })
		hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#8be9fd" })
		hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = "#50fa7b" })
	end,
})

vim.cmd.colorscheme('y9nika-less')

require("y9nika.core").apply {
	background = "#0e1415",
	foreground = "#d0cfb8",
	primary = "#71ade7",
	secondary = "#95cb82",
	muted = "#aaaaaa",
	marker = "#dfdf8e",

}

-- Numbers: stand out, but calm
vim.api.nvim_set_hl(0, "Number", { fg = "#9fb4c7" })
vim.api.nvim_set_hl(0, "Float", { fg = "#9fb4c7" })
vim.api.nvim_set_hl(0, "Boolean", { fg = "#9fb4c7" })
-- Comments: neutral grey
vim.api.nvim_set_hl(0, "Comment", { fg = "#8a8f93" })

local hl = vim.api.nvim_set_hl
hl(0, "@comment", { link = "Comment" })
hl(0, "@string", { fg = "#a9b665" })
hl(0, "@number", { link = "Number" })
hl(0, "@float", { link = "Float" })
hl(0, "@boolean", { link = "Boolean" })
hl(0, "@keyword", { link = "Keyword" })
hl(0, "@keyword.function", { link = "Keyword" })
hl(0, "@keyword.return", { link = "Keyword" })
hl(0, "@keyword.operator", { link = "Keyword" })
hl(0, "@conditional", { link = "Keyword" })
hl(0, "@repeat", { link = "Keyword" })
hl(0, "@function", { link = "Function" })
hl(0, "@function.call", { link = "Function" })
hl(0, "@function.builtin", { link = "Function" })
hl(0, "@method", { link = "Function" })
hl(0, "@method.call", { link = "Function" })
hl(0, "@type", { link = "Type" })
hl(0, "@type.builtin", { link = "Type" })
hl(0, "@constant", { link = "Constant" })
hl(0, "@constant.builtin", { link = "Constant" })
hl(0, "@field", { link = "Identifier" })
hl(0, "@parameter", { link = "Identifier" })
hl(0, "@operator", { link = "Operator" })
hl(0, "@punctuation", { link = "Delimiter" })
hl(0, "@punctuation.bracket", { link = "Delimiter" })
hl(0, "@punctuation.delimiter", { link = "Delimiter" })
hl(0, "@lsp.type.parameter", { link = "Identifier" })
hl(0, "@lsp.type.property", { link = "Identifier" })
hl(0, "@variable.lua", { link = "@function.call.lua" })
hl(0, "@y9nika.variable", { link = "@function.call.lua" })
hl(0, "@y9nika.variable.lua", { link = "@function.call.lua" })
hl(0, "@lsp.type.function", { link = "Function" })
hl(0, "@lsp.type.method", { link = "Function" })
hl(0, "@lsp.typemod.function.declaration", { link = "Function" })
hl(0, "@lsp.typemod.method.declaration", { link = "Function" })
hl(0, "@function.call.rust", { fg = "#71ade7" })

-- [Auto pair]
require("nvim-autopairs").setup({
	check_ts = true,
})
require("nvim-autopairs").remove_rule("'", "rust")

-- [End of line hints]
require("lsp-endhints").setup({
	icons = {
		type = "=> ",
		parameter = "<- ",
		offspec = " ",
		unknown = " ",
	},
	label = {
		padding = 1,
		marginLeft = 0,
		bracketedParameters = true,
	},
	autoEnableHints = true,
})


-- [Statusline]
vim.g.airline_theme = "minimalist"
vim.g.airline_powerline_fonts = 0
vim.g["airline#extensions#branch#enabled"] = 1
vim.g.airline_section_b = "%{airline#extensions#branch#get_head()}"
vim.g.airline_section_b = "%{FugitiveHead()}"
vim.g.airline_left_sep = ""
vim.g.airline_right_sep = ""
vim.g.airline_left_alt_sep = ""
vim.g.airline_right_alt_sep = ""
vim.g.airline_section_y = ""
vim.g.airline_section_z = "L:%l/%L C:%c"
vim.g["airline#extensions#whitespace#enabled"] = 0

-- Enable airline tabline
vim.g["airline#extensions#tabline#enabled"] = 1
vim.g["airline#extensions#tabline#tab_nr_type"] = 1
vim.g["airline#extensions#tabline#show_tab_nr"] = 1
vim.g["airline#extensions#tabline#tab_min_count"] = 1
vim.g["airline#extensions#tabline#show_buffers"] = 0
vim.g["airline#extensions#tabline#fnamemod"] = ':t'

-- Custom tab label format
vim.g["airline#extensions#tabline#tabtitle_formatter"] = 'TabNum'
vim.cmd([[
  function! TabNum(n)
    return 'Tab ' . (a:n - 1)
  endfunction
]])
-- force redraw once everything is loaded
vim.cmd("silent! AirlineRefresh")


-- [Copilot]
require("copilot").setup({
	suggestion = { enabled = false }, -- disabled, using blink.cmp instead
	panel = { enabled = true },
	filetypes = {
		markdown = true,
		help = true,
	},
})

-- Force disable on startup (silently)
local original_notify = vim.notify
vim.notify = function(...) end
require("copilot.command").disable()
vim.defer_fn(function()
	vim.notify = original_notify
end, 100)

-- Toggle function
local function toggle_copilot()
	local client = require("copilot.client")
	local command = require("copilot.command")
	if client.is_disabled() then
		command.enable()
		vim.api.nvim_echo({ { "  Copilot Enabled  ", "MoreMsg" } }, false, {})
	else
		command.disable()
		vim.api.nvim_echo({ { "  Copilot Disabled  ", "WarningMsg" } }, false, {})
	end
	vim.defer_fn(function()
		vim.api.nvim_echo({}, false, {})
	end, 1500)
end

vim.keymap.set("n", "<M-g>", toggle_copilot, { desc = "Toggle Copilot" })

-- [Completion with blink.cmp]
require("blink.cmp").setup({
	keymap = {
		preset = 'default',
		['<C-l>'] = { 'select_and_accept' },
		['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
		['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
		['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
		['<Space>'] = { 'accept', 'fallback' },
	},
	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = 'mono',
	},
	completion = {
		list = {
			selection = { preselect = false, auto_insert = true }
		},
		documentation = {
			auto_show = false,
			auto_show_delay_ms = 200,
		},
		ghost_text = { enabled = false },
	},
	sources = {
		default = { 'lsp', 'copilot', 'path', 'buffer' },
		providers = {
			copilot = {
				name = "copilot",
				module = "blink-cmp-copilot",
				score_offset = 100,
				async = true,
				transform_items = function(_, items)
					for _, item in ipairs(items) do
						item.kind_icon = "★"
					end
					return items
				end,
			},
		},
	},
	signature = { enabled = false },
})

-- [LSP CONFIG]
-- On attach: enable inlay hints
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		-- Inlay hints
		if client and client:supports_method('textDocument/inlayHint') then
			vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
		end
	end,
})

vim.keymap.set('n', '<leader>h', function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
end, { desc = 'Toggle inlay hints' })

-- Keymaps
vim.keymap.set('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<cr>')
vim.keymap.set('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<cr>')
vim.keymap.set('n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
vim.keymap.set('n', 'gc', '<cmd>lua vim.lsp.buf.incoming_calls()<cr>')
vim.keymap.set('n', 'gC', '<cmd>lua vim.lsp.buf.outgoing_calls()<cr>')
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.document_symbol()<cr>')
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
vim.keymap.set('n', 'gw', '<cmd>lua vim.lsp.buf.workspace_symbol()<cr>')
vim.keymap.set('n', '<leader>.', '<cmd>lua vim.lsp.buf.code_action()<cr>')
vim.keymap.set('n', '[x', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
vim.keymap.set('n', ']x', '<cmd>lua vim.diagnostic.goto_next()<cr>')
vim.keymap.set('n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>lua vim.diagnostic.setqflist()<cr>')
vim.keymap.set('n', '<leader>p', '<cmd>lua vim.lsp.buf.format()<cr>')

-- Format using LSP
-- If LSP does not support formatting, fall back to external formatter
local formatters = {
	python = "black -q -",
	rust = "rustfmt",
	json = "jq .",
	javascript = "prettier --stdin-filepath %",
	typescript = "prettier --stdin-filepath %",
	html = "prettier --stdin-filepath %",
	css = "prettier --stdin-filepath %",
	lua = "stylua -",
	sh = "shfmt -i 2",
	go = "gofmt",
	c = "clang-format",
	cpp = "clang-format",
}

local function formatter_exists(cmd)
	local binary = cmd:match("^(%S+)")
	return vim.fn.executable(binary) == 1
end

vim.keymap.set('n', '<leader>f', function()
	-- Try LSP first
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	for _, client in ipairs(clients) do
		if client:supports_method('textDocument/formatting') then
			vim.lsp.buf.format()
			return
		end
	end

	-- Fall back to external formatter
	local ft = vim.bo.filetype
	local formatter = formatters[ft]

	if not formatter then
		vim.notify("No formatter configured for " .. ft, vim.log.levels.WARN)
		return
	end

	if not formatter_exists(formatter) then
		local binary = formatter:match("^(%S+)")
		vim.notify("Formatter not installed: " .. binary, vim.log.levels.WARN)
		return
	end

	local view = vim.fn.winsaveview()
	vim.bo.formatprg = formatter
	vim.cmd('normal! gggqG')
	vim.fn.winrestview(view)
end, { desc = 'Format file' })

-- Rust
vim.lsp.config('rust_analyzer', {
	cmd = { 'rust-analyzer' },
	filetypes = { 'rust' },
	root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
	capabilities = vim.lsp.protocol.make_client_capabilities(),
	settings = {
		['rust-analyzer'] = {
			semanticHighlighting = { enable = true },
			assist = {
				importEnforceGranularity = true,
				importPrefix = 'crate',
			},
			inlayHints = {
				typeHints = { enable = true },
				parameterHints = { enable = false },
				chainingHints = { enable = false }
			},
			cargo = {
				allFeatures = true,
				targetDir = 'target/ra',
			},
			checkOnSave = {
				enable = true,
				invocationStrategy = 'once',
			},
			completion = {
				autoimport = { enable = true },
				callable = { snippets = 'none' },
			},
		},
	},
})
vim.lsp.enable('rust_analyzer')

-- Python
vim.lsp.config('basedpyright', {
	cmd = { 'basedpyright-langserver', '--stdio' },
	filetypes = { 'python' },
	root_markers = { 'pyproject.toml', 'setup.py', 'requirements.txt', '.git' },
})
vim.lsp.enable('basedpyright')

-- Lua
vim.lsp.config('lua_ls', {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath('config')
				and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				-- Neovim uses LuaJIT
				version = 'LuaJIT',
				-- Same module resolution style as Neovim
				path = {
					'lua/?.lua',
					'lua/?/init.lua',
				},
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- optional but often helpful when editing your config
					vim.fn.stdpath('config'),
				},
			},
			diagnostics = {
				globals = { 'vim' },
			},
		})
	end,

	settings = {
		Lua = {},
	},
})

vim.lsp.enable('lua_ls')
