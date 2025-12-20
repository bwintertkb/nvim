return {
  "ctrlpvim/ctrlp.vim",
  init = function()
    -- We use 'init' because these global variables usually need to exist
    -- BEFORE the plugin is actually loaded.
    vim.g.ctrlp_user_command = {
      '.git/',
      'git --git-dir=%s/.git ls-files -oc --exclude-standard'
    }
  end
}
