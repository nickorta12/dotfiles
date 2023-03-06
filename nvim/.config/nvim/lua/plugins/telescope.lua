-- vim.keymap.set("n", "<leader>pv", ":Telescope file_browser<CR>", { desc = "File explorer" })
-- Telescope popups and searching
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },

    -- Better netrw
    { "nvim-telescope/telescope-file-browser.nvim" },
  },
  keys = {
    {
      "<leader>sf",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "Search files",
    },
    {
      "<leader>sg",
      function()
        require("telescope.builtin").git_files()
      end,
      desc = "Search git",
    },
    {
      "<leader>sa",
      function()
        require("telescope.builtin").find_files({ follow = true, no_ignore = true, hidden = true })
      end,
      desc = "Search all",
    },
    {
      "<leader>sz",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find()
      end,
      desc = "Search all",
    },
    {
      "<leader>sr",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Search by ripgrep",
    },
    {
      "<leader>sb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Search buffers",
    },
    {
      "<leader>sh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Search help",
    },
    {
      "<leader>sd",
      function()
        require("telescope.builtin").diagnostics()
      end,
      desc = "Search diagnostics",
    },
    {
      "<leader>sc",
      function()
        require("telescope.builtin").commands()
      end,
      desc = "Search commands",
    },
    {
      "<leader>i",
      function()
        require("telescope.builtin").lsp_document_symbols()
      end,
      { desc = "Search document symbols" },
    },
    {
      "<leader>I",
      function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols()
      end,
      { desc = "Search workspace symbols" },
    },
    {
      "<leader>sw",
      function()
        require("telescope.builtin").grep_string()
      end,
      desc = "Search by word",
    },
    {
      "<leader>sk",
      function()
        require("telescope.builtin").keymaps()
      end,
      desc = "Search keymaps",
    },
    {
      "<leader>so",
      function()
        require("telescope.builtin").oldfiles()
      end,
      desc = "Search oldfiles",
    },
    { "<leader>st", ":Telescope builtin<CR>", desc = "Search Telescope builtins" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      extensions = {
        file_browser = {
          hijack_netrw = false,
        },
      },
    })
    telescope.load_extension("file_browser")
  end,
}
