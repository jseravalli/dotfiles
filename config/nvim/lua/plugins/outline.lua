return {
  ---------------------------------------------------------------------------
  -- 📑 Aerial.nvim - Code outline sidebar with better mouse support
  ---------------------------------------------------------------------------
  {
    "stevearc/aerial.nvim",
    lazy = true,
    cmd = { "AerialToggle", "AerialOpen" },
    keys = {
      { "<leader>o", "<cmd>AerialToggle<CR>", desc = "Toggle outline" },
      { "<leader>O", "<cmd>AerialNavToggle<CR>", desc = "Toggle nav outline" },
    },
    opts = {
      -- Set how symbols are displayed
      layout = {
        min_width = 30,
        default_direction = "prefer_right",
      },
      -- Enable mouse support for clicking on symbols
      on_attach = function(bufnr)
        -- Jump to symbol on Enter
        vim.keymap.set("n", "<CR>", "<cmd>AerialNext<CR>", { buffer = bufnr })
        -- Navigate with h/l
        vim.keymap.set("n", "h", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "l", "<cmd>AerialNext<CR>", { buffer = bufnr })
      end,
      -- Close aerial on select
      close_on_select = false,
      -- Highlight the symbol when jumping
      highlight_on_jump = 300,
      -- Show treesitter symbols
      backends = { "lsp", "treesitter", "markdown", "man" },
      -- Filter what symbols to show
      filter_kind = {
        "Class",
        "Constructor",
        "Enum",
        "Function",
        "Interface",
        "Module",
        "Method",
        "Struct",
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
}
