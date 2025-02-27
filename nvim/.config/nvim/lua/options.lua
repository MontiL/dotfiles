local o = vim.opt

o.shortmess:append("I") -- don't give the intro message when starting Vim, see |:intro|
-- o.shortmess:append("S") -- show 'search hit BOTTOM, continuing at TOP' message

-- file related
o.encoding = "utf-8"
o.fileencodings = "utf-8"              -- the encoding written to file
o.backup = false                       -- create a backup file
o.swapfile = false                     -- creates a swapfile
-- o.undofile = true -- enable persistent undo
vim.opt.guifont = "Hack Nerd Font:h16" -- the font used in graphical neovim applications

-- Finding files - Search down into subfolders
o.path:append("**")
-- o.wildignore.append("*/node_modules/*")
-- o.wildignore.append("*/DS_Store/*")
o.ignorecase = true -- ignore case in search patterns
o.smartcase = true  -- smart case
-- o.writebackup = false -- default on. if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

o.hlsearch = false       -- highlight all matches on previous search pattern
o.cursorline = true      -- highlight the current line
o.number = true
o.relativenumber = false -- use relative line numbers
o.inccommand = "split"   -- incremental substitution (neovim)
o.mouse = "a"            -- allow the mouse to be used in all mode
o.wrap = true            -- display lines as one long line
--[[ o.mousemoveevent = true -- for Bufferline to hover for close icon ]]
--
-- Status line
o.showmode = false -- we don't need to see things like -- INSERT -- anymore
-- o.laststatus = 1
-- o.laststatus = 2 -- (default 2)
-- o.showcmd = true -- (default true)
-- o.cmdheight = 1 -- (default 1). highlight all matches on previous search pattern
-- vim.cmd([[
-- set noruler
-- ]])

o.scrolloff = 2     --  5 -- Minimal number of screen lines to keep above and below the cursor
o.sidescrolloff = 2 -- 5 -- The minimal number of screen columns to keep to the left and to the right of the cursor if 'nowrap' is set
-- o.numberwidth = 4 -- (default 4) set number column width to 2
-- o.lazyredraw = true

-- o.showtabline = 2    -- always show tabs
o.splitbelow = true  -- force all horizontal splits to go below current window
o.splitright = true  -- force all vertical splits to go to the right of current window

o.expandtab = true   -- convert tabs to spaces
o.tabstop = 2        -- insert 2 spaces for a tab
o.shiftwidth = 2     -- the number of spaces inserted for each indentation
o.autoindent = true
o.smartindent = true -- make indenting smarter again

o.conceallevel = 1

vim.cmd([[ " don't automatically add comment string for newline
autocmd BufEnter * set formatoptions-=cro
autocmd BufEnter * setlocal formatoptions-=cro
]])

--
-- allows neovim to access the system clipboard
-- DON'T enable this?
-- because we may lose info we need when we delete something in vim (will be automatically copied to clipboard)
--
--[[ o.clipboard = "unnamedplus" ]]
-- o.compatible = false -- disable compatibility to old-time vi

-- o.completeopt = { "menuone", "noselect" } -- mostly just for cmp
-- o.conceallevel = 0 -- (default 0) so that `` is visible in markdown files
-- o.pumheight = 10 -- pop up menu height
-- o.timeoutlen = 1000 -- time to wait for a mapped sequence to complete (in milliseconds)
-- o.updatetime = 300 -- faster completion (4000ms default)
-- o.formatoptions.append("r") -- Add asterisks in block comments

vim.cmd([[ set noequalalways ]])

o.backspace = "start,eol,indent"

o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

local is_windows = vim.loop.os_uname().version:match("Windows")

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Turn off paste mode when leaving insert
-- autocmd InsertLeave * set nopaste

vim.cmd([[
if &term =~ "screen"
  autocmd BufEnter * if bufname("") !~ "^?[A-Za-z0-9?]*://" | silent! exe '!echo -n "\ek[`hostname`:`basename $PWD`/`basename %`]\e\\"' | endif
  autocmd VimLeave * silent!  exe '!echo -n "\ek[`hostname`:`basename $PWD`]\e\\"'
endif

" File types
" ---------------------------------------------------------------------
" .prettierignore
au BufNewFile,BufRead .prettierignore set filetype=gitignore
" JavaScript
au BufNewFile,BufRead *.es6 setf javascript
" TypeScript
au BufNewFile,BufRead *.tsx setf typescriptreact
" Markdown
au BufNewFile,BufRead *.md set filetype=markdown
au BufNewFile,BufRead *.mdx set filetype=markdown
" Flow
au BufNewFile,BufRead *.flow set filetype=javascript
" Fish
au BufNewFile,BufRead *.fish set filetype=fish
au FileType fish setlocal commentstring=#%s
au FileType fish setlocal shiftwidth=4 tabstop=4
" Python
" au BufNewFile,BufRead *.mia set filetype=python
" au BufNewFile,BufRead *.ipy set filetype=ipython
au BufNewFile,BufRead *.coffee set filetype=coffee
au BufNewFile,BufRead Cakefile set filetype=coffee

set suffixesadd=.js,.es,.jsx,.json,.css,.less,.sass,.styl,.php,.md,.py

au FileType coffee setlocal shiftwidth=2 tabstop=2
au FileType ruby setlocal shiftwidth=2 tabstop=2
au FileType yaml setlocal shiftwidth=2 tabstop=2
au FileType markdown setlocal shiftwidth=2 tabstop=2
"}}}

" other
set nrformats+=alpha
" set exrc
]])

-- Instant grep + quickfix
-- https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
vim.cmd([[
set grepprg=ag\ --vimgrep

function! Grep(...)
	return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)

cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

augroup quickfix
	autocmd!
	autocmd QuickFixCmdPost cgetexpr cwindow
	autocmd QuickFixCmdPost lgetexpr lwindow
augroup END
]])

-- if not is_windows and vim.fn.exists("g:neovide") ~= 1 then
--   vim.g.enable_auto_im_switch = true
-- end

-- vim.cmd("set whichwrap+=<,>,[,],h,l")
-- vim.cmd([[set iskeyword+=-]])

-- TODO: format will cause dd > undo > jump to wrong line
-- Format on save
-- vim.cmd([[ autocmd BufWritePre * lua vim.lsp.buf.format() ]])
