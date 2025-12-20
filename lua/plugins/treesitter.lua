return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,    -- Force load immediately (Essential for Telescope compatibility)
  priority = 900,  -- Load early, right after the theme
  
  config = function()
    -- Safety check: Ensure the module exists before running setup
    -- This prevents the "module not found" crash during first install
    local status_ok, configs = pcall(require, "nvim-treesitter.configs")
    if not status_ok then
      return
    end

    configs.setup({
      -- A list of parser names, or "all"
      -- We install the basics to ensure Telescope has what it needs
      ensure_installed = { 
        "c", "lua", "vim", "vimdoc", "query", "rust", "go", "markdown", "markdown_inline" 
      },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      auto_install = true,

      indent = {
        enable = true,
      },

      highlight = {
        enable = true,
        
        -- Disable treesitter for large files to prevent freezing
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,

        additional_vim_regex_highlighting = false,
      },
    })
  end
}
