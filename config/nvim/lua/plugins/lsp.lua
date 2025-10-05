return {
  ---------------------------------------------------------------------------
  -- 🤖 GitHub Copilot + native LSP setup (multi-line completions)
  ---------------------------------------------------------------------------
  {
    "copilotlsp-nvim/copilot-lsp",
    lazy = false,
    config = function()
      -----------------------------------------------------------------------
      -- 🧠 Native LSP configs (Neovim ≥ 0.10)
      -----------------------------------------------------------------------
      vim.lsp.config("tsserver", {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = {
          "typescript", "typescriptreact",
          "javascript", "javascriptreact",
        },
        root_markers = { "package.json", "tsconfig.json" },
      })

      vim.lsp.config("lua_ls", {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        settings = {
          Lua = { diagnostics = { globals = { "vim" } } },
        },
      })

      -----------------------------------------------------------------------
      -- 💡 Copilot LSP setup (multi-line completions via NES)
      -----------------------------------------------------------------------
      require("copilot-lsp").setup({
        server = {
          type = "nodejs",
          cmd = { "copilot-language-server", "--stdio" },
          settings = {
            advanced = {
              multilineCompletions = true, -- multi-line code blocks
              maxCompletions = 5,          -- multiple ideas at once
              inlineSuggestCount = 3,      -- inline options
              contextCount = 2500,         -- look at ~2.5k lines of context
              completionPreview = true,    -- let Blink preview them
              debounce = 40,               -- faster refresh
            },
          },
        },
        auto_attach = true,
        show_progress = true,
        model = "gpt-4o-mini", -- or "gpt-4o" if you have access
        nes = { enabled = true },
      })
      -----------------------------------------------------------------------
      -- ✅ Enable all LSPs (one call)
      -----------------------------------------------------------------------
      vim.lsp.enable({ "lua_ls", "tsserver", "copilot_ls" })

      -----------------------------------------------------------------------
      -- ⌨️ Smart Tab & Escape (Copilot > Blink > Snippet > Fallback)
      -----------------------------------------------------------------------
      vim.keymap.set("i", "<Tab>", function()
        -- Handle Copilot NES multiline suggestion
        if vim.b[vim.api.nvim_get_current_buf()].nes_state then
          require("blink.cmp").hide()
          require("copilot-lsp.nes").apply_pending_nes()
          require("copilot-lsp.nes").walk_cursor_end_edit()
          return
        end

        -- Copilot inline ghost text
        local ok, copilot = pcall(require, "copilot.suggestion")
        if ok and copilot.is_visible() then
          copilot.accept()
          vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<CR>", true, false, true),
            "n",
            true
          )
          return
        end

        -- Blink completion menu
        local blink_ok, blink = pcall(require, "blink.cmp")
        if blink_ok and blink.is_visible() then
          vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<Plug>(blink-cmp-next)", true, true, true),
            "n",
            true
          )
          return
        end

        -- Snippet jump
        if vim.snippet.active({ direction = 1 }) then
          vim.snippet.jump(1)
          return
        end

        -- Literal Tab fallback
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
          "n",
          true
        )
      end, { silent = true, desc = "Smart Tab (Copilot > Blink > Snippet > Tab)" })

      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })

      vim.keymap.set("i", "<Esc>", function()
        local ok, copilot = pcall(require, "copilot.suggestion")
        if ok and copilot.is_visible() then
          copilot.dismiss()
        else
          vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
            "n",
            true
          )
        end
      end, { silent = true, desc = "Dismiss Copilot or Escape" })
    end,
  },

  ---------------------------------------------------------------------------
  -- 🧩 Optional: lspkind icons
  ---------------------------------------------------------------------------
  {
    "onsails/lspkind.nvim",
    lazy = true,
  },

  ---------------------------------------------------------------------------
  -- ⚡ Blink (LSP + Copilot + snippets)
  ---------------------------------------------------------------------------
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = { "onsails/lspkind.nvim" },
    opts = function()
      local ok, lspkind = pcall(require, "lspkind")
      return {
        appearance = {
          use_nvim_cmp_as_default = true,
          kind_icons = ok and lspkind.presets.default or {},
          highlight_groups = {
            Copilot = { fg = "#6E738D", italic = true },
          },
        },
        completion = {
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 100,
            max_height = 20,
            max_width = 80,
            window = {
              border = "rounded",
              winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
            },
          },
          menu = {
            border = "rounded",
            scrollbar = true,
            winblend = 8,
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          },
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
        snippets = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        keymap = {
          preset = "super-tab",
          ["<Tab>"] = {
            function(cmp)
              if vim.b[vim.api.nvim_get_current_buf()].nes_state then
                cmp.hide()
                require("copilot-lsp.nes").apply_pending_nes()
                require("copilot-lsp.nes").walk_cursor_end_edit()
                return true
              end
            end,
            "accept",
            "snippet_forward",
            "fallback",
          },
        },
      }
    end,
    config = function(_, opts)
      require("blink.cmp").setup(opts)
    end,
  },
}
