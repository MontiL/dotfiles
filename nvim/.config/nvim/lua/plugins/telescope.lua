return {
  { 'ThePrimeagen/harpoon' },
  { 'ThePrimeagen/git-worktree.nvim' },
  -- Telescope
  ----------------------------------------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "BurntSushi/ripgrep" }, -- is required for live_grep and grep_string of Telescope
    },
    cmd = "Telescope",
    config = function()
      local status_ok, telescope = pcall(require, "telescope")
      if not status_ok then return end

      local actions = require("telescope.actions")
      local action_layout = require("telescope.actions.layout")
      local lga_actions = require("telescope-live-grep-args.actions")
      local trouble = require("trouble.sources.telescope")

      telescope.setup({
        defaults = {
          layout_config = { width = 0.95, height = 0.95 },
          prompt_prefix = "🔍 ",
          selection_caret = " ",
          path_display = { "smart" },

          -- vimgrep_arguments = {
          --   "rg",
          --   "--color=never",
          --   "--no-heading",
          --   "--with-filename",
          --   "--line-number",
          --   "--column",
          --   "--smart-case",
          --   "-u", -- -u, --unrestricted
          --   --       Reduce the level of "smart" searching. A single -u won't respect .gitignore
          --   --       (etc.) files. Two -u flags will additionally search hidden files and
          --   --       directories. Three -u flags will additionally search binary files.
          -- },

          mappings = {
            i = {
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              --[[ ["<Down>"] = actions.move_selection_next, ]]
              --[[ ["<Up>"] = actions.move_selection_previous, ]]
              ["<C-j>"] = actions.cycle_history_next,
              ["<C-k>"] = actions.cycle_history_prev,

              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.complete_tag,

              ["<CR>"] = actions.select_default,
              ["<C-h>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              -- ["<C-b>"] = actions.select_tab,

              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,

              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,

              -- cannot use C-t because of tmux prefix key
              ["<C-b>"] = trouble.open,

              ["<C-c>"] = actions.close,

              ["?"] = action_layout.toggle_preview,
              ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
            },

            n = {
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              -- ["<C-b>"] = actions.select_tab,

              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,

              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,

              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,

              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,

              -- cannot use C-t because of tmux prefix key
              ["<C-b>"] = trouble.open,

              ["?"] = actions.which_key,
            },
          },
        },
        pickers = {
          oldfiles = {
            cwd_only = true,
          },
          live_grep = {
            additional_args = function()
              return { "--hidden", "--ignore-case", "--glob=!.git", "--glob=!backup" } -- Search hidden file or directory, ignore case, ignore .git
              -- return { "--hidden", "--ignore-case", "--glob=!.git" } -- Search hidden file or directory, ignore case, ignore .git
            end,
          },
          -- Default configuration for builtin pickers goes here:
          -- picker_name = {
          --   picker_config_key = value,
          --   ...
          -- }
          -- Now the picker_config_key will be applied every time you call this
          -- builtin picker
        },
        -- extensions = {
        -- 	media_files = {
        -- 		-- filetypes whitelist
        -- 		-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
        -- 		filetypes = { "png", "jpg", "jpeg", "webp", "webm", "pdf", "mp4" },
        -- 		find_cmd = "rg", -- find command (defaults to `fd`)
        -- 	},
        -- 	-- Your extension configuration goes here:
        -- 	-- extension_name = {
        -- 	--   extension_config_key = value,
        -- 	-- }
        -- 	-- please take a look at the readme of the extension you want to configure
        -- },
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
          live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = {         -- extend mappings
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              },
            },
            -- ... also accepts theme settings, for example:
            -- theme = "dropdown", -- use dropdown theme
            -- theme = { }, -- use own theme spec
            -- layout_config = { mirror=true }, -- mirror preview pane
          },
          bookmarks = {
            -- Available: 'brave', 'buku', 'chrome', 'chrome_beta', 'edge', 'safari', 'firefox', 'vivaldi'
            selected_browser = "brave",
            -- Either provide a shell command to open the URL
            url_open_command = "open",
            -- Or provide the plugin name which is already installed
            -- Available: 'vim_external', 'open_browser'
            url_open_plugin = nil,
            -- Show the full path to the bookmark instead of just the bookmark name
            full_path = true,
            find_cmd = "rg", -- find command (defaults to `fd`)
            -- Provide a custom profile name for Firefox
            -- firefox_profile_name = nil,
          },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("live_grep_args")
      telescope.load_extension("zoxide") -- <leader>z
      telescope.load_extension("dap")    -- :Telescope dap xxx
      telescope.load_extension("git_worktree")
      -- telescope.load_extension("bookmarks")     -- bookmark of browser
      -- telescope.load_extension("vim_bookmarks") -- Telescope picker for the vim-bookmarks
      -- telescope.load_extension("media_files")
      -- telescope.load_extension('harpoon')
    end
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  "nvim-telescope/telescope-dap.nvim", -- dap of Telescope
  "jvgrootveld/telescope-zoxide",
  -- "dhruvmanila/telescope-bookmarks.nvim",             -- bookmarks of browser
  -- {
  --   "tom-anders/telescope-vim-bookmarks.nvim",        -- Telescope picker for the vim-bookmarks
  --   dependencies = { "MattesGroeger/vim-bookmarks" }, -- bookmark of vim
  -- },
  -- "nvim-telescope/telescope-media-files.nvim",
  "nvim-telescope/telescope-live-grep-args.nvim",
  -- {
  --   "nvim-telescope/telescope-frecency.nvim",
  --   config = function()
  --     require("telescope").load_extension "frecency"
  --   end,
  --   dependencies = { "kkharji/sqlite.lua" },
  -- }
}
