return {
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
        timeout_ms = 2000,
        lsp_format = "fallback",
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Configure linters by filetype
      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        python = { "ruff" },
        lua = { "luacheck" },
      }

      -- Customizing luacheck to recognize 'vim' global
      local luacheck = lint.linters.luacheck
      luacheck.args = {
        "--globals",
        "vim",
        "--formatter",
        "plain",
        "--codes",
        "--ranges",
        "-",
      }

      -- Create autocommand to trigger linting
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      -- Optional: Add a keymap to trigger linting manually
      vim.keymap.set("n", "<leader>l", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })
    end,
  },
  -- colorscheme
  {
    "EdenEast/nightfox.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.cmd([[colorscheme nordfox]])
    end,
  },

  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- master is frozen and does not support Neovim 0.12
    lazy = false, -- the main branch does not support lazy-loading
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()

      -- jsonc has no dedicated parser on the main branch; reuse the json parser
      vim.treesitter.language.register("json", "jsonc")

      -- install parsers (async, no-op if already installed)
      require("nvim-treesitter").install({
        "bash",
        "fish",
        "yaml",
        "toml",
        "regex",
        "query",
        "gitignore",
        "gitattributes",
        "gitcommit",
        "git_config",
        "git_rebase",

        "vim",
        "vimdoc",

        "lua",
        "luadoc",
        "luap",
        "python",
        "make",
        "c",
        "cpp",
        "cmake",

        -- web
        "html",
        "css",
        "scss",
        "javascript",
        "jsdoc",
        "tsx",
        "typescript",
        "json",
        "json5",
        "markdown",
        "markdown_inline",
        "graphql",

        "prisma",

        -- studying
        "vue",
        "astro",
        "svelte",
        "dockerfile",
      })

      -- enable highlight + indent per filetype (only when a parser is present)
      local no_indent = { yaml = true, python = true }
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not (lang and pcall(vim.treesitter.language.add, lang)) then
            return
          end
          pcall(vim.treesitter.start, args.buf, lang)
          if not no_indent[args.match] then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      -- custom incremental selection (the main branch dropped the module)
      local sel_stack = {}
      local function visual(r)
        local sr, sc, er, ec = r[1], r[2], r[3], r[4]
        vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
        vim.cmd("normal! v")
        vim.api.nvim_win_set_cursor(0, { er + 1, math.max(ec - 1, 0) })
      end
      local function expand()
        local node
        if #sel_stack == 0 then
          node = vim.treesitter.get_node()
        else
          node = sel_stack[#sel_stack]:parent()
          -- skip parents with an identical range
          while
            node
            and node:parent()
            and vim.deep_equal({ node:range() }, { node:parent():range() })
          do
            node = node:parent()
          end
        end
        if not node then
          return
        end
        table.insert(sel_stack, node)
        visual({ node:range() })
      end
      local function shrink()
        if #sel_stack > 1 then
          table.remove(sel_stack)
        end
        if sel_stack[#sel_stack] then
          visual({ sel_stack[#sel_stack]:range() })
        end
      end
      vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = "*:n",
        callback = function()
          sel_stack = {}
        end,
      })
      vim.keymap.set("n", "<Space>s", function()
        sel_stack = {}
        expand()
      end, { desc = "TS init selection" })
      vim.keymap.set("x", "<Space>s", expand, { desc = "TS expand node" })
      vim.keymap.set("x", "<Space>x", shrink, { desc = "TS shrink node" })
      vim.keymap.set("x", "<Space>S", function()
        local node = sel_stack[#sel_stack] or vim.treesitter.get_node()
        while
          node
          and not node:type():match("function")
          and not node:type():match("class")
          and not node:type():match("block")
        do
          node = node:parent()
        end
        if node then
          table.insert(sel_stack, node)
          visual({ node:range() })
        end
      end, { desc = "TS expand scope" })
    end,
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
          require("ts_context_commentstring").setup({ enable_autocmd = false })
        end,
      },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        config = function()
          require("nvim-treesitter-textobjects").setup({
            select = { lookahead = true },
          })
          local sel = require("nvim-treesitter-textobjects.select")
          local swap = require("nvim-treesitter-textobjects.swap")
          local move = require("nvim-treesitter-textobjects.move")

          local select_maps = {
            aa = "@parameter.outer",
            ia = "@parameter.inner",
            af = "@function.outer",
            ["if"] = "@function.inner",
            ac = "@class.outer",
            ic = "@class.inner",
            aC = "@comment.outer",
            iC = "@comment.inner",
            al = "@loop.outer",
            il = "@loop.inner",
          }
          for k, v in pairs(select_maps) do
            vim.keymap.set({ "x", "o" }, k, function()
              sel.select_textobject(v, "textobjects")
            end)
          end

          local function m(keys, fn, obj)
            vim.keymap.set({ "n", "x", "o" }, keys, function()
              fn(obj, "textobjects")
            end)
          end
          m("]f", move.goto_next_start, "@function.outer")
          m("]c", move.goto_next_start, "@class.outer")
          m("]F", move.goto_next_end, "@function.outer")
          m("]C", move.goto_next_end, "@class.outer")
          m("[f", move.goto_previous_start, "@function.outer")
          m("[c", move.goto_previous_start, "@class.outer")
          m("[F", move.goto_previous_end, "@function.outer")
          m("[C", move.goto_previous_end, "@class.outer")

          vim.keymap.set("n", "<leader>a", function()
            swap.swap_next("@parameter.inner")
          end)
          vim.keymap.set("n", "<leader>A", function()
            swap.swap_previous("@parameter.inner")
          end)
        end,
      },
      {
        "windwp/nvim-ts-autotag",
        config = function()
          require("nvim-ts-autotag").setup()
        end,
      },
    },
  },

  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        override = {
          zsh = {
            icon = "",
            color = "#428850",
            cterm_color = "65",
            name = "Zsh",
          },
        },
        color_icons = true,
        default = true,
      })
    end,
  },

  -- file explorer (Oil only)
  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        columns = {
          "icon",
        },
        buf_options = {
          buflisted = false,
          bufhidden = "hide",
        },
        win_options = {
          wrap = false,
          signcolumn = "no",
          cursorcolumn = false,
          foldcolumn = "0",
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = "nvic",
        },
        delete_to_trash = false,
        skip_confirm_for_simple_edits = false,
        prompt_save_on_select_new_entry = true,
        cleanup_delay_ms = 2000,
        lsp_file_methods = {
          enabled = true,
          timeout_ms = 1000,
          autosave_changes = false,
        },
        constrain_cursor = "editable",
        watch_for_changes = false,
        keymaps = {
          ["g?"] = { "actions.show_help", mode = "n" },
          ["<CR>"] = "actions.select",
          ["sv"] = { "actions.select", opts = { vertical = true } },
          ["ss"] = { "actions.select", opts = { horizontal = true } },
          ["<C-t>"] = { "actions.select", opts = { tab = true } },
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = { "actions.close", mode = "n" },
          ["<C-l>"] = "actions.refresh",
          ["-"] = { "actions.parent", mode = "n" },
          ["_"] = { "actions.open_cwd", mode = "n" },
          ["`"] = { "actions.cd", mode = "n" },
          ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
          ["gs"] = { "actions.change_sort", mode = "n" },
          ["gx"] = "actions.open_external",
          ["g."] = { "actions.toggle_hidden", mode = "n" },
          ["g\\"] = { "actions.toggle_trash", mode = "n" },
        },
        use_default_keymaps = false,
        view_options = {
          show_hidden = false,
          is_hidden_file = function(name, bufnr)
            local m = name:match("^%.")
            return m ~= nil
          end,
          is_always_hidden = function(name, bufnr)
            return false
          end,
          natural_order = "fast",
          case_insensitive = false,
          sort = {
            { "type", "asc" },
            { "name", "asc" },
          },
          highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
            return nil
          end,
        },
        extra_scp_args = {},
        git = {
          add = function(path)
            return false
          end,
          mv = function(src_path, dest_path)
            return false
          end,
          rm = function(path)
            return false
          end,
        },
        float = {
          padding = 2,
          max_width = 0,
          max_height = 0,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
          get_win_title = nil,
          preview_split = "auto",
          override = function(conf)
            return conf
          end,
        },
        preview_win = {
          update_on_cursor_moved = true,
          preview_method = "fast_scratch",
          disable_preview = function(filename)
            return false
          end,
          win_options = {},
        },
        confirmation = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = 0.9,
          min_height = { 5, 0.1 },
          height = nil,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
        },
        progress = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = { 10, 0.9 },
          min_height = { 5, 0.1 },
          height = nil,
          border = "rounded",
          minimized_border = "none",
          win_options = {
            winblend = 0,
          },
        },
        ssh = {
          border = "rounded",
        },
        keymaps_help = {
          border = "rounded",
        },
      })
    end,
  },

  -- Markdown
  {
    "preservim/vim-markdown",
    config = function()
      vim.g.vim_markdown_folding_disabled = 1
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  -- Render markdown headings, code blocks, etc.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    opts = {},
  },

  -- other non-lsp syntax highlight
  { "mtdl9/vim-log-highlighting", ft = { "log", "_log" } }, -- Log highlight
  { "gisphm/vim-gitignore", ft = { "gitignore" } }, -- .gitignore highlight
  { "imsnif/kdl.vim", event = "BufReadPre *.kdl" },
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        tailwind = true,
      },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    main = "ibl",
    opts = {},
  },

  -- Highlight TODO/FIXME/HACK comments
  { "folke/todo-comments.nvim", dependencies = "nvim-lua/plenary.nvim", event = "VeryLazy", opts = {} },

  -- Improve vim.ui.select/input UI
  { "stevearc/dressing.nvim", event = "VeryLazy", opts = {} },
}
