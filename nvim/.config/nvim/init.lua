-- vim.defer_fn(function()
--   pcall(require, "impatient")
-- end, 0)

-- nvim-tree recommends disabling netrw, VIM's built-in file explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "

-- local function open_nvim_tree(data)
--   -- buffer is a directory
--   local directory = vim.fn.isdirectory(data.file) == 1
--
--   if not directory then
--     return
--   end
--
--   -- change to the directory
--   vim.cmd.cd(data.file)
--
--   -- open the tree
--   require("nvim-tree.api").tree.open()
-- end
--
-- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")

require("config.set")
require("config.remap")

if vim.g.neovide then
  require("config.neovide")
end
