return {
  "rmagatti/auto-session",
  lazy = false,
  opts = {
    -- Save sessions in the project folder instead of the default location
    auto_session_root_dir = vim.fn.getcwd() .. "/.nvim/",

    -- Manual save only (don't auto save on exit)
    auto_save = false,

    -- Don't auto restore - use manual restore with <leader>sr
    auto_restore = false,

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

    -- Don't reopen Neo-tree automatically
    post_restore_cmds = {},
  },
  config = function(_, opts)
    -- Set sessionoptions to properly save/restore buffers
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

    require("auto-session").setup(opts)

    -- Keymaps for manual session management
    vim.keymap.set("n", "<leader>ss", "<cmd>SessionSave<CR>", { desc = "Save session" })
    vim.keymap.set("n", "<leader>sr", "<cmd>SessionRestore<CR>", { desc = "Restore session" })
    vim.keymap.set("n", "<leader>sd", "<cmd>SessionDelete<CR>", { desc = "Delete session" })
    vim.keymap.set("n", "<leader>sf", "<cmd>SessionSearch<CR>", { desc = "Search sessions" })
  end,
}
