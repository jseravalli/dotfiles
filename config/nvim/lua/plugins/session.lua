return {
  "rmagatti/auto-session",
  lazy = false,
  opts = {
    -- Save sessions in the project folder instead of the default location
    auto_session_root_dir = vim.fn.getcwd() .. "/.nvim/",

    -- Manual save only (don't auto save on exit)
    auto_save = false,

    -- Auto restore session on startup if session exists in folder
    auto_restore = true,

    -- Don't auto create new session files
    auto_create = false,

    -- Don't auto save/restore in certain dirs
    suppressed_dirs = { "~/", "~/Downloads", "/" },

    -- Use git branch name in session files
    auto_session_use_git_branch = false,

    -- What to save in session
    auto_session_enable_last_session = false,

    -- Log level
    log_level = "error",

    -- Bypass session save/restore for Neo-tree
    bypass_session_save_file_types = { "neo-tree" },

    -- Close Neo-tree before saving
    pre_save_cmds = {
      "Neotree close",
    },

    -- Auto-refresh rainbow brackets after session restore
    post_restore_cmds = {
      function()
        -- Delay the buffer reload to let treesitter fully initialize
        vim.defer_fn(function()
          vim.cmd("bufdo e")
        end, 200)
      end,
    },
  },
  config = function(_, opts)
    -- Set sessionoptions to properly save/restore buffers
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

    require("auto-session").setup(opts)

    -- Keymaps for manual session management (using new AutoSession commands)
    vim.keymap.set("n", "<leader>ss", "<cmd>AutoSession save<CR>", { desc = "Save session" })
    vim.keymap.set("n", "<leader>sr", "<cmd>AutoSession restore<CR>", { desc = "Restore session" })
    vim.keymap.set("n", "<leader>sd", "<cmd>AutoSession delete<CR>", { desc = "Delete session" })
    vim.keymap.set("n", "<leader>sf", "<cmd>AutoSession search<CR>", { desc = "Search sessions" })

    -- Create command to refresh rainbow brackets and indent lines after session restore
    vim.api.nvim_create_user_command("RefreshRainbow", function()
      vim.cmd("bufdo e")
    end, { desc = "Refresh rainbow brackets and indent lines" })

    vim.keymap.set("n", "<leader>rr", "<cmd>RefreshRainbow<CR>", { desc = "Refresh rainbow" })
  end,
}
