local settings = {
  -- WezTerm
  scheme = "Gruvbox dark, medium (base16)",

  -- Neovim
  plugin = {
     'sainnhe/gruvbox-material',
     lazy = false,
     priority = 1000,
     config = function()
       vim.g.gruvbox_material_enable_italic = true
       vim.cmd.colorscheme('gruvbox-material')
     end
  }
}

return settings
