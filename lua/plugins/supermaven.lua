return {
  "supermaven-inc/supermaven-nvim",
  config = function()
    local supermaven = require("supermaven-nvim")
    
    supermaven.setup({
      keymaps = {
        accept_suggestion = "<Tab>",
        clear_suggestion = "<C-]>",
        accept_word = "<C-j>",
      },
      ignore_filetypes = {},
      color = {
        suggestion_color = "#ffffff",
        cterm = 244,
      },
      log_level = "info",
      disable_inline_completion = true, -- Disabled because you are using Blink!
      disable_keymaps = false,
      condition = function() return false end
    })

    -- Toggle Logic
    local function echo_temp(msg)
      vim.api.nvim_echo({ { msg, "None" } }, false, {})
      vim.defer_fn(function() vim.api.nvim_echo({ { '' } }, false, {}) end, 2000)
    end

    local is_enabled = true
    local function supermaven_toggle()
      is_enabled = not is_enabled
      if is_enabled then
        vim.cmd('SupermavenStart')
        echo_temp("Supermaven enabled")
      else
        vim.cmd('SupermavenStop')
        echo_temp("Supermaven disabled")
      end
    end

    vim.keymap.set('n', '<leader>G', supermaven_toggle, { noremap = true, silent = true })
  end
}
