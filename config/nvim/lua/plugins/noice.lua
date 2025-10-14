return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify", -- Optional: for better notifications
  },
  opts = {
    -- Configure command line popup at the bottom
    cmdline = {
      enabled = true,
      view = "cmdline_popup", -- Popup style (not classic)
      format = {
        cmdline = { pattern = "^:", icon = ":", lang = "vim" },
        search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
        filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
        lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
        help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
      },
    },
    -- Position ALL views at bottom center
    views = {
      cmdline_popup = {
        position = {
          row = "95%", -- Bottom of screen
          col = "50%", -- Center
        },
        size = {
          width = 60,
          height = "auto",
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          scrolloff = 8, -- Keep 8 lines above cursor visible
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = "88%", -- Above command line
          col = "50%", -- Center
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
      },
      cmdline_input = {
        position = {
          row = "95%", -- Bottom center
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
      },
      confirm = {
        position = {
          row = "95%", -- Bottom center
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
      },
    },
    -- Messages and command line popup
    messages = {
      enabled = true,
      view = "notify", -- Use notify for messages
      view_error = "notify",
      view_warn = "notify",
      view_history = "messages",
      view_search = false, -- Use default Vim search highlighting
    },
    -- Popupmenu (completion menu)
    popupmenu = {
      enabled = true,
      backend = "nui", -- Use nui for popup menu
    },
    -- LSP progress and hover
    lsp = {
      progress = {
        enabled = true,
        format = "lsp_progress",
        format_done = "lsp_progress_done",
        view = "mini",
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      hover = {
        enabled = true,
        silent = false,
      },
      signature = {
        enabled = true,
        auto_open = {
          enabled = true,
          trigger = true,
          luasnip = true,
          throttle = 50,
        },
      },
      message = {
        enabled = true,
      },
    },
    -- Presets for easier configuration
    presets = {
      bottom_search = false, -- Use classic bottom search
      command_palette = true, -- Position cmdline and popupmenu together
      long_message_to_split = true, -- Long messages in a split
      inc_rename = false, -- Enables an input dialog for inc-rename.nvim
      lsp_doc_border = true, -- Add border to hover docs and signature help
    },
    -- Routes for specific message handling
    routes = {
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true }, -- Skip "written" messages
      },
    },
  },
}
