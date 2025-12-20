return {
  "chrisgrieser/nvim-lsp-endhints",
  event = "LspAttach",
  opts = {
    icons = {
      type = "=> ",
      parameter = "<- ",
      off = " ",
      on = " ",
    },
    label = {
      padding = 1,
      marginLeft = 0,
      bracketedParameters = true,
    },
    autoEnableHints = true, -- Automatically enable hints on startup
	toggleHints = "always"
  }
}
