vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- LSP keymaps (using Telescope for better UI)
vim.keymap.set("n", "gd", function()
  require("telescope.builtin").lsp_definitions()
end, { desc = "Go to definition (Telescope)" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gr", function()
  require("telescope.builtin").lsp_references()
end, { desc = "Go to references (Telescope)" })
vim.keymap.set("n", "gi", function()
  require("telescope.builtin").lsp_implementations()
end, { desc = "Go to implementation (Telescope)" })
vim.keymap.set("n", "gt", function()
  require("telescope.builtin").lsp_type_definitions()
end, { desc = "Go to type definition (Telescope)" })
vim.keymap.set("n", "K", function()
  vim.lsp.buf.hover({ border = "rounded" })
end, { desc = "Hover documentation" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostics" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Format buffer
vim.keymap.set("n", "<leader>F", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer" })

-- Save file
vim.keymap.set("n", "<C-s>", ":w<CR>", { silent = true, desc = "Save file" })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { silent = true, desc = "Save file" })

-- Quit Neovim
vim.keymap.set("n", "<leader>q", ":qa<CR>", { silent = true, desc = "Quit all" })
vim.keymap.set("n", "<leader>Q", ":qa!<CR>", { silent = true, desc = "Force quit all (no save)" })

-- Open URL under cursor in browser (macOS)
local function open_url()
  local url = vim.fn.expand("<cfile>")
  if url:match("^https?://") then
    vim.fn.jobstart({ "open", url }, { detach = true })
    return true
  end
  return false
end

vim.keymap.set("n", "gx", open_url, { desc = "Open URL in browser" })

-- Single click to open URL (works in normal and visual mode)
vim.keymap.set({ "n", "v" }, "<LeftMouse>", function()
  -- Exit visual mode if in visual mode
  if vim.fn.mode():match("[vV\22]") then
    vim.cmd("normal! \27") -- ESC to exit visual mode
  end

  -- Move cursor to mouse position first
  local mouse_pos = vim.fn.getmousepos()
  if mouse_pos.winid ~= 0 and mouse_pos.line > 0 then
    local buf = vim.api.nvim_win_get_buf(mouse_pos.winid)
    local line_count = vim.api.nvim_buf_line_count(buf)

    -- Validate cursor position is within buffer bounds
    if mouse_pos.line <= line_count then
      vim.api.nvim_set_current_win(mouse_pos.winid)

      -- Get the line and validate column position
      local line = vim.api.nvim_buf_get_lines(buf, mouse_pos.line - 1, mouse_pos.line, false)[1] or ""
      local col = math.min(mouse_pos.column - 1, #line)

      pcall(vim.api.nvim_win_set_cursor, mouse_pos.winid, { mouse_pos.line, col })

      -- Check if we clicked on a URL and open it
      if not open_url() then
        -- If not a URL, do normal click behavior
        -- This allows normal clicking to still work
      end
    end
  end
end, { desc = "Click to open URL or move cursor" })

