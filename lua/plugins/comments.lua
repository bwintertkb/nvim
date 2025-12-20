return {
  "terrortylor/nvim-comment",
  config = function()
    -- We explicitly require the module with an UNDERSCORE
    require('nvim_comment').setup()
  end
}
