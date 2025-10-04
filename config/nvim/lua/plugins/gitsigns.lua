return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("gitsigns").setup({
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      current_line_blame = true, -- enable blame inline
      current_line_blame_opts = {
        delay = 200,             -- how long before showing
        virt_text_pos = "eol",   -- "eol" | "overlay" | "right_align"
      },
      current_line_blame_formatter = "<author>, <author_time:%R> • <summary>",
    })
  end,
}

