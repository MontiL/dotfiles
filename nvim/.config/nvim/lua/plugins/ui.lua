return {
  -- {
  --   "folke/noice.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     -- add any options here
  --   },
  --   dependencies = {
  --     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
  --     "MunifTanjim/nui.nvim",
  --     -- OPTIONAL:
  --     --   `nvim-notify` is only needed, if you want to use the notification view.
  --     --   If not available, we use `mini` as the fallback
  --     "rcarriga/nvim-notify",
  --   },
  --   config = function()
  --     require("noice").setup({
  --       lsp = {
  --         -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
  --         override = {
  --           ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
  --           ["vim.lsp.util.stylize_markdown"] = true,
  --           ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
  --         },
  --       },
  --       -- you can enable a preset for easier configuration
  --       presets = {
  --         bottom_search = true,          -- use a classic bottom cmdline for search
  --         command_palette = false,       -- position the cmdline and popupmenu together
  --         long_message_to_split = false, -- long messages will be sent to a split
  --         inc_rename = false,            -- enables an input dialog for inc-rename.nvim
  --         lsp_doc_border = false,        -- add a border to hover docs and signature help
  --       },
  --       routes = {
  --         -- Show @recording messages
  --         -- {
  --         --   view = "notify",
  --         --   filter = { event = "msg_showmode" },
  --         -- },
  --         -- Hide written messages
  --         {
  --           filter = {
  --             event = "msg_show",
  --             kind = "",
  --             find = "written",
  --           },
  --           opts = { skip = true },
  --         },
  --         -- Hide Search Virtual Text
  --         -- {
  --         --   filter = {
  --         --     event = "msg_show",
  --         --     kind = "search_count",
  --         --   },
  --         --   opts = { skip = true },
  --         -- },
  --       },
  --     })
  --   end
  -- },
  "junegunn/goyo.vim",
  {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig",
    config = function()
      require("nvim-navic").setup({
        lsp = {
          auto_attach = true,
          preference = { "pyright", "pylsp" },
        },
        highlight = true,
        separator = " > ",
        depth_limit = 0,
        depth_limit_indicator = "..",
        safe_output = true,
        lazy_update_context = false,
        click = true
      })
    end
  },
  -- View and search LSP symbols, tags in Vim/NeoVim.
  {
    "liuchengxu/vista.vim",
    config = function()
      vim.cmd([[ let g:vista_default_executive = 'nvim_lsp' ]])
    end
  },
}
