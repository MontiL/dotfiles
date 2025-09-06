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
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  -- Standalone UI for nvim-lsp progress
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
    commit = "0ba1e16d07627532b6cae915cc992ecac249fb97",
    dependencies = { "neovim/nvim-lspconfig" },
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
  --[[ "arkav/lualine-lsp-progress", ]]
}
