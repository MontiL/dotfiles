return {
  -- status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local config = {
        options = {
          icons_enabled = true,
          -- https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
          -- theme = 'molokai',
          --[[ theme = "wombat", ]]
          theme = "nord",
          --[[ theme = "gruvbox_dark", ]]
          --[[ section_separators = { left = "", right = "" }, ]]
          --[[ component_separators = { left = "", right = "" }, ]]
          section_separators = "",
          component_separators = "|",
          disabled_filetypes = {},
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            {
              "filename",
              file_status = true, -- displays file status (readonly status, modified status)
              path = 1,           -- 0 = just filename, 1 = relative path, 2 = absolute path
              "lsp_progress",
            },
          },
          lualine_x = {
            -- {
            -- show @recording
            -- require("noice").api.statusline.mode.get,
            -- cond = require("noice").api.statusline.mode.has,
            -- color = { fg = "#ff9e64" },
            -- },
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = {
                modified = "[+]",      -- Text to show when the file is modified.
                readonly = "[-]",      -- Text to show when the file is non-modifiable or readonly.
                unnamed = "[No Name]", -- Text to show for unnamed buffers.
                error = " ",
                warn = " ",
                info = " ",
                hint = " ",
              },
            },
            "encoding",
            "filetype",
          },
          -- lualine_y = { "progress" },
          -- lualine_z = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            {
              "filename",
              -- file_status = true, -- displays file status (readonly status, modified status)
              -- path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
            },
          },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = { "fugitive" },
      }

      -- Inserts a component in lualine_c at left section
      local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
      end

      -- -- Inserts a component in lualine_x ot right section
      -- local function ins_right(component)
      --   table.insert(config.sections.lualine_x, component)
      -- end

      -- Color for highlights
      local colors = {
        yellow = "#ECBE7B",
        cyan = "#008080",
        darkblue = "#081633",
        green = "#98be65",
        orange = "#FF8800",
        violet = "#a9a1e1",
        magenta = "#c678dd",
        blue = "#51afef",
        red = "#ec5f67",
      }

      ins_left({
        "lsp_progress",
        display_components = { "lsp_client_name", { "title", "percentage", "message" } },
        -- With spinner
        -- display_components = { "lsp_client_name", "spinner", { "title", "percentage", "message" } },
        colors = {
          percentage = colors.cyan,
          title = colors.cyan,
          message = colors.cyan,
          spinner = colors.cyan,
          lsp_client_name = colors.magenta,
          use = true,
        },
        separators = {
          component = " ",
          progress = " | ",
          -- message = { pre = "(", post = ")" },
          percentage = { pre = "", post = "%% " },
          title = { pre = "", post = ": " },
          lsp_client_name = { pre = "[", post = "]" },
          spinner = { pre = "", post = "" },
          message = { pre = "(", post = ")", commenced = "In Progress", completed = "Completed" },
        },
        timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
        spinner_symbols = { "🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕 ", "🌖 ", "🌗 ", "🌘 " },
      })

      require('lualine').setup(config)
    end
  }, -- A blazing fast and easy to configure Neovim statusline written in Lua.
  -- "tjdevries/express_line.nvim",

}
