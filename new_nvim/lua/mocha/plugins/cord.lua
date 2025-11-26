return {
  "vyfor/cord.nvim",
  config = function()
    require("cord").setup({
      auto_update = true,   -- automatically updates Discord presence
      show_file = true,     -- show the current file name
      show_branch = false,  -- hide git branch
      editor_icon = true,  -- hide Neovim icon
      workspace_text      = "Working on %s",
      enable_line_number  = true,
      line_number_text    = "Line %s out of %s",
    })
  end
}
