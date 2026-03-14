return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    config = function()
      local fzf = require("fzf-lua")
      local actions = fzf.actions

      fzf.setup({
        winopts = {
          width = 0.95,
          height = 0.95,
          preview = {
            layout = "flex",
            flip_columns = 120,
          },
        },
        keymap = {
          builtin = {
            ["?"] = "toggle-preview",
            ["ctrl-/"] = "toggle-help",
            ["ctrl-d"] = "preview-page-down",
            ["ctrl-u"] = "preview-page-up",
          },
          fzf = {
            ["ctrl-d"] = "preview-page-down",
            ["ctrl-u"] = "preview-page-up",
            ["ctrl-q"] = "select-all+accept",
          },
        },
        actions = {
          files = {
            true, -- inherit defaults
            ["ctrl-h"] = actions.file_split,
            ["ctrl-v"] = actions.file_vsplit,
            ["ctrl-b"] = function(selected, opts)
              actions.file_sel_to_qf(selected, opts)
              vim.cmd("Trouble qflist toggle")
            end,
          },
        },
        files = {
          cwd_prompt = true,
          hidden = true,
          follow = true,
          no_ignore = false,
          rg_opts = [[--color=never --hidden --files --follow --ignore-case -g "!.git" -g "!backup"]],
        },
        grep = {
          hidden = true,
          no_ignore = false,
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --ignore-case -g '!.git' -g '!backup' -e",
          rg_glob = true, -- enable glob parsing (e.g. "foo -- -g*.lua")
        },
        oldfiles = {
          cwd_only = true,
        },
        lsp = {
          async_or_timeout = 5000,
          jump1 = true,
        },
        dap = {},
      })

      fzf.register_ui_select()
    end,
  },
}
