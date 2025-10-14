return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "rmagatti/auto-session", -- Load session before Neo-tree
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          follow_current_file = true,
          hijack_netrw_behavior = "disabled", -- Let oil handle directory browsing
        },
      })

      -- ⌘+E to toggle Neo-tree (requires wezterm keymap trick to send Ctrl+E)
      vim.keymap.set("n", "<C-e>", ":Neotree toggle<CR>", { silent = true, desc = "Toggle Neo-tree" })
      vim.keymap.set("n", "<leader>e", ":Neotree source=filesystem reveal=true<CR>", { silent = true, desc = "Reveal Neo-tree" })
    end,
  },
}

