return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "Kaiser-Yang/blink-cmp-git",
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "none",
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-y>"] = { "scroll_documentation_up", "fallback" },
        ["<C-e>"] = { "scroll_documentation_down", "fallback" },
        ["<C-c>"] = { "cancel", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-l>"] = { "snippet_forward", "fallback" },
        ["<C-h>"] = { "snippet_backward", "fallback" },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      },
      cmdline = {
        enabled = true,
        keymap = { preset = "cmdline" },
        sources = function()
          local type = vim.fn.getcmdtype()
          if type == "/" or type == "?" then
            return { "buffer" }
          end
          if type == ":" or type == "@" then
            return { "cmdline", "path" }
          end
          return {}
        end,
        completion = {
          menu = { auto_show = true },
          list = { selection = { preselect = true, auto_insert = true } },
        },
      },
      snippets = { preset = "luasnip" },
      sources = {
        default = { "lazydev", "lsp", "snippets", "buffer", "path", "git" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          git = {
            name = "Git",
            module = "blink-cmp-git",
          },
        },
      },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        list = { selection = { preselect = true, auto_insert = false } },
        documentation = {
          auto_show = true,
          window = { border = "rounded" },
        },
        menu = {
          border = "rounded",
          draw = {
            columns = { { "kind_icon" }, { "label", gap = 1 }, { "source_name" } },
          },
        },
        ghost_text = { enabled = false },
      },
      signature = { enabled = true, window = { border = "rounded" } },
      appearance = {
        nerd_font_variant = "mono",
        kind_icons = {
          Text = "󰊄",
          Method = "m",
          Function = "󰊕",
          Constructor = "",
          Field = "",
          Variable = "󰫧",
          Class = "",
          Interface = "",
          Module = "",
          Property = "",
          Unit = "",
          Value = "",
          Enum = "",
          Keyword = "",
          Snippet = "",
          Color = "",
          File = "",
          Reference = "",
          Folder = "",
          EnumMember = "",
          Constant = "",
          Struct = "",
          Event = "",
          Operator = "",
          TypeParameter = "",
        },
      },
      fuzzy = { implementation = "prefer_rust" },
    },
    config = function(_, opts)
      require("blink.cmp").setup(opts)

      -- Highlight groups (VS Code dark+ inspired)
      vim.cmd([[
    " gray
    highlight! BlinkCmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
    " blue
    highlight! BlinkCmpItemAbbrMatch guibg=NONE guifg=#569CD6
    highlight! BlinkCmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
    " light blue
    highlight! BlinkCmpItemKindVariable guibg=NONE guifg=#9CDCFE
    highlight! BlinkCmpItemKindInterface guibg=NONE guifg=#9CDCFE
    highlight! BlinkCmpItemKindText guibg=NONE guifg=#9CDCFE
    " pink
    highlight! BlinkCmpItemKindFunction guibg=NONE guifg=#C586C0
    highlight! BlinkCmpItemKindMethod guibg=NONE guifg=#C586C0
    " front
    highlight! BlinkCmpItemKindKeyword guibg=NONE guifg=#D4D4D4
    ]])
    end,
  },
  -- snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = "rafamadriz/friendly-snippets",
    config = function()
      local status_ok, ls = pcall(require, "luasnip")
      if not status_ok then
        return
      end

      local types = require("luasnip.util.types")
      local snippet = ls.snippet
      local i = ls.insert_node
      local t = ls.text_node

      ls.config.set_config({
        history = false,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { " « ", "NonTest" } },
            },
          },
        },
      })

      -- C-l / C-h keymaps are now handled by blink.cmp

      ls.add_snippets("all", {
        snippet("ternary", {
          i(1, "cond"),
          t(" ? "),
          i(2, "then"),
          t(" : "),
          i(3, "else"),
        }),
      })

      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_snipmate").lazy_load({ paths = "~/.config/nvim/vim-snippets/snippets" })
    end,
  },
  {
    "honza/vim-snippets",
    config = function()
      vim.cmd([[
let g:snips_author = "Monti"
let g:snips_email = "ooy.yoo@gmail.com"
let g:snips_github = "https://github.com/MontiL"
]])
    end,
  },
}
