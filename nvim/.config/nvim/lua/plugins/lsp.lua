return {
  -- Neovim setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
  {
    "folke/neodev.nvim",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      require("neodev").setup(
        {
          library = { plugins = { "nvim-dap-ui" }, types = true },
        }
      )
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
  { "Bilal2453/luvit-meta",    lazy = true }, -- optional `vim.uv` typings
  {                                           -- optional completion source for require statements and module annotations
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      --[[ "williamboman/nvim-lsp-installer", ]]
      --[[ "tamago324/nlsp-settings.nvim", -- language server settings defined in json ]]
      "jose-elias-alvarez/null-ls.nvim",
      "folke/neodev.nvim"
    },
    config = function()
      local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })
      local format_on_save = function(_, bufnr)
        vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup_format,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ bufnr = bufnr })
          end,
        })
      end

      --  This function gets run when an LSP connects to a particular buffer.
      local on_attach = function(client, bufnr)
        -- Create a command `:Format` local to the LSP buffer
        --[[ vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' }) ]]
        format_on_save(client, bufnr)
      end

      -- Server Configurations
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#dockerls
      local servers = {
        bashls = {},
        vimls = {},
        taplo = {},
        yamlls = {},
        lua_ls = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' }
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              --[[ library = vim.api.nvim_get_runtime_file("", true), ]]
              checkThirdParty = false
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false },
          },
        },
        -- NOTE: need to have `pyrightconfig.json` in root folder
        -- pyright = {
        --   Python = {
        --     analysis = {
        --       autoSearchPaths = true,
        --       diagnosticMode = "workspace",
        --       useLibraryCodeForTypes = true,
        --     }
        --   }
        -- },
        pylsp = {},
        -- web
        ts_ls = {},
        tailwindcss = {},
        emmet_ls = {},
        jsonls = {},
        prosemd_lsp = {},
        -- studying
        --[[ vuels = {}, ]]
        --[[ astro = {}, ]]
        --[[ svelte = {}, ]]
        prismals = {},
        -- dockerls = {},
      }

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      -- Setup mason so it can manage external tooling
      require('mason').setup()

      -- Ensure the servers above are installed
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup { ensure_installed = vim.tbl_keys(servers) }
      local lspconfig = require("lspconfig")

      -- Automatic server setup (advanced feature) :h mason-lspconfig-automatic-server-setup
      mason_lspconfig.setup_handlers {
        function(server_name)
          lspconfig[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
          }
        end,
      }

      require("lsp.handlers").setup()
      require("lsp.null-ls")
      --[[ require("lsp.lsp-installer") ]]
    end
  },

  -- Standalone UI for nvim-lsp progress
  {
    "j-hui/fidget.nvim",
    config = function() require("fidget").setup() end,
    commit = "0ba1e16d07627532b6cae915cc992ecac249fb97",
    dependencies = { "neovim/nvim-lspconfig" }
  },
  --[[ "arkav/lualine-lsp-progress", ]]

  -- snippets
  -- For luasnip users.
  {
    "L3MON4D3/LuaSnip",                            -- snippet engine
    dependencies = "rafamadriz/friendly-snippets", -- a bunch of snippets to use
    config = function()
      local status_ok, ls = pcall(require, "luasnip")
      if not status_ok then return end

      local types = require("luasnip.util.types")
      local snippet = ls.snippet
      local i = ls.insert_node
      local t = ls.text_node

      ls.config.set_config {
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
      }

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
          i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else")
        })
      })

      require("luasnip.loaders.from_snipmate").lazy_load({ paths = "~/.config/nvim/vim-snippets/snippets" })
    end
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
    end
  },
  -- vsnip
  --[[ "hrsh7th/cmp-vsnip", ]]
  --[[ "hrsh7th/vim-vsnip", ]]
  -- ultisnips
  -- "SirVer/ultisnips",
  -- "quangnguyen30192/cmp-nvim-ultisnips",
  -- "epilande/vim-es2015-snippets", -- ES2015 code snippets (Optional)
  -- "epilande/vim-react-snippets", -- React code snippets
  -- For snippy users
  -- "dcampos/nvim-snippy",
  -- "dcampos/cmp-snippy",
  --[[ use { "ray-x/lsp_signature.nvim" } ]]

  {
    -- format on save
    "lukas-reineke/lsp-format.nvim",
    config = function()
      require("lsp-format").setup {}
      require("lspconfig").gopls.setup { on_attach = require("lsp-format").on_attach }
    end
  }
}
