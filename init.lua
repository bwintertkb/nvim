vim.g.mapleader = " "

-- [Global general keymaps]
vim.api.nvim_set_keymap('i', 'jk', '<ESC>', { noremap = true })
vim.api.nvim_set_keymap('n', 'H', '^', { noremap = true })
vim.api.nvim_set_keymap('n', 'L', '$', { noremap = true })
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })
vim.keymap.set('n', 'Q', '@q', { desc = 'Play macro q' })
vim.keymap.set("t", "jk", [[<C-\><C-n>]], { noremap = true, silent = true })
-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
})

-- [Cursor]
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
vim.o.shiftwidth = 4
vim.o.smarttab = true
vim.o.softtabstop = 4
vim.o.scrolloff = 10
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.backspace = "indent,eol,start"
vim.opt.statuscolumn = ""
vim.o.grepprg = "rg --vimgrep --smart-case"
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.autochdir = false
vim.o.scrollback = 100000

-- [Shell]
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
		local files = vim.fn.getcompletion(arglead, "file")
		local parts = vim.split(cmdline, "%s+")
		if #parts <= 2 then
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
	local horizontal = opts.horizontal or false

	if fullscreen then
		vim.cmd("tabnew | terminal")
	elseif horizontal then
		vim.cmd("botright new | terminal")
		local height = math.floor(vim.o.lines * 0.3)
		vim.api.nvim_win_set_height(0, height)
	else
		vim.cmd("botright vnew | terminal")
		local width = math.floor(vim.o.columns * 0.35)
		vim.api.nvim_win_set_width(0, width)
	end

	local buf = vim.api.nvim_get_current_buf()

	vim.bo[buf].buflisted = false
	vim.wo.number = false
	vim.wo.relativenumber = false
	vim.wo.signcolumn = "no"

	vim.keymap.set("t", "Q", [[<C-\><C-n>:close<CR>]], { buffer = buf, noremap = true, silent = true })
	vim.keymap.set("n", "Q", [[<cmd>close<CR>]], { buffer = buf, noremap = true, silent = true })

	vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("T", function() open_term() end, {})
vim.api.nvim_set_keymap('n', '<leader>tk', '<CMD>:T<CR>', { desc = 'open a vertically split terminal' })

vim.api.nvim_create_user_command("TH", function() open_term({ horizontal = true }) end, {})
vim.api.nvim_set_keymap('n', '<leader>th', '<CMD>:TH<CR>', { desc = 'open a horizontally split terminal' })

vim.api.nvim_create_user_command("TF", function() open_term({ fullscreen = true }) end, {})
vim.api.nvim_set_keymap('n', '<leader>tf', '<CMD>:TF<CR>', { desc = 'open a full screen terminal' })

-- [Tab + Terminal Workflow]
local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.noremap = true
	opts.silent = true
	vim.keymap.set(mode, lhs, rhs, opts)
end

map({ 'n', 't' }, '<C-a>h', '<cmd>tabprevious<CR>')
map({ 'n', 't' }, '<C-a>l', '<cmd>tabnext<CR>')
vim.keymap.set({ 'n', 't' }, '<C-a>n', '<cmd>tabnext<CR>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 't' }, '<C-a>p', '<cmd>tabprevious<CR>', { noremap = true, silent = true })

for i = 1, 9 do
	map({ 'n', 't' }, '<C-a>' .. i, '<cmd>tabnext ' .. i .. '<CR>')
end

map({ 'n', 't' }, '<C-a>c', '<cmd>tabnew | terminal<CR>')
map({ 'n', 't' }, '<C-a>x', '<cmd>tabclose<CR>')

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
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/chrisgrieser/nvim-lsp-endhints",
	"https://github.com/bwintertkb/visual_wrap.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/zbirenbaum/copilot.lua",
	"https://github.com/CopilotC-Nvim/CopilotChat.nvim",
	"https://github.com/saghen/blink.cmp",
	"https://github.com/nvimtools/hydra.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
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
	columns = {},
	win_options = {
		statuscolumn = "",
		signcolumn = "no",
		number = true,
		relativenumber = true,
		conceallevel = 3,
		concealcursor = "nvic",
	},
	keymaps = {
		["`"] = false,
		["g~"] = false,
	},
	view_options = {
		show_hidden = true,
		sort = {
			{ "type", "asc" },
			{ "name", "asc" },
		},
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
local function find_project_root()
	local markers = { '.git', 'Cargo.toml', 'package.json', 'Makefile', '.project_root' }
	local path = vim.fn.expand('%:p:h')
	if path == '' then path = vim.fn.getcwd() end

	for _ = 1, 20 do
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

-- [Telescope - Find / Grep / Recent]
require('telescope').setup({
	defaults = {
		file_ignore_patterns = { ".git/" },
		layout_strategy = 'horizontal',
	},
	pickers = {
		find_files = {
			hidden = true,
			no_ignore = false,
		},
		oldfiles = {
			cwd_only = true,
		},
	},
})

local builtin = require('telescope.builtin')

-- C-p: find files (Telescope)
vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Telescope find files' })

-- TAB: recent files in project (Telescope)
vim.keymap.set('n', '<TAB>', builtin.oldfiles, { desc = 'Telescope recent files' })

-- C-u: grep project (Telescope)
vim.keymap.set('n', '<C-u>', builtin.live_grep, { desc = 'Telescope live grep' })


-- [Quickfix behaviour]
-- Tab/Shift-Tab to navigate, Enter to open (already default), q to close
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function(ev)
		local buf = ev.buf
		vim.keymap.set('n', '<TAB>', 'j', { buffer = buf, noremap = true, silent = true })
		vim.keymap.set('n', '<S-TAB>', 'k', { buffer = buf, noremap = true, silent = true })
		vim.keymap.set('n', 'q', '<cmd>cclose<CR>', { buffer = buf, noremap = true, silent = true })
	end,
})

-- Quickfix navigation + toggle
vim.keymap.set('n', ']q', '<cmd>cnext<CR>zz', { desc = 'Next quickfix' })
vim.keymap.set('n', '[q', '<cmd>cprev<CR>zz', { desc = 'Prev quickfix' })
vim.keymap.set('n', '<leader>o', function()
	local wins = vim.fn.getwininfo()
	for _, win in ipairs(wins) do
		if win.quickfix == 1 then
			vim.cmd("cclose")
			return
		end
	end
	vim.cmd("copen")
end, { desc = 'Toggle quickfix' })

-- [Visual wrap]
require("visual_wrap").setup()

-- [Theme]
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

vim.api.nvim_set_hl(0, "Number", { fg = "#9fb4c7" })
vim.api.nvim_set_hl(0, "Float", { fg = "#9fb4c7" })
vim.api.nvim_set_hl(0, "Boolean", { fg = "#9fb4c7" })
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
local cached_branch = ""
vim.g.copilot_enabled = false -- Initialize global variable

local function update_git_branch()
	local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null"):gsub("\n", "")
	if vim.v.shell_error ~= 0 then
		cached_branch = ""
	else
		cached_branch = " " .. branch .. " |"
	end
end

vim.api.nvim_create_autocmd({ "DirChanged", "VimEnter" }, {
	callback = update_git_branch,
})

function StatusLine()
	-- Access global variable directly
	local copilot_status = vim.g.copilot_enabled and " [CP] " or ""
	return table.concat({
		" %f",
		" %m",
		cached_branch,
		"%=",
		copilot_status,
		" L:%l/%L C:%c ",
	})
end

vim.o.statusline = "%{%v:lua.StatusLine()%}"

-- Tabline
vim.o.showtabline = 2

function TabLine()
	local s = ""
	for i = 1, vim.fn.tabpagenr("$") do
		local is_sel = (i == vim.fn.tabpagenr())
		s = s .. (is_sel and "%#TabLineSel#" or "%#TabLine#")
		s = s .. " %" .. i .. "T"
		s = s .. " Tab " .. (i - 1) .. " "
	end
	s = s .. "%#TabLineFill#"
	return s
end

vim.o.tabline = "%!v:lua.TabLine()"

-- [Copilot]
require("copilot").setup({
	panel = {
		enabled = false,
	},
	suggestion = {
		enabled = true,
		auto_trigger = true, -- Enable auto_trigger so it works when the client is enabled
		keymap = {
			accept = "<C-f>",
			accept_word = "<C-j>",
			accept_line = false,
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
	},
	filetypes = {
		["*"] = true,
	},
})

-- Initialize Copilot as disabled (SILENTLY)
vim.schedule(function()
	-- HACK: Temporarily mute notifications to suppress "Copilot disabled" message on startup
	local original_notify = vim.notify
	vim.notify = function() end
	pcall(require("copilot.command").disable)
	vim.defer_fn(function() vim.notify = original_notify end, 100)
end)

local function toggle_copilot()
	-- Toggle global variable
	vim.g.copilot_enabled = not vim.g.copilot_enabled

	if vim.g.copilot_enabled then
		require("copilot.command").enable()
		vim.api.nvim_echo({ { "  Copilot Enabled  ", "MoreMsg" } }, false, {})
	else
		require("copilot.command").disable()
		vim.api.nvim_echo({ { "  Copilot Disabled  ", "WarningMsg" } }, false, {})
	end
	vim.cmd("redrawstatus") -- Force immediate statusline update
end

vim.keymap.set("n", "<M-g>", toggle_copilot, { desc = "Toggle Copilot" })

-- [Copilot Chat]
require("CopilotChat").setup({
	model = "claude-opus-4.5",
	mappings = {
		reset = {
			normal = "<C-x>",
			insert = "<C-x>",
		},
	},
})

vim.keymap.set("n", "<leader>cc", "<cmd>CopilotChatToggle<cr>", { desc = "Toggle Copilot Chat" })
vim.keymap.set("v", "<leader>cc", "<cmd>CopilotChatToggle<cr>", { desc = "Toggle Copilot Chat" })
vim.keymap.set("n", "<leader>ce", "<cmd>CopilotChatExplain<cr>", { desc = "Explain code" })
vim.keymap.set("v", "<leader>ce", "<cmd>CopilotChatExplain<cr>", { desc = "Explain selection" })
vim.keymap.set("n", "<leader>cf", "<cmd>CopilotChatFix<cr>", { desc = "Fix code" })
vim.keymap.set("v", "<leader>cf", "<cmd>CopilotChatFix<cr>", { desc = "Fix selection" })

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
		default = { 'lsp', 'path', 'buffer' },
	},
	signature = { enabled = false },
})

-- [LSP CONFIG]
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if client and client:supports_method('textDocument/inlayHint') then
			vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
		end
	end,
})

vim.keymap.set('n', '<leader>h', function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
end, { desc = 'Toggle inlay hints' })

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

-- Format using LSP, fall back to external formatter
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
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	for _, client in ipairs(clients) do
		if client:supports_method('textDocument/formatting') then
			vim.lsp.buf.format()
			return
		end
	end

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
				version = 'LuaJIT',
				path = {
					'lua/?.lua',
					'lua/?/init.lua',
				},
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
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
