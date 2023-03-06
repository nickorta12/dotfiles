local set = vim.keymap.set

-- set("v", "J", ":m '>+1<CR>gv=gv")
-- set("v", "K", ":m '<-2<CR>gv=gv")

set("n", "J", "mzJ`z")
set("n", "<C-d>", "<C-d>zz")
set("n", "<C-u>", "<C-u>zz")
set("n", "n", "nzzzv")
set("n", "N", "Nzzzv")

set("x", "<leader>p", [["_dP]], { desc = "Delete w/o copy" })

set({ "n", "v" }, "<leader>y", [["+y]])
set("n", "<leader>Y", [["+Y]])

set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete w/o copy" })

set("n", "Q", "<nop>", { desc = "NOP" })
set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
set("n", "<leader>fm", vim.lsp.buf.format, { desc = "LSP format document" })

set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Display next error" })
set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Display prev error" })
set("n", "<leader>k", "<cmd>lnext<CR>zz")
set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
-- { desc = "Search and replace word" })
-- set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make executable", silent = true })

set("n", "H", ":bp<CR>", { desc = "Prev buffer" })
set("n", "L", ":bn<CR>", { desc = "Next buffer" })
set("n", "<leader>bn", ":bn<CR>", { desc = "Next buffer" })
set("n", "<leader>bp", ":bp<CR>", { desc = "Prev buffer" })
set("n", "<leader>bd", ":bd<CR>", { desc = "Close buffer" })
set("n", "<leader>bD", ":bd!<CR>", { desc = "Force close buffer" })
set("n", "<leader>bl", ":ls<CR>", { desc = "List buffers" })

set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Trouble Toggle" })
set(
  "n",
  "<leader>xw",
  "<cmd>TroubleToggle workspace_diagnostics<cr>",
  { desc = "Trouble Toggle workspace diagnostics" }
)
set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Trouble Toggle doc diagnostics" })
-- set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { desc = "Trouble Toggle loclist" })
-- set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { desc = "Trouble Toggle quickfix" })
set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { desc = "Trouble Toggle lsp references" })

-- Terminal mode
set("t", "<Esc>", [[<C-\><C-n>]])
