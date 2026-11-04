local settings = {
  -- WezTerm
  scheme = "Ayu Dark (Gogh)",

  -- Neovim
  plugin = {
    'Shatur/neovim-ayu',
    lazy = false,
    priority = 1000,
    config = function()
      require('ayu').setup({
        mirage = false,
        terminal = true,
      })
      vim.cmd.colorscheme('ayu-dark')
    end
  }
}

return settings
