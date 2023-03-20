return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>t", ":NeoTreeFocusToggle<CR>", { desc = "Toggle file tree" } },
  },
  opts = {
    follow_curent_file = true,
  },
  cond = function()
    return not vim.g.vscode
  end
}
