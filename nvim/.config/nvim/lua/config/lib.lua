M = {}

function M.indent(num)
  vim.opt.tabstop = num
  vim.opt.softtabstop = num
  vim.opt.shiftwidth = num
end

function M.desc(o, desc)
  o = vim.deepcopy(o)
  o.desc = desc
  return o
end

return M
