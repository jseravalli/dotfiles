return {
  ---------------------------------------------------------------------------
  -- 🤖 GitHub Copilot (Official Plugin)
  ---------------------------------------------------------------------------
  {
    "github/copilot.vim",
    lazy = false, -- Load immediately
    config = function()
      -- Accept Copilot suggestion with Tab
      vim.keymap.set('i', '<Tab>', function()
        -- Check if Copilot has a suggestion
        if vim.fn['copilot#GetDisplayedSuggestion']().text ~= '' then
          return vim.fn['copilot#Accept']("")
        else
          -- If no Copilot suggestion, check if blink menu is open
          local blink_ok, blink = pcall(require, "blink.cmp")
          if blink_ok and blink.is_visible() then
            blink.select_next()
            return ""
          end

          -- Otherwise, normal tab
          return "\t"
        end
      end, { expr = true, replace_keycodes = false, silent = true })

      -- Enable Copilot for all filetypes
      vim.g.copilot_filetypes = { ['*'] = true }
    end,
  },

  ---------------------------------------------------------------------------
  -- 🧠 Native LSP setup (Neovim ≥ 0.10)
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
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
        capabilities = {
          general = {
            positionEncodings = { "utf-16" },
          },
        },
      })

      vim.lsp.config("lua_ls", {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        settings = {
          Lua = { diagnostics = { globals = { "vim" } } },
        },
        capabilities = {
          general = {
            positionEncodings = { "utf-16" },
          },
        },
      })



      vim.lsp.config("biome", {
        cmd = { "biome", "lsp-proxy" }, -- Biome's LSP mode
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc" },
        root_markers = { "biome.json", "biome.jsonc", "package.json", "tsconfig.json", ".git" },
        capabilities = {
          general = {
            positionEncodings = { "utf-16" },
          },
        },
      })

      -----------------------------------------------------------------------
      -- ✅ Enable all LSPs (one call)
      -----------------------------------------------------------------------
      vim.lsp.enable({ "lua_ls", "tsserver", "biome" })

      -----------------------------------------------------------------------
      -- ⌨️ Snippet navigation (Copilot Tab is configured in copilot.vim section)
      -----------------------------------------------------------------------
      -- Note: Tab is handled by Copilot plugin (accepts suggestions or navigates blink menu)

      -- Note: Ctrl+Space and Shift+Tab are handled by blink.cmp keymap (see blink config below)

      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })

      -- Diagnostic keybindings
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic list" })

      vim.keymap.set("i", "<Esc>", function()
        -- Hide Blink completion if visible
        local blink_ok, blink = pcall(require, "blink.cmp")
        if blink_ok and blink.is_visible() then
          blink.hide()
        end

        -- Normal escape behavior
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
          "n",
          true
        )
      end, { silent = true, desc = "Hide completion or Escape" })
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
    dependencies = {
      "onsails/lspkind.nvim",
    },
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
          providers = {
            lsp = {
              name = "LSP",
              module = "blink.cmp.sources.lsp",
              score_offset = 0,
            },
          },
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
          preset = "enter",
          ["<CR>"] = { "accept", "fallback" },
          ["<Up>"] = { "select_prev", "fallback" },
          ["<Down>"] = { "select_next", "fallback" },
          ["<S-Tab>"] = { "select_prev", "fallback" },
          ["<C-n>"] = { "show", "show", "show" },
          ["<C-space>"] = { "show", "show", "show" },
          ["<C-e>"] = { "hide", "fallback" },
        },
      }
    end,
    config = function(_, opts)
      require("blink.cmp").setup(opts)
    end,
  },
}
