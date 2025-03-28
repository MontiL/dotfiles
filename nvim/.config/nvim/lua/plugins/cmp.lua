return {
  {
    -- Completion
    "hrsh7th/nvim-cmp",
    -- load cmp on InsertEnter
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer", -- buffer completions
      "hrsh7th/cmp-path", -- path completions
      "hrsh7th/cmp-cmdline", -- cmdline completions
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lua",
      --[[ use("hrsh7th/cmp-emoji") ]]
      -- Plug 'nvim-lua/completion-nvim'
    },
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
    config = function()
      -- reference:
      -- https://github.com/hrsh7th/nvim-cmp#setup

      local status_ok, cmp = pcall(require, "cmp")
      if not status_ok then
        return
      end

      --[[ local check_backspace = function() ]]
      --[[   local col = vim.fn.col(".") - 1 ]]
      --[[   return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ]]
      --[[ end ]]

      --   פּ ﯟ   some other good icons
      local kind_icons = {
        Text = "󰊄",
        Method = "m",
        Function = "󰊕",
        Constructor = "",
        Field = "",
        Variable = "󰫧",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
      }
      --- find more here: https://www.nerdfonts.com/cheat-sheet

      cmp.setup({
        view = {
          entries = "custom", -- can be "custom", "wildmenu" or "native"
        },
        snippet = {
          expand = function(args)
            --[[ vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users. ]]
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          --[[ ["<Tab>"] = cmp.mapping.select_next_item(), ]]
          --[[ ["<S-Tab>"] = cmp.mapping.select_prev_item(), ]]
          -- ['<m-c>'] = cmp.mapping.complete(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-y>"] = cmp.mapping.scroll_docs(-4),
          ["<C-e>"] = cmp.mapping.scroll_docs(4),
          ["<C-c>"] = cmp.mapping.abort(), -- Close
          -- Accept currently selected item. If none selected, `select` first item.
          -- Set `select` to `false` to only confirm explicitly selected items.
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          {
            name = "buffer",
            option = {
              get_bufnrs = function()
                local buf = vim.api.nvim_get_current_buf()
                local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
                if byte_size > 1024 * 1024 then -- 1 Megabyte max
                  return {}
                end
                return { buf }
              end,
            },
          },
          { name = "buffer" },
          { name = "git" },
          { name = "luasnip" }, -- For luasnip users.
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          --[[ { name = "vsnip" }, -- For vsnip users. ]]
          -- { name = "ultisnips" }, -- For ultisnips users.
          -- { name = "snippy" }, -- For snippy users.
          { name = "path" },
          { name = "emoji" },
          { name = "nvim_lsp_signature_help" },
        }),
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function(entry, vim_item)
            -- Kind icons
            --[[ vim_item.kind = string.format("%s", kind_icons[vim_item.kind]) ]]
            vim_item.kind = (kind_icons[vim_item.kind] or "") .. " " .. vim_item.kind
            -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind

            vim_item.menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              --[[ vsnip = "[Snippet]", ]]
              nvim_lua = "[NVIM_LUA]",
              path = "[Path]",
              emoji = "[Emoji]",
            })[entry.source.name]

            local source_mapping = {
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              nvim_lua = "[Lua]",
              --[[ vsnip = "[Snippet]", ]]
              path = "[Path]",
              emoji = "[Emoji]",
            }

            local menu = source_mapping[entry.source.name]
            vim_item.menu = menu

            return vim_item
          end,
          expandable_indicator = true,
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        experimental = {
          ghost_text = false,
          native_menu = false,
        },
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      vim.cmd([[
    " " gray
    " highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
    " " blue
    " highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
    " highlight! link CmpItemAbbrMatchFuzzy CmpItemAbbrMatch
    " " light blue
    " highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
    " highlight! link CmpItemKindInterface CmpItemKindVariable
    " highlight! link CmpItemKindText CmpItemKindVariable
    " " pink
    " highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
    " highlight! link CmpItemKindMethod CmpItemKindFunction
    " " front
    " highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
    " highlight! link CmpItemKindProperty CmpItemKindKeyword
    " highlight! link CmpItemKindUnit CmpItemKindKeyword
    " nvim-cmp visual studio code dark+ colors

    " gray
    highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
    " blue
    highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
    highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
    " light blue
    highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
    highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
    highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
    " pink
    highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
    highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
    " front
    highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
    ]])
      --- https://github.com/windwp/nvim-autopairs#you-need-to-add-mapping-cr-on-nvim-cmp-setupcheck-readmemd-on-nvim-cmp-repo

      --[[ local snip_status_ok, luasnip = pcall(require, "luasnip") ]]
      --[[ if not snip_status_ok then return end ]]

      require("luasnip.loaders.from_vscode").lazy_load()

      -- autopairs for completion
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
    end, -- completion plugin
  },
  {
    "petertriho/cmp-git",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      local format = require("cmp_git.format")
      local sort = require("cmp_git.sort")
      require("cmp_git").setup({
        -- defaults
        filetypes = { "gitcommit", "octo" },
        remotes = { "upstream", "origin" }, -- in order of most to least prioritized
        enableRemoteUrlRewrites = false, -- enable git url rewrites, see https://git-scm.com/docs/git-config#Documentation/git-config.txt-urlltbasegtinsteadOf
        git = {
          commits = {
            limit = 100,
            sort_by = sort.git.commits,
            format = format.git.commits,
          },
        },
        github = {
          hosts = {}, -- list of private instances of github
          issues = {
            fields = { "title", "number", "body", "updatedAt", "state" },
            filter = "all", -- assigned, created, mentioned, subscribed, all, repos
            limit = 100,
            state = "open", -- open, closed, all
            sort_by = sort.github.issues,
            format = format.github.issues,
          },
          mentions = {
            limit = 100,
            sort_by = sort.github.mentions,
            format = format.github.mentions,
          },
          pull_requests = {
            fields = { "title", "number", "body", "updatedAt", "state" },
            limit = 100,
            state = "open", -- open, closed, merged, all
            sort_by = sort.github.pull_requests,
            format = format.github.pull_requests,
          },
        },
        gitlab = {
          hosts = {}, -- list of private instances of gitlab
          issues = {
            limit = 100,
            state = "opened", -- opened, closed, all
            sort_by = sort.gitlab.issues,
            format = format.gitlab.issues,
          },
          mentions = {
            limit = 100,
            sort_by = sort.gitlab.mentions,
            format = format.gitlab.mentions,
          },
          merge_requests = {
            limit = 100,
            state = "opened", -- opened, closed, locked, merged
            sort_by = sort.gitlab.merge_requests,
            format = format.gitlab.merge_requests,
          },
        },
        trigger_actions = {
          {
            debug_name = "git_commits",
            trigger_character = ":",
            action = function(sources, trigger_char, callback, params, git_info)
              return sources.git:get_commits(callback, params, trigger_char)
            end,
          },
          {
            debug_name = "gitlab_issues",
            trigger_character = "#",
            action = function(sources, trigger_char, callback, params, git_info)
              return sources.gitlab:get_issues(callback, git_info, trigger_char)
            end,
          },
          {
            debug_name = "gitlab_mentions",
            trigger_character = "@",
            action = function(sources, trigger_char, callback, params, git_info)
              return sources.gitlab:get_mentions(callback, git_info, trigger_char)
            end,
          },
          {
            debug_name = "gitlab_mrs",
            trigger_character = "!",
            action = function(sources, trigger_char, callback, params, git_info)
              return sources.gitlab:get_merge_requests(callback, git_info, trigger_char)
            end,
          },
          {
            debug_name = "github_issues_and_pr",
            trigger_character = "#",
            action = function(sources, trigger_char, callback, params, git_info)
              return sources.github:get_issues_and_prs(callback, git_info, trigger_char)
            end,
          },
          {
            debug_name = "github_mentions",
            trigger_character = "@",
            action = function(sources, trigger_char, callback, params, git_info)
              return sources.github:get_mentions(callback, git_info, trigger_char)
            end,
          },
        },
      })
    end,
  },
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
}
