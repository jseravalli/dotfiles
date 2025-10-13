vim.opt.number = true -- Show absolute line numbers
-- Enable truecolor support
vim.opt.termguicolors = true

-- Show special characters
vim.opt.list = true
vim.opt.listchars = {
  tab = "→ ",      -- Show tabs as →
  space = "·",     -- Show spaces as ·
  trail = "•",     -- Show trailing spaces as •
  eol = "↲",       -- Show end of line as ↲
  extends = "⟩",   -- Show when line continues beyond screen
  precedes = "⟨",  -- Show when line starts before screen
  nbsp = "␣",      -- Show non-breaking spaces
}

-- Global default
vim.opt.tabstop = 2      -- A Tab character looks like 2 spaces
vim.opt.shiftwidth = 2   -- >> indents by 2 spaces
vim.opt.softtabstop = 2  -- <Tab> in insert mode counts as 2 spaces
vim.opt.expandtab = true -- Convert tabs to spaces

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.ts", "*.tsx", "*.js", "*.lua", "*.py" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
