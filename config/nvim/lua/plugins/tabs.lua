return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",          -- show buffers as tabs
          diagnostics = "nvim_lsp",  -- show LSP error/warning indicators
          separator_style = "slant", -- "slant" | "thick" | "thin" | { 'any', 'any' }
          show_close_icon = false,
          show_buffer_close_icons = true,
          always_show_bufferline = true,
          offsets = {
            {
              filetype = "neo-tree",
              text = "Explorer",
              highlight = "Directory",
              separator = true,
            },
          },
        },
      })

      -- Keymaps for cycling between buffers
      vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", { silent = true, desc = "Next buffer" })
      vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>", { silent = true, desc = "Previous buffer" })

      -- Close buffer with leader+c
      vim.keymap.set("n", "<leader>c", ":bdelete<CR>", { silent = true, desc = "Close buffer" })
    end,
  },
}

