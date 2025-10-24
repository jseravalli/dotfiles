return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local gitsigns = require("gitsigns")

    gitsigns.setup({
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      current_line_blame = true, -- enable blame inline
      current_line_blame_opts = {
        delay = 0,               -- show immediately
        virt_text_pos = "eol",   -- "eol" | "overlay" | "right_align"
      },
      current_line_blame_formatter = " <author>, <author_time:%R> • <summary>",

      -- Style blame popup to match blink.cmp
      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },

      on_attach = function(bufnr)
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Show full blame details in popup with blink-style borders
        map('n', '<leader>gb', function()
          gitsigns.blame_line({
            full = true,
            border = "rounded",
          })
        end, { desc = "View full git blame" })

        -- Toggle inline blame
        map('n', '<leader>gt', gitsigns.toggle_current_line_blame, { desc = "Toggle inline blame" })

        -- Open commit in browser (GitHub/GitLab)
        map('n', '<leader>go', function()
          -- Get the commit hash from the current line
          local blame = vim.fn.systemlist("git blame -L " .. vim.fn.line('.') .. "," .. vim.fn.line('.') .. " " .. vim.fn.expand('%'))
          if #blame > 0 then
            local commit_hash = vim.split(blame[1], ' ')[1]
            if commit_hash and commit_hash ~= "00000000" then
              -- Get the remote URL
              local remote_url = vim.fn.system("git config --get remote.origin.url"):gsub("\n", "")

              -- Convert SSH URL to HTTPS if needed
              remote_url = remote_url:gsub("git@github.com:", "https://github.com/")
              remote_url = remote_url:gsub("git@gitlab.com:", "https://gitlab.com/")
              remote_url = remote_url:gsub("%.git$", "")

              -- Build commit URL
              local commit_url = remote_url .. "/commit/" .. commit_hash

              -- Open in browser (macOS)
              vim.fn.system("open '" .. commit_url .. "'")
              print("Opening commit in browser: " .. commit_hash)
            end
          end
        end, { desc = "Open commit in browser" })

        -- Preview hunk
        map('n', '<leader>gp', gitsigns.preview_hunk, { desc = "Preview git hunk" })

        -- Navigate hunks
        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gitsigns.next_hunk() end)
          return '<Ignore>'
        end, { expr = true, desc = "Next git hunk" })

        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gitsigns.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true, desc = "Previous git hunk" })
      end,
    })
  end,
}
