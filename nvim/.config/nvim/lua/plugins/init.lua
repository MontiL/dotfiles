return {
  -- General utilities
  ----------------------------------------------------------------------------------------------------
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "vim-scripts/BufOnly.vim",

  --[[ "wellle/targets.vim", ]]
  -- "michaeljsmith/vim-indent-object",
  { "jeetsukumaran/vim-pythonsense", ft = { "python" } }, -- for Python

  -- packer bugs will come after below plugins
  -- use('mjbrownie/django-template-textobjects') -- for Django
  -- https://github.com/kana/vim-textobj-user/wiki
  --[[ use({ "glts/vim-textobj-comment", dependencies = "kana/vim-textobj-user" }) ]]
  --[[ "jasonlong/vim-textobj-css", ]]

  --bug
  --[[ "whatyouhide/vim-textobj-xmlattr", ]]
  --[[ "vimtaku/vim-textobj-keyvalue", ]]
  --[[ use({ "coachshea/vim-textobj-markdown", dependencies = { "kana/vim-textobj-user" } }) ]]
  --[[ "kana/vim-textobj-indent", ]]
  --[[ "spacewander/vim-textobj-lua", ]]
  --[[ "rbonvall/vim-textobj-latex", ]]

  -- surroundings: parentheses, brackets, quotes, XML tags, and more.
  -- "tpope/vim-surround",
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end
  },
  "tpope/vim-repeat",


  {
    "norcalli/nvim-terminal.lua",
    config = function() require("terminal").setup() end,
  },

  -- git
  ----------------------------------------------------------------------------------------------------
  "tpope/vim-fugitive",
  -- Plug 'tpope/vim-rhubarb'
  {
    'lewis6991/gitsigns.nvim',
    config = function() require('gitsigns').setup() end
  },
  --[[ use({ "dinhhuy258/git.nvim" }) ]]
  --  use {
  --    'kyazdani42/nvim-tree.lua',
  --    dependencies = {
  --      'kyazdani42/nvim-web-devicons', -- optional, for file icon
  --    },
  --    config = function() require'nvim-tree'.setup {} end
  --  }
  "junegunn/gv.vim",   -- for GV (git log with graph)
  "tpope/vim-rhubarb", -- for :GBrowse

  -- LSP
  ----------------------------------------------------------------------------------------------------
  -- auto pairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {
        disable_filetype = { "TelescopePrompt", "vim" }
      }
    end
  },

  -- another lsp
  -- "prabirshrestha/vim-lsp",
  -- "mattn/vim-lsp-settings",

  -- fzf
  {
    "junegunn/fzf.vim",
    -- dependencies = { "junegunn/fzf", build = "fzf#install()" },
    dependencies = { "junegunn/fzf" },
    -- name = 'fzf',
    -- dir = "~/.fzf",
    -- build = "./install --all",
    -- build = "./install --bin",
    build = function()
      vim.fn["fzf#install"]()
    end,
    config = function()
      vim.cmd([[
        " - Popup window (anchored to the bottom of the current window)
        let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.95, 'relative': v:true, 'yoffset': 1.0 } }
        let g:fzf_preview_window = ['right:50%', 'ctrl-/']
        " Customize fzf colors to match your color scheme
        " - fzf#wrap translates this to a set of `--color` options
        let g:fzf_colors =
        \ { 'fg':      ['fg', 'Normal'],
          \ 'bg':      ['bg', 'Normal'],
          \ 'hl':      ['fg', 'Comment'],
          \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
          \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
          \ 'hl+':     ['fg', 'Statement'],
          \ 'info':    ['fg', 'PreProc'],
          \ 'border':  ['fg', 'Ignore'],
          \ 'prompt':  ['fg', 'Conditional'],
          \ 'pointer': ['fg', 'Exception'],
          \ 'marker':  ['fg', 'Keyword'],
          \ 'spinner': ['fg', 'Label'],
          \ 'header':  ['fg', 'Comment'] }
        let g:fzf_command_prefix = 'Fzf'
        ]])
    end
  },

  -- diff tool
  "will133/vim-dirdiff",

  -- -- table tool
  -- { "dhruvasagar/vim-table-mode", ft = { "markdown" } },

  -- for paper
  -- "lervag/vimtex",
  -- -- Vimtex
  -- -- " \ 'build_dir' : {-> expand("%:t:r")},
  -- vim.cmd([[
  -- let g:vimtex_compiler_latexmk = {
  --   \ 'executable' : 'latexmk',
  --   \ 'options' : [
  --   \   '-xelatex',
  --   \   '-file-line-error',
  --   \   '-synctex=1',
  --   \   '-interaction=nonstopmode',
  --   \ ],
  --   \}
  -- ]])

  -- Better profiling output for startup. use :StartupTime
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
  },

  -- Utilities
  "rcarriga/nvim-notify",
  "tpope/vim-characterize",
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  }
}
