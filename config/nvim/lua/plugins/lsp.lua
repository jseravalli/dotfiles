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
          nerd_font_variant = "mono",
          kind_icons = ok and lspkind.presets.default or {},
        },
        completion = {
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 100,
            update_delay_ms = 50,
            treesitter_highlighting = true,
            window = {
              min_width = 10,
              max_width = 80,
              max_height = 20,
              border = "rounded",
              winblend = 0,
              winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
              scrollbar = true,
            },
          },
          menu = {
            min_width = 15,
            max_height = 10,
            border = "rounded",
            winblend = 8,
            scrollbar = true,
            scrolloff = 2,
            winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
          },
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
        signature = {
          enabled = true,
          trigger = {
            enabled = true,
            show_on_insert_on_trigger_character = true,
          },
          window = {
            min_width = 1,
            max_width = 80,
            max_height = 10,
            border = "rounded",
            winblend = 0,
            winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
            scrollbar = true,
          },
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
      -- Set custom highlight groups for Copilot
      vim.api.nvim_set_hl(0, "BlinkCmpKindCopilot", { fg = "#6E738D", italic = true })

      require("blink.cmp").setup(opts)
    end,
  },
}
