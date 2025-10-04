return {
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      -- autocompletion
      require("mini.completion").setup({})
      -- optional snippets
      require("mini.snippets").setup({})

      -- keymaps when an LSP attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local bufmap = function(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, { buffer = event.buf })
          end
          bufmap("n", "gd", vim.lsp.buf.definition)
          bufmap("n", "K", vim.lsp.buf.hover)
          bufmap("n", "gr", vim.lsp.buf.references)
          bufmap("n", "<leader>rn", vim.lsp.buf.rename)
          bufmap("n", "<leader>ca", vim.lsp.buf.code_action)
          bufmap({ "i", "s" }, "<C-s>", vim.lsp.buf.signature_help)
        end,
      })


      -- TypeScript (ts/tsx/js/jsx)
      vim.lsp.config("tsserver", {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        root_markers = { "package.json", "tsconfig.json" },
      })

      -- Lua
      vim.lsp.config("lua_ls", {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { "lua" },
        settings = {
          Lua = { diagnostics = { globals = { "vim" } } },
        },
      })

      -- enable servers you have installed manually
      vim.lsp.enable({ "lua_ls", "tsserver" })
    end,
  },
}

