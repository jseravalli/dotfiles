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
          hijack_netrw_behavior = "open_default",
        },
      })

      -- Auto-restore session and then open Neo-tree on startup
      vim.api.nvim_create_autocmd("VimEnter", {
        nested = true,
        callback = function()
          -- Only auto-restore if no files were passed as arguments
          if vim.fn.argc() == 0 then
            vim.defer_fn(function()
              local session_dir = vim.fn.getcwd() .. "/.nvim/"
              local session_files = vim.fn.glob(session_dir .. "*.vim", false, true)

              -- If a session exists, restore it
              if #session_files > 0 then
                vim.cmd("SessionRestore")

                -- Wait a bit for buffers to load, then open Neo-tree
                vim.defer_fn(function()
                  vim.cmd("Neotree show")
                end, 200)
              else
                -- No session, just open Neo-tree
                vim.cmd("Neotree show")
              end
            end, 50)
          end
        end,
      })

      -- ⌘+E to toggle Neo-tree (requires wezterm keymap trick to send Ctrl+E)
      vim.keymap.set("n", "<C-e>", ":Neotree toggle<CR>", { silent = true, desc = "Toggle Neo-tree" })
      vim.keymap.set("n", "<leader>e", ":Neotree source=filesystem reveal=true<CR>", { silent = true, desc = "Reveal Neo-tree" })
    end,
  },
}

