return {
  -- Disabled mini.indentscope in favor of indent-blankline scope with rainbow colors
  -- {
  --   "echasnovski/mini.indentscope",
  --   version = false,
  --   event = "VeryLazy",
  --   config = function()
  --     -- Set a single nice color for the current scope line (Tokyo Night purple)
  --     vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#bb9af7" })
  --
  --     require("mini.indentscope").setup({
  --       symbol = "│",
  --       options = { try_as_border = true },
  --       draw = {
  --         delay = 0,
  --         animation = require("mini.indentscope").gen_animation.none(),
  --       },
  --     })
  --     -- Disable for certain filetypes
  --     vim.api.nvim_create_autocmd("FileType", {
  --       pattern = {
  --         "help",
  --         "neo-tree",
  --         "Trouble",
  --         "trouble",
  --         "lazy",
  --         "mason",
  --         "notify",
  --         "toggleterm",
  --       },
  --       callback = function()
  --         vim.b.miniindentscope_disable = true
  --       end,
  --     })
  --   end,
  -- },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    priority = 200,
    config = function()
      local highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterGreen",
        "RainbowDelimiterCyan",
        "RainbowDelimiterBlue",
        "RainbowDelimiterViolet",
      }

      -- Define highlight groups for rainbow-delimiters (Tokyo Night Moon)
      vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#ff757f" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#ffc777" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#c3e88d" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#89ddff" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#82aaff" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#c099ff" })

      -- Configure rainbow-delimiters to use these highlights
      vim.g.rainbow_delimiters = { highlight = highlight }
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "VeryLazy",
    priority = 100,
    dependencies = {
      "HiPhish/rainbow-delimiters.nvim",
    },
    config = function()
      local highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterGreen",
        "RainbowDelimiterCyan",
        "RainbowDelimiterBlue",
        "RainbowDelimiterViolet",
      }

      require("ibl").setup({
        indent = {
          char = "▏",
        },
        scope = {
          enabled = true,
          show_start = false,
          show_end = false,
          include = {
            node_type = { ["*"] = { "*" } },
          },
          highlight = highlight,
        },
      })

      local hooks = require("ibl.hooks")
      -- Use rainbow-delimiters to determine scope color
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
}
