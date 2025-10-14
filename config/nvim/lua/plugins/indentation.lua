return {
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = "VeryLazy",
    config = function()
      -- Set a single nice color for the current scope line (Tokyo Night purple)
      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#bb9af7" })

      require("mini.indentscope").setup({
        symbol = "│",
        options = { try_as_border = true },
        draw = {
          delay = 0,
          animation = require("mini.indentscope").gen_animation.none(),
        },
      })
      -- Disable for certain filetypes
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "VeryLazy",
    opts = {
      indent = {
        char = "│",
      },
      scope = {
        enabled = false,
      },
    },
  },
}
