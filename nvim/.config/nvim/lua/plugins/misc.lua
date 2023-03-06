return {
  -- Better comments
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = true,
  },

  -- Open file in last place
  { "farmergreg/vim-lastplace" },

  -- Indention
  { "lukas-reineke/indent-blankline.nvim" },

  -- Easy motion
  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    config = function()
      require("leap").add_default_mappings()
    end,
  },

  -- Better quickfix
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    cond = function() return false end,
  },

  -- Keybinding memorization help
  {
    "folke/which-key.nvim",
    config = function(_, _)
      vim.o.timeout = true
      vim.o.timeoutlen = 500
      local wk = require("which-key")
      wk.setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
      wk.register({
        ["<leader>s"] = { name = "+search" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>x"] = { name = "+trouble" },
        ["<leader>v"] = { name = "+view(lsp)" },
      })
    end,
  },
}
