vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- keymap example
vim.keymap.set("n", "<leader>F", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer" })

