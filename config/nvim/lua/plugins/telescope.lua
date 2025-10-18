return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  -- or                              , branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep' },
  config = function()
    local builtin = require('telescope.builtin')
    local telescope = require('telescope')

    -- Configure Telescope with better defaults
    telescope.setup({
      defaults = {
        border = true,
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        wrap_results = true, -- Wrap long lines instead of truncating
      },
    })

    -- LSP document symbols (classes, methods, functions in current file)
    vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Find symbols in current file' })

    -- Custom diagnostic viewer with full messages
    vim.keymap.set('n', '<leader>d', function()
      -- Get diagnostics at current position
      local diags = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })

      if #diags == 0 then
        -- No diagnostics at cursor, show all buffer diagnostics in Telescope
        builtin.diagnostics({ bufnr = 0 })
      else
        -- Show full diagnostic message in a floating window
        vim.diagnostic.open_float({
          border = "rounded",
          source = "always", -- Show source (clippy, rustc)
          scope = "line", -- Show all diagnostics on the line
          header = "",
          prefix = function(diagnostic, i, total)
            local severity = diagnostic.severity
            local icon = severity == 1 and " " or
                severity == 2 and " " or
                severity == 3 and " " or " "
            return string.format("%s [%d/%d] ", icon, i, total)
          end,
          format = function(diagnostic)
            -- Return the FULL message without truncation
            return diagnostic.message
          end,
          max_width = math.floor(vim.o.columns * 0.8),
          max_height = math.floor(vim.o.lines * 0.6),
          wrap = true, -- Wrap long messages
          focus = false,
        })
      end
    end, { desc = 'Show diagnostic at cursor or all diagnostics' })

    -- All workspace diagnostics in Telescope
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Show all diagnostics (Telescope)' })
  end,
}
