local settings = {
  -- WezTerm
  scheme = "Catppuccin Macchiato",

  -- Neovim
  plugin = {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato"
      })
      vim.cmd.colorscheme "catppuccin"
    end,
  }
}

return settings
