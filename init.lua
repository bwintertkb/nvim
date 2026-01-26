vim.g.mapleader = " "
-- Map jk as escape key in insert mode
vim.api.nvim_set_keymap('i', 'jk', '<ESC>', { noremap = true })

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
    wrap = false,
    signcolumn = "no",
    cursorcolumn = false,
    foldcolumn = "0",
    spell = false,
    list = false,
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

vim.api.nvim_set_keymap('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

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
vim.api.nvim_set_hl(0, "Float",  { fg = "#9fb4c7" })
vim.api.nvim_set_hl(0, "Boolean",  { fg = "#9fb4c7" })
-- Comments: neutral grey
vim.api.nvim_set_hl(0, "Comment", { fg = "#8a8f93" })

local hl = vim.api.nvim_set_hl
hl(0, "@comment",               { link = "Comment" })
hl(0, "@string", { fg = "#a9b665" })
hl(0, "@number",                { link = "Number" })
hl(0, "@float",                 { link = "Float" })
hl(0, "@boolean",               { link = "Boolean" })
hl(0, "@keyword",               { link = "Keyword" })
hl(0, "@keyword.function",      { link = "Keyword" })
hl(0, "@keyword.return",        { link = "Keyword" })
hl(0, "@keyword.operator",      { link = "Keyword" })
hl(0, "@conditional",           { link = "Keyword" })
hl(0, "@repeat",                { link = "Keyword" })
hl(0, "@function",              { link = "Function" })
hl(0, "@function.call",         { link = "Function" })
hl(0, "@function.builtin",      { link = "Function" })
hl(0, "@method",                { link = "Function" })
hl(0, "@method.call",           { link = "Function" })
hl(0, "@type",                  { link = "Type" })
hl(0, "@type.builtin",          { link = "Type" })
hl(0, "@constant",              { link = "Constant" })
hl(0, "@constant.builtin",      { link = "Constant" })
hl(0, "@field",                 { link = "Identifier" })
hl(0, "@parameter",             { link = "Identifier" })
hl(0, "@operator",              { link = "Operator" })
hl(0, "@punctuation",           { link = "Delimiter" })
hl(0, "@punctuation.bracket",   { link = "Delimiter" })
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

-- [END OF LINE HINTS]
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



-- [LSP CONFIG]
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

-- On attach: enable completion
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    
    -- Inlay hints
    if client and client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
    
    -- Completion (your existing code)
    if client and client:supports_method('textDocument/completion') then
      local triggers = client.server_capabilities.completionProvider.triggerCharacters or {}
      for c = string.byte('a'), string.byte('z') do
        table.insert(triggers, string.char(c))
      end
      for c = string.byte('A'), string.byte('Z') do
        table.insert(triggers, string.char(c))
      end
      client.server_capabilities.completionProvider.triggerCharacters = triggers
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})

vim.keymap.set('n', '<leader>h', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
end, { desc = 'Toggle inlay hints' })

-- Completion menu navigation
vim.keymap.set('i', '<Tab>', function()
  return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
end, { expr = true })

vim.keymap.set('i', '<S-Tab>', function()
  return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
end, { expr = true })

vim.keymap.set('i', '<Space>', function()
  if vim.fn.pumvisible() == 1 then
    local info = vim.fn.complete_info({ 'selected' })
    if info.selected >= 0 then
      return '<C-y>'
    end
  end
  return '<Space>'
end, { expr = true })

-- Completion options
vim.opt.completeopt = { 'menuone', 'noselect', 'popup' }
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
