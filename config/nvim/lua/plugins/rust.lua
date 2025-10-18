-- Configure rustaceanvim BEFORE the plugin loads
vim.g.rustaceanvim = {
        -- LSP configuration
        server = {
          default_settings = {
            ['rust-analyzer'] = {
              -- Enable check on save for real-time linting
              checkOnSave = true,  -- Boolean: enable checking on save
              check = {
                command = "clippy",  -- Use clippy instead of cargo check
                -- Note: rust-analyzer already adds --all-targets, so we only add clippy-specific flags
                extraArgs = { "--", "-W", "clippy::all" },
              },
              -- Cargo settings
              cargo = {
                allFeatures = true,  -- Check with all features enabled
                loadOutDirsFromCheck = true,
                buildScripts = {
                  enable = true,
                },
              },
              -- Proc macro support
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
              -- Diagnostics - explicitly ensure unused warnings show
              diagnostics = {
                enable = true,
                disabled = {},  -- Don't disable any diagnostics
                warningsAsHint = {},  -- Don't treat warnings as hints (empty list = none)
                warningsAsInfo = {},  -- Don't treat warnings as info (empty list = none)
                experimental = {
                  enable = true,  -- Enable experimental diagnostics
                },
                styleLints = {
                  enable = true,  -- Enable style lints (includes unused code warnings)
                },
              },
              -- Inlay hints (optional but useful)
              inlayHints = {
                enable = true,
                chainingHints = {
                  enable = true,
                },
                parameterHints = {
                  enable = true,
                },
                typeHints = {
                  enable = true,
                },
              },
            },
          },
        },
  -- DAP (Debug Adapter Protocol) configuration
  dap = {
    -- Automatically load debug configurations from launch.json
    autoload_configurations = true,
  },
}

-- Ensure Neovim shows all diagnostic severities, including warnings
vim.diagnostic.config({
  virtual_text = {
    severity = vim.diagnostic.severity.HINT,  -- Show even hints (includes warnings)
  },
  signs = {
    severity = vim.diagnostic.severity.HINT,
  },
  underline = {
    severity = vim.diagnostic.severity.HINT,
  },
  float = {
    border = "rounded",  -- Rounded borders for diagnostic float
    source = "always",   -- Always show diagnostic source (e.g., "clippy", "rustc")
    header = "",         -- No header text
    prefix = "",         -- No prefix
    focusable = true,    -- Allow focusing the float window
    style = "minimal",   -- Minimal style
    max_width = 80,      -- Maximum width
    max_height = 20,     -- Maximum height
  },
  update_in_insert = false,
  severity_sort = true,
})

return {
  ---------------------------------------------------------------------------
  -- 🦀 Rustaceanvim - Modern Rust development in Neovim
  ---------------------------------------------------------------------------
  {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended: pin to major version
    lazy = false,   -- This plugin is already lazy
  },

  ---------------------------------------------------------------------------
  -- 📦 Crates.nvim - Cargo.toml dependency management
  ---------------------------------------------------------------------------
  {
    'saecki/crates.nvim',
    event = { "BufRead Cargo.toml" },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('crates').setup({
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
        completion = {
          cmp = {
            enabled = true,
          },
        },
      })
    end,
  },
}
