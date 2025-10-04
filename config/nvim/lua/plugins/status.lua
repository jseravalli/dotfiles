return {
  "feline-nvim/feline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local present, feline = pcall(require, "feline")
    if not present then return end

    -- Theme definitions from gist
    local theme = {
      aqua   = "#7AB0DF",
      bg     = "#1C212A",
      blue   = "#5FB0FC",
      cyan   = "#70C0BA",
      darkred = "#FB7373",
      fg     = "#C7C7CA",
      gray   = "#222730",
      green  = "#79DCAA",
      lime   = "#54CED6",
      orange = "#FFD064",
      pink   = "#D997C8",
      purple = "#C397D8",
      red    = "#F87070",
      yellow = "#FFE59E",
    }

    local mode_theme = {
      NORMAL   = theme.green,
      OP       = theme.cyan,
      INSERT   = theme.aqua,
      VISUAL   = theme.yellow,
      LINES    = theme.darkred,
      BLOCK    = theme.orange,
      REPLACE  = theme.purple,
      ["V-REPLACE"] = theme.pink,
      ENTER    = theme.pink,
      MORE     = theme.pink,
      SELECT   = theme.darkred,
      SHELL    = theme.cyan,
      TERM     = theme.lime,
      NONE     = theme.gray,
      COMMAND  = theme.blue,
    }

    -- Map internal mode codes to display letters
    local modes = setmetatable({
      ["n"] = "N",
      ["V"] = "V",
      ["i"] = "I",
      ["c"] = "C",
      ["R"] = "R",
      ["t"] = "T",
      -- plus other combos if needed
    }, {
      __index = function() return "-" end
    })

    -- Define components, adapted from gist but updated for new LSP API
    local component = {}

    component.vim_mode = {
      provider = function()
        local m = vim.api.nvim_get_mode().mode
        return modes[m] or m
      end,
      hl = function()
        return {
          fg = "bg",
          bg = require("feline.providers.vi_mode").get_mode_color(),
          style = "bold",
          name = "NeovimModeHLColor",
        }
      end,
      left_sep = "block",
      right_sep = "block",
    }

    component.git_branch = {
      provider = "git_branch",
      hl = { fg = "fg", bg = "bg", style = "bold" },
      left_sep = "block",
      right_sep = "",
    }

    component.git_add = {
      provider = "git_diff_added",
      hl = { fg = "green", bg = "bg" },
    }
    component.git_delete = {
      provider = "git_diff_removed",
      hl = { fg = "red", bg = "bg" },
    }
    component.git_change = {
      provider = "git_diff_changed",
      hl = { fg = "purple", bg = "bg" },
    }
    component.separator = {
      provider = "",
      hl = { fg = "bg", bg = "bg" },
    }

    component.diagnostic_errors = {
      provider = "diagnostic_errors",
      hl = { fg = "red" },
    }
    component.diagnostic_warnings = {
      provider = "diagnostic_warnings",
      hl = { fg = "yellow" },
    }
    component.diagnostic_hints = {
      provider = "diagnostic_hints",
      hl = { fg = "aqua" },
    }
    component.diagnostic_info = {
      provider = "diagnostic_info",
      hl = { fg = "fg" },
    }

    component.lsp = {
      provider = function()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then return "" end
        local status = vim.lsp.status()
        if status and status ~= "" then
          return status
        end
        return "לּ LSP"
      end,
      hl = function()
        local status = vim.lsp.status()
        return {
          fg = (status and status ~= "") and "yellow" or "green",
          bg = "gray",
          style = "bold",
        }
      end,
      left_sep = "",
      right_sep = "block",
    }

    component.file_type = {
      provider = {
        name = "file_type",
        opts = { filetype_icon = true },
      },
      hl = { fg = "fg", bg = "gray" },
      left_sep = "block",
      right_sep = "block",
    }

    component.scroll_bar = {
      provider = function()
        local chars = {
          " ", " ", " ", " ", " ", " ", " ", " ",
          " ", " ", " ", " ", " ", " ", " ", " ",
          " ", " ", " ", " ", " ", " ", " ", " ",
          " ", " ", " ", " ",
        }
        local cur = vim.api.nvim_win_get_cursor(0)[1]
        local total = vim.api.nvim_buf_line_count(0)
        local ratio = cur / total
        local pos = math.floor(ratio * #chars)
        local icon = chars[pos] or " "
        if pos <= 1 then icon = " TOP" end
        if pos >= #chars - 1 then icon = " BOT" end
        return icon
      end,
      hl = function()
        local cur = vim.api.nvim_win_get_cursor(0)[1]
        local total = vim.api.nvim_buf_line_count(0)
        local p = math.floor(cur / total * 100)
        local fg, style = "purple", nil
        if p <= 5 then fg, style = "aqua", "bold"
        elseif p >= 95 then fg, style = "red", "bold" end
        return { fg = fg, bg = "bg", style = style }
      end,
      left_sep = "block",
      right_sep = "block",
    }

    -- Setup from gist: right side only
    vim.api.nvim_set_hl(0, "StatusLine", { bg = theme.bg, fg = theme.aqua })
    feline.setup({
      components = {
        active = {
          {}, -- left (nothing)
          {}, -- middle
          {  -- right side
            component.vim_mode,
            component.file_type,
            component.lsp,
            component.git_branch,
            component.git_add,
            component.git_delete,
            component.git_change,
            component.separator,
            component.diagnostic_errors,
            component.diagnostic_warnings,
            component.diagnostic_info,
            component.diagnostic_hints,
            component.scroll_bar,
          },
        },
      },
      theme = theme,
      vi_mode_colors = mode_theme,
    })
  end,
}

