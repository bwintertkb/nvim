vim.g.mapleader = " "

-- [Global general keymaps]
-- Map jk as escape key in insert mode
vim.api.nvim_set_keymap('i', 'jk', '<ESC>', { noremap = true })
-- H goes to first non-blank character, L goes to end of line
vim.api.nvim_set_keymap('n', 'H', '^', { noremap = true })
vim.api.nvim_set_keymap('n', 'L', '$', { noremap = true })
-- Better indenting in visual mode (stay in visual mode after indent)
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
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
vim.o.wildmenu = true
vim.o.wildmode = 'full'
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"
vim.o.autoindent = true
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.backspace = "indent,eol,start"

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
})

-- [File explorer]
require("oil").setup({
	default_file_explorer = true,
	columns = {
		"icon",
	},
	buf_options = {
		buflisted = false,
		bufhidden = "hide",
	},
	win_options = {
		signcolumn = "no",
		number = true,
		relativenumber = true,
		statuscolumn = "",
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
		["`"] = { "actions.cd", mode = "n" },
		["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
		["gs"] = { "actions.change_sort", mode = "n" },
		["gx"] = "actions.open_external",
		["g."] = { "actions.toggle_hidden", mode = "n" },
		["g\\"] = { "actions.toggle_trash", mode = "n" },
	},
	use_default_keymaps = true,
	view_options = {
		show_hidden = false,
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

-- [Visual wrap]
require("visual_wrap").setup()

-- [Theme]
-- Treesitter highlights
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

vim.o.termguicolors = true
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
-- Git branch function
local function git_branch()
	local branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
	if branch ~= "" then
		return "  " .. branch .. " "
	end
	return ""
end

-- File type with icon
local function file_type()
	local ft = vim.bo.filetype
	local icons = {
		lua = "[LUA]",
		python = "[PY]",
		javascript = "[JS]",
		html = "[HTML]",
		css = "[CSS]",
		json = "[JSON]",
		markdown = "[MD]",
		vim = "[VIM]",
		sh = "[SH]",
	}

	if ft == "" then
		return "  "
	end

	return (icons[ft] or ft)
end

-- File size
local function file_size()
	local size = vim.fn.getfsize(vim.fn.expand('%'))
	if size < 0 then return "" end
	if size < 1024 then
		return size .. "B "
	elseif size < 1024 * 1024 then
		return string.format("%.1fK", size / 1024)
	else
		return string.format("%.1fM", size / 1024 / 1024)
	end
end

-- Mode indicators with icons
local function mode_icon()
	local mode = vim.fn.mode()
	local modes = {
		n = "NORMAL",
		i = "INSERT",
		v = "VISUAL",
		V = "V-LINE",
		["\22"] = "V-BLOCK", -- Ctrl-V
		c = "COMMAND",
		s = "SELECT",
		S = "S-LINE",
		["\19"] = "S-BLOCK", -- Ctrl-S
		R = "REPLACE",
		r = "REPLACE",
		["!"] = "SHELL",
		t = "TERMINAL"
	}
	return (modes[mode] or "  ") .. mode:upper()
end

-- Diagnostic counts for statusline
local function diagnostics()
	local errors = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
	local warnings = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
	local parts = {}
	if #errors > 0 then
		local first_line = errors[1].lnum + 1 -- diagnostics are 0-indexed
		for _, e in ipairs(errors) do
			if e.lnum + 1 < first_line then
				first_line = e.lnum + 1
			end
		end
		parts[#parts + 1] = "%#StatusLineError# " .. #errors .. " (ln " .. first_line .. ")"
	end
	if #warnings > 0 then
		local first_line = warnings[1].lnum + 1
		for _, w in ipairs(warnings) do
			if w.lnum + 1 < first_line then
				first_line = w.lnum + 1
			end
		end
		parts[#parts + 1] = "%#StatusLineWarn# " .. #warnings .. " (ln " .. first_line .. ")"
	end
	if #parts > 0 then
		return table.concat(parts, " ") .. " %#StatusLine#"
	end
	return ""
end
_G.mode_icon = mode_icon
_G.git_branch = git_branch
_G.file_type = file_type
_G.file_size = file_size
_G.diagnostics = diagnostics

vim.cmd([[
  highlight StatusLineBold gui=bold cterm=bold
]])

vim.api.nvim_set_hl(0, "StatusLineError",
	{ fg = "#ff5555", bg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).bg, bold = true })
vim.api.nvim_set_hl(0, "StatusLineWarn",
	{ fg = "#f1fa8c", bg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).bg, bold = true })

-- Function to change statusline based on window focus
local function setup_dynamic_statusline()
	vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
		callback = function()
			vim.opt_local.statusline = table.concat {
				"  ",
				"%#StatusLineBold#",
				"%{%v:lua.mode_icon()%}",
				"%#StatusLine#",
				" │ %f %h%m%r",
				"%{%v:lua.git_branch()%}",
				" │ ",
				"%{%v:lua.file_type()%}",
				" | ",
				"%{%v:lua.file_size()%}",
				"%=",
				"%{%v:lua.diagnostics()%}",
				"%l:%c  %P ",
			}
		end
	})
	vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		callback = function()
			vim.opt_local.statusline = "  %f %h%m%r │ %{v:lua.file_type()} | %=  %l:%c   %P "
		end
	})
end

setup_dynamic_statusline()

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
			auto_show = true,
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
	signature = { enabled = true },
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
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.document_symbol()<cr>')
vim.keymap.set('n', 'gw', '<cmd>lua vim.lsp.buf.workspace_symbol()<cr>')
vim.keymap.set('n', '[x', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
vim.keymap.set('n', ']x', '<cmd>lua vim.diagnostic.goto_next()<cr>')
vim.keymap.set('n', ']s', '<cmd>lua vim.diagnostic.open_float()<cr>')
vim.keymap.set('n', '<leader>.', '<cmd>lua vim.lsp.buf.code_action()<cr>')
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
			semanticHighlighting = { enable = false },
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
