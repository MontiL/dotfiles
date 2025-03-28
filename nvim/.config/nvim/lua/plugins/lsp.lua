return {
  -- Neovim setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
  {
    "folke/neodev.nvim",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
      })
    end,
  },
  -- {
  --   "folke/lazydev.nvim",
  --   ft = "lua", -- only load on lua files
  --   opts = {
  --     library = {
  --       -- See the configuration section for more details
  --       -- Load luvit types when the `vim.uv` word is found
  --       { path = "luvit-meta/library", words = { "vim%.uv" } },
  --     },
  --   },
  -- },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  { -- optional completion source for require statements and module annotations
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },

  -- Standalone UI for nvim-lsp progress
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
    commit = "0ba1e16d07627532b6cae915cc992ecac249fb97",
    dependencies = { "neovim/nvim-lspconfig" },
  },
  --[[ "arkav/lualine-lsp-progress", ]]

  -- snippets
  -- For luasnip users.
  {
    "L3MON4D3/LuaSnip", -- snippet engine
    dependencies = "rafamadriz/friendly-snippets", -- a bunch of snippets to use
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
        -- This tells LuaSnip to remember to keep around the last snippet.
        -- You can jump back into it even if you move outside of the selection
        history = false,

        -- This one is cool cause if you have dynamic snippets, it updates as you type!
        updateevents = "TextChanged,TextChangedI",

        -- Autosnippets:
        enable_autosnippets = true,

        -- Crazy highlights!!
        -- #vid3
        -- ext_opts = nil,
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { " « ", "NonTest" } },
            },
          },
        },
      })

      -- expansion key
      -- expand the current item or jump to the next item within the snippet.
      vim.keymap.set({ "i", "s" }, "<c-l>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true })

      -- jump backwards key
      -- this always moves to the previous item within the snippet
      vim.keymap.set({ "i", "s" }, "<c-h>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true })

      -- <c-l> is selecting within a list of options.
      -- This is useful for choice nodes (introduced in the forthcoming episode 2)
      --[[ vim.keymap.set("i", "<c-l>", function() ]]
      --[[   if ls.choice_active() then ]]
      --[[     ls.change_choice(1) ]]
      --[[   end ]]
      --[[ end) ]]
      ls.add_snippets("all", {
        snippet("ternary", {
          -- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
          i(1, "cond"),
          t(" ? "),
          i(2, "then"),
          t(" : "),
          i(3, "else"),
        }),
      })

      require("luasnip.loaders.from_snipmate").lazy_load({ paths = "~/.config/nvim/vim-snippets/snippets" })
    end,
  },
  { "saadparwaiz1/cmp_luasnip" }, -- snippet completions
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
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "isort", "black" },
        -- You can customize some of the format options for the filetype (:help conform.format)
        rust = { "rustfmt", lsp_format = "fallback" },
        -- Conform will run the first available formatter
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        javascriptreact = { "prettierd" },
        css = { "prettierd" },
        html = { "prettierd" },
        json = { "prettierd" },
        yaml = { "prettierd" },
        toml = { "prettierd" },
        markdown = { "prettierd" },
        graphql = { "prettierd" },
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
  },
}
