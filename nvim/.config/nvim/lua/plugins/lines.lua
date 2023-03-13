return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = true,
    cond = function()
      return not vim.g.vscode
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "v3.*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        separator_style = "thin",
      },
    },
    keys = {
      { "<leader>n", "<cmd>BufferLinePick<CR>",      desc = "Pick buffer" },
      { "<leader>N", "<cmd>BufferLinePickClose<CR>", desc = "Pick close buffer" },
    },
    cond = function()
      return not vim.g.vscode
    end,
  },
}
