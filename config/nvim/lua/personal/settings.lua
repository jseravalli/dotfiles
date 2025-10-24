vim.opt.number = true -- Show absolute line numbers
vim.opt.signcolumn = "yes" -- Always show sign column for git signs
-- Enable truecolor support
vim.opt.termguicolors = true

-- Enable mouse support
vim.opt.mouse = "a"

-- Faster cursor movement and scrolling
vim.opt.timeoutlen = 300      -- Faster key sequence timeout (default 1000ms)
vim.opt.updatetime = 250       -- Faster completion and diagnostic updates (default 4000ms)
vim.opt.scrolloff = 8          -- Keep 8 lines visible above/below cursor
vim.opt.sidescrolloff = 8      -- Keep 8 columns visible left/right of cursor

-- Set up hover window highlight groups (make it stand out)
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1a1b26", fg = "#c0caf5" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1a1b26", fg = "#7aa2f7" })

-- LSP hover and signature help styling with proper highlights
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
  max_width = 80,
  max_height = 20,
  focusable = true,
  focus = false,
  close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
  max_width = 80,
  max_height = 20,
  focusable = true,
  focus = false,
})

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

-- Always use the system clipboard
vim.opt.clipboard = "unnamedplus"

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})


vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.ts", "*.tsx", "*.js", "*.lua", "*.py" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
