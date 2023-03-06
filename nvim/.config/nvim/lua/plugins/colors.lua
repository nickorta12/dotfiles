return {
  { "olimorris/onedarkpro.nvim" },
  {
    "sonph/onehalf",
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. "vim")
    end
  },
  {
    "fneu/breezy",
  },
  {
    "ayu-theme/ayu-vim",
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
  },
  {
    "EdenEast/nightfox.nvim",
  },
}
