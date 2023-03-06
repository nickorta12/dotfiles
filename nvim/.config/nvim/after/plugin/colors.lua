local function set_color(color)
  color = color or "onedark"

  if color == "breezy" then
    vim.opt.bg = "light"
  end

  if color == "rose-pine" then
    require("rose-pine").setup({})
  end

  vim.cmd.colorscheme(color)
  vim.cmd.colorscheme(color)
end

vim.api.nvim_create_user_command("Color", function(args)
  set_color(args["args"])
end, { nargs = 1, complete = "color" })

set_color()
