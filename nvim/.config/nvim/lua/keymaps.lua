-- nvim/.config/nvim/lua/keymaps.lua
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local wk = require("which-key")

-- Reload configurations
map("n", "<leader><leader>rf", ":source ~/.config/fish/config.fish<CR>", { desc = "Reload Fish shell" })
map("n", "<leader><leader>rw", ":source ~/.config/nvim/lua/plugins/whichkey.lua<CR>", { desc = "Reload whichkey.lua" })
map("n", "<leader><leader>rl", ":source ~/.config/nvim/lua/plugins/luasnip.lua<CR>", { desc = "Reload luasnip.lua" })

-- Lazy.nvim
map("n", "<leader>z", ":Lazy<CR>", { desc = "La[z]y.nvim" })
map("n", "<leader>u", ":Lazy update<CR>", { desc = "Lazy.nvim [U]pdate" })

-- Close and quit
map("n", "<C-c>", "<cmd>q<CR>", { desc = "[C]lose (quit)" })

-- Snippets documentation
map("n", "<leader><leader>rsf", ":!open https://github.com/rafamadriz/friendly-snippets/wiki<CR>",
  { desc = "Read Doc of friendly snippets" })
map("n", "<leader><leader>rsv", ":!open https://github.com/honza/vim-snippets/tree/master/snippets<CR>",
  { desc = "Read Doc of vim-snippets" })

-- Utility
map("n", "<space>m", ":message<CR>", { desc = "message" })
map("n", "<space>L", "<cmd>LspInfo<CR>", { desc = "LSP Info" })
map("n", "<space>M", "<cmd>Mason<CR>", { desc = "Mason LSP manager" })
map("n", "<space>W", "<cmd>WhichKey<CR>", { desc = "WhichKey menu" })
map("n", "<space>/", "<cmd>Telescope keymaps<CR>", { desc = "Query Keymaps by Telescope" })
map("n", "<space>?", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })

-- 複製絕對路徑函數
local function copy_absolute_path()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)
  vim.notify('Absolute filepath copied', vim.log.levels.INFO)
end

-- 複製相對路徑函數
local function copy_relative_path()
  local path = vim.fn.substitute(vim.fn.expand('%:p'), vim.fn.fnamemodify(vim.fn.finddir('.git', ';'), ':p:h:h') .. '/',
    '', '')
  vim.fn.setreg('+', path)
  vim.notify('Relative filepath copied', vim.log.levels.INFO)
end

-- 路徑複製鍵綁定
map("n", "<leader>ca", copy_absolute_path, { desc = "copy (a)bsolute filepath", silent = true })
map("n", "<leader>cr", copy_relative_path, { desc = "copy (r)elative filepath", silent = true })
map("n", "<leader>cm", ":let @+ = execute('message')<CR>", { desc = "Copy message outputs to clipboard" })

-- Toggles
map("n", "<space>hl", ":set hlsearch! hlsearch?<CR>", { desc = "Toggle Highlight Search" })
map("n", "<space>z", "<cmd>set wrap!<CR>", { desc = "Wrap Toggle" })
map("n", "<space>p", "<cmd>MarkdownPreview<CR>", { desc = "Markdown Preview" })
map("n", "<space>v", "<cmd>Vista!!<CR>", { desc = "Open/Close window for LSP symbols or tags" })
map("n", "<space>q", vim.diagnostic.setqflist, { desc = "Add buffer diagnostics to quickfix" })
map("n", "<space>l>", vim.diagnostic.setloclist, { desc = "Add buff diagnostics to loclist" })

-- Insert/append newline
map("n", "]<space>", "o<Esc>k", { desc = "Append newline" })
map("n", "[<space>", "O<Esc>j", { desc = "Insert newline" })

-- Buffer navigation
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<CR>", { desc = "Prev buffer" })

-- -- BufferLine navigation
-- for i = 1, 9 do
--   map("n", string.format("<leader>%d", i), string.format("<cmd>BufferLineGoToBuffer %d<CR>", i), { desc = string.format("Go to tab %d", i) })
-- end
-- map("n", "<leader>0", "<cmd>BufferLineGoToBuffer -1<CR>", { desc = "Go to tab last" })
--
-- -- BufferLine actions
-- map("n", "<leader>o", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close Other Tabs(buffer)" })
-- map("n", "<leader>l", "<cmd>BufferLineCloseLeft<CR>", { desc = "Close Left Tabs(buffer)" })
-- map("n", "<leader>r", "<cmd>BufferLineCloseRight<CR>", { desc = "Close Right Tabs(buffer)" })
-- map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close current buffer" })

-- Telescope
wk.add({ { "<leader>s", name = "Search ..." } })
map("n", "<leader>sf",
  "<cmd>Telescope find_files find_command=rg,--files,--follow,--hidden,--ignore-case,--glob=!.git,--glob=!backup<CR>",
  { desc = "[S]earch [F]iles" })
map("n", "<leader>sg", "<cmd>Telescope git_status<CR>", { desc = "[s]earch [g]it status" })
map("n", "<leader>sr", "<cmd>Telescope live_grep<CR>", { desc = "[s]earch by g[r]ep" })
map("n", "<leader>sa", "<cmd>Telescope live_grep_args<CR>", { desc = "[s]earch by grep [a]rgs" })
map("n", "<leader>sw", "<cmd>Telescope grep_string<CR>",
  { desc = "[S]earch the string under cursor in current [w]orking directory" })
map("n", "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "[s]earch [b]uffer" })

-- Quickfix and Location list navigation
map("n", "[q", "<cmd>cprev<CR>", { desc = "Prev Quickfix" })
map("n", "]q", "<cmd>cnext<CR>", { desc = "Next Quickfix" })
map("n", "]Q", "<cmd>clast<CR>", { desc = "Last Quickfix" })
map("n", "[Q", "<cmd>cfirst<CR>", { desc = "First Quickfix" })
map("n", "]l", "<cmd>lnext<CR>", { desc = "Next Location List" })
map("n", "[l", "<cmd>lprev<CR>", { desc = "Prev Location List" })
map("n", "]L", "<cmd>llast<CR>", { desc = "Last Location List" })
map("n", "[L", "<cmd>lfirst<CR>", { desc = "First Location List" })

-- File explorers
map("n", "<leader>t", "<cmd>NvimTreeToggle<CR>", { desc = "NvimTree Toggle" })
map("n", "<leader>T", "<cmd>Neotree toggle<CR>", { desc = "Neotree Toggle" })

-- Goyo mode
map("n", "<leader>G", "<cmd>Goyo<CR>", { desc = "Goyo mode / Lite mode" })

-- ChatGPT
wk.add({ { "<leader><leader>g", name = "ChatGPT" } })
map("n", "<leader><leader>gc", "<cmd>ChatGPT<CR>", { desc = "ChatGPT" })
map({ "n", "v" }, "<leader><leader>ge", "<cmd>ChatGPTEditWithInstruction<CR>", { desc = "Edit with instruction" })
map({ "n", "v" }, "<leader><leader>gg", "<cmd>ChatGPTRun grammar_correction<CR>", { desc = "Grammar Correction" })
map({ "n", "v" }, "<leader><leader>gt", "<cmd>ChatGPTRun translate<CR>", { desc = "Translate" })
map({ "n", "v" }, "<leader><leader>gk", "<cmd>ChatGPTRun keywords<CR>", { desc = "Keywords" })
map({ "n", "v" }, "<leader><leader>gd", "<cmd>ChatGPTRun docstring<CR>", { desc = "Docstring" })
map({ "n", "v" }, "<leader><leader>ga", "<cmd>ChatGPTRun add_tests<CR>", { desc = "Add Tests" })
map({ "n", "v" }, "<leader><leader>go", "<cmd>ChatGPTRun optimize_code<CR>", { desc = "Optimize Code" })
map({ "n", "v" }, "<leader><leader>gs", "<cmd>ChatGPTRun summarize<CR>", { desc = "Summarize" })
map({ "n", "v" }, "<leader><leader>gf", "<cmd>ChatGPTRun fix_bugs<CR>", { desc = "Fix Bugs" })
map({ "n", "v" }, "<leader><leader>gx", "<cmd>ChatGPTRun explain_code<CR>", { desc = "Explain Code" })
map({ "n", "v" }, "<leader><leader>gr", "<cmd>ChatGPTRun roxygen_edit<CR>", { desc = "Roxygen Edit" })
map({ "n", "v" }, "<leader><leader>gl", "<cmd>ChatGPTRun code_readability_analysis<CR>",
  { desc = "Code Readability Analysis" })

-- LSP and Gitsigns
wk.add({ { "g", name = "LSP / Gitsigns ..." } })
map("n", "gd", function() vim.lsp.buf.definition() end, { desc = "Definition" })
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "Declaration" })
map("n", "gI", vim.lsp.buf.implementation, { desc = '[G]oto [I]mplementation' })
map("n", "gS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", { desc = '[W]orkspace [S]ymbols' })
map("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", { desc = "Workspace Symbol" })
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Hover" })
map("n", "<space>s", vim.lsp.buf.signature_help, { desc = 'Signature Documentation' })
map("n", "gr", '<cmd>Telescope lsp_references<CR>', { desc = '[G]oto [R]eferences' })
map("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename" })

-- Gitsigns
wk.add({ { "gh", name = "Stage Hunk ..." } })
map({ "n", "v" }, "ghs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Stage Hunk" })
map({ "n", "v" }, "ghu", "<cmd>Gitsigns undo_stage_hunk<CR>", { desc = "Undo Stage" })
map({ "n", "v" }, "ghr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Reset Hunk" })

wk.add({ { "gb", name = "Stage Buffer ..." } })
map({ "n", "v" }, "gbs", "<cmd>Gitsigns stage_buffer<CR>", { desc = "Stage Buffer" })
map({ "n", "v" }, "gbr", "<cmd>Gitsigns reset_buffer<CR>", { desc = "Reset Buffer" })

map("n", "gB", "<cmd>GBrowse<CR>", { desc = "Open the current file, blob, tree, commit, or tag in your browser" })
map("n", "gp", "<cmd>G pull<CR><Esc>", { desc = "Git pull" })
map("n", "gP", "<cmd>G push<CR><Esc>", { desc = "Git push" })
map("n", "gca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Code Action" })

wk.add({ { "gw", name = "Workspace ..." } })
map("n", "gwa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", { desc = "Add Workspace Folder" })
map("n", "gwd", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", { desc = "Delete Workspace Folder" })
map("n", "gwl", "<cmd>lua vim.lsp.buf.list_workspace_folders()<CR>", { desc = '[W]orkspace [L]ist Folders' })

-- Diagnostic navigation
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next({ border = 'rounded' })<CR>", { desc = "Diagnostic Next" })
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev({ border = 'rounded' })<CR>", { desc = "Diagnostic Prev" })

-- Select all
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

map({ 'n', 'v' }, '<space>', '<Nop>', opts)
-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Delete without yank
map("n", "<leader>d", '"_d', { noremap = true })
map("n", "<leader>D", '"_D', { noremap = true })
map("n", "x", '"_x', { noremap = true })
map("n", "<leader>d", '"_d', { noremap = true })
-- Change without yank
map("n", "c", '"_c', { noremap = true })
map("n", "C", '"_C', { noremap = true })
-- Past without change register in visual mode
map("x", "p", '"_dP', { noremap = true })

-- Yank like C/D
map("n", "Y", "y$")

--[[ -- Increment/decrement
map("n", "+", "<C-a>", { noremap = true })
map("n", "-", "<C-x>", { noremap = true }) ]]
-- local keymap = vim.api.nvim_set_keymap
map("n", "<c-s>", ":w<CR>", opts)
map("i", "<c-s>", "<Esc>:w<CR>a", opts)

-- center C-D, C-U
map("n", "<C-d>", "<C-d>zz", { noremap = true })
map("n", "<C-u>", "<C-u>zz", { noremap = true })
--[[ map("n", "<C-f>", "<C-f>zz", { noremap = true }) ]]
--[[ map("n", "<C-b>", "<C-b>zz", { noremap = true }) ]]

-- Undo break points
map("i", ",", ",<c-g>u", { noremap = true })
map("i", ".", ".<c-g>u", { noremap = true })

-- Delete a word backwards
--nnoremap dw vb"_d

-- Clear search highlights.
-- map("", "<Leader><space>", ":let @/=''<CR>", { silent = true }) -- clear the last used search pattern
--[[ map("", "<Leader><space>", ":noh<CR>", { silent = true }) -- turn off highlighting until the next search ]]
-- map("n", "<A-a>", "<C-a>", opts)
-- Select all
-- map("n", "<C-a>", "gg<S-v>G", opts)

--[[ -- newline without entering insert mode ]]
--[[ map("n", "<space>o", "o<Esc>", { noremap = true }) ]]
--[[ map("n", "<space>O", "O<Esc>", { noremap = true }) ]]
-- Use system clipboard
------------------------------------------------------------------------
-- " Copy to clipboard
map("n", "<space>y", '"+y', { noremap = true })
map("v", "<space>y", '"+y', { noremap = true })
map("n", "<space>Y", '"+yg_', { noremap = true })
--[[ map("n", "<space>yy", '"+yy', { noremap = true }) ]]
map("n", "<space>d", '"+d', { noremap = true })
map("v", "<space>d", '"+d', { noremap = true })
map("n", "<space>D", '"+dg_', { noremap = true })

-- 定義函數：將所有 buffer 內容複製到剪貼板，並在每個 buffer 前加上檔案路徑
local function copy_all_buffers_to_clipboard()
  local all_content = "" -- 初始化變數，用於存儲所有內容

  -- 獲取專案根目錄
  local project_root = vim.fn.getcwd() -- 當前工作目錄作為專案根目錄
  if project_root:sub(-1) ~= "/" then
    project_root = project_root .. "/" -- 確保根目錄以 / 結尾
  end

  for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do -- 遍歷所有 buffer
    local buf_path = vim.api.nvim_buf_get_name(buf.bufnr)       -- 獲取 buffer 的完整路徑
    if buf_path ~= "" then                                      -- 檢查是否為有效檔案
      -- 計算相對路徑
      local relative_path = buf_path:gsub(project_root, "")     -- 從完整路徑中移除專案根目錄
      relative_path = "/" .. relative_path                      -- 加上 / 作為根目錄標記

      -- 讀取 buffer 內容
      local lines = vim.fn.getbufline(buf.bufnr, 1, '$') -- 獲取所有行
      local buf_content = table.concat(vim.tbl_map(function(line)
        return tostring(line)                            -- 確保每一行都是字符串
      end, lines), "\n")

      -- 將檔案路徑和內容追加到變數
      all_content = all_content .. "//file: " .. relative_path .. "\n" .. buf_content .. "\n\n"
    end
  end

  vim.fn.setreg('+', all_content) -- 將所有內容寫入系統剪貼板
  vim.notify("All buffers copied to clipboard with file paths!", vim.log.levels.INFO)
end

-- 定義函數：將當前窗口的內容複製到剪貼板，並在最前面加上檔案路徑
local function copy_current_window_to_clipboard()
  local buf_path = vim.api.nvim_buf_get_name(0) -- 獲取當前 buffer 的完整路徑
  if buf_path ~= "" then
    -- 獲取專案根目錄
    local project_root = vim.fn.getcwd()
    if project_root:sub(-1) ~= "/" then
      project_root = project_root .. "/"
    end

    -- 計算相對路徑
    local relative_path = buf_path:gsub(project_root, "")
    relative_path = "/" .. relative_path

    -- 讀取當前 buffer 的所有內容（整個檔案）
    local lines = vim.fn.getbufline(vim.api.nvim_get_current_buf(), 1, '$')
    local win_content = table.concat(vim.tbl_map(function(line)
      return tostring(line)
    end, lines), "\n")

    -- 組合檔案路徑和內容
    local content_to_copy = "//file: " .. relative_path .. "\n" .. win_content

    vim.fn.setreg('+', content_to_copy) -- 將內容寫入系統剪貼板
    vim.notify("Current file content copied to clipboard with file path!", vim.log.levels.INFO)
  else
    vim.notify("No file name for current buffer!", vim.log.levels.WARN)
  end
end

-- 映射快捷鍵
map("n", "<space>by", copy_all_buffers_to_clipboard, { desc = "Copy all buffers to clipboard with file paths" })
map("n", "<space>wy", copy_current_window_to_clipboard,
  { desc = "Copy current file content to clipboard with file path" })

-- " Paste from clipboard
--[[ map("n", "<leader>p", '"+p', { noremap = true }) ]]
--[[ map("n", "<leader>P", '"+P', { noremap = true }) ]]
--[[ map("v", "<leader>p", '"+p', { noremap = true }) ]]
--[[ map("v", "<leader>P", '"+P', { noremap = true }) ]]
-- Tabs
----------------------------------------------------------------------
-- Open current directory
map("n", "te", ":tabedit")
--nmap <S-Tab> :tabprev<Return>
--nmap <Tab> :tabnext<Return>
-- map("n", "<Tab>", ":bnext<CR>")
-- map("n", "<S-Tab>", ":bprevious<CR>")
--[[ map("n", "<Tab>", ":BufferLineCycleNext<CR>") ]]
--[[ map("n", "<S-Tab>", ":BufferLineCyclePrev<CR>") ]]
-- vim.autocmd()
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "lua", "python", "javascript", "fish" },
--   callback = function()
--     local data = {
--       buf = vim.fn.expand("<abuf>"),
--       file = vim.fn.expand("<afile>"),
--       file2 = vim.fn.expand("%"),
--       match = vim.fn.expand("<amatch>"), -- matched pattern
--     }
--
--     -- vim.schedule(function()
--     --   print("echo 'Hello")
--     --   print(vim.inspect(data))
--     -- end)
--
--     vim.cmd("echo 'hi'")
--   end,
-- })

-- Window management
wk.add({ { "s", group = "Switching" } })
map("n", "ss", "<cmd>split<Return>", { desc = "Split" })
map("n", "sv", "<cmd>vsplit<Return>", { desc = "Vertical Split" })
map("n", "se", "<cmd>Oil --float<cr>", { desc = "Oil file [E]xplorer" })
map("n", "sf", "<cmd>VimFilerBufferDir<Return>", { desc = "VimFiler Buffer Dir" })
map("n", "sF", "<cmd>VimFilerExplorer -find<Return>", { desc = "VimFiler Explorer" })
map("n", "so", "<cmd>Telescope oldfiles<CR>", { desc = "[s]earch [o]ldfiles" })
map("n", "sb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
map("n", "sw", "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>",
  { desc = "[S]earch [W]orktree" })
map("n", "sW", "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>",
  { desc = "[S]et [W]orktree" })
map("n", "sh", "<C-w>h", { desc = "Jump left" })
map("n", "sk", "<C-w>k", { desc = "Jump up" })
map("n", "sj", "<C-w>j", { desc = "Jump down" })
map("n", "sl", "<C-w>l", { desc = "Jump right" })
map("n", "sp", "<C-w>p", { desc = "Switch to previous windows" })
map("n", "sr", "<C-w>r", { desc = "Rotate down/right" })
map("n", "sR", "<C-w>R", { desc = "Rotate up/left" })
map("n", "sx", "<C-w>x", { desc = "Exchange with next one" })
map("n", "s<left>", "<C-w>H", { desc = "Move to the far left" })
map("n", "s<down>", "<C-w>J", { desc = "Move to the very bottom" })
map("n", "s<up>", "<C-w>K", { desc = "Move to the very top" })
map("n", "s<right>", "<C-w>L", { desc = "Move to the far right" })
map("n", "sL", "<C-w>10>", { desc = "+ width" })
map("n", "sH", "<C-w>10<", { desc = "- width" })
map("n", "sK", "<C-w>10+", { desc = "+ height" })
map("n", "sJ", "<C-w>10-", { desc = "- height" })
map("n", "sq", "<C-w>q", { desc = "Quit a window" })
map("n", "s=", "<C-w>=", { desc = "Resize all - split windows" })
map("n", "s_", "<C-w>_", { desc = "Maximum height window" })
map("n", "s|", "<C-w>|", { desc = "Maximum width window" })
map("n", "sz", "<C-w>_<C-w>|", { desc = "Zoom" })
map("n", "sM", "<C-w>_<C-w>|", { desc = "Zoom Maximum" })
-- Additional window resize mappings
map("n", "<C-w><right>", "<C-w>10>", { desc = "+ width" })
map("n", "<C-w><left>", "<C-w>10<", { desc = "- width" })
map("n", "<C-w><up>", "<C-w>10+", { desc = "+ height" })
map("n", "<C-w><down>", "<C-w>10-", { desc = "- height" })

-- Trouble
wk.add({ { "st", name = "Trouble ..." } })
map("n", "stt", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "stb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
map("n", "sts", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
map("n", "stq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
map("n", "stL", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
  { desc = "LSP Definitions / references / ... (Trouble)" })
map("n", "stl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
map("n", "str", "<cmd>TroubleToggle lst_references<cr>", { desc = "Trouble, LSP Reference" })
map("n", "stn", "<cmd>lua require('trouble').next({skip_groups = true, jump = true})<cr>", { desc = "[N]ext trouble" })
map("n", "stp", "<cmd>lua require('trouble').prev({skip_groups = true, jump = true})<cr>",
  { desc = "[P]revious trouble" })

-- DAP (Debugger)
wk.add({ { "<space>d", name = "Neovim DAP ..." } })
map("n", "<space>dc", '<cmd>lua require"dap".clear_breakpoints()<CR>', { desc = "Clear Breakpoints" })
map("n", "<space>de", '<cmd>lua require"dap".set_exception_breakpoints({"all"})<CR>',
  { desc = "Set Exception Breakpoints" })
map("n", "<space>dl", "<cmd>Telescope dap list_breakpoints<CR>", { desc = "List Breakpoints" })
map("n", "<space>dk", '<cmd>lua require"dap".up()<CR>zz', { desc = "Up" })
map("n", "<space>dj", '<cmd>lua require"dap".down()<CR>zz', { desc = "Down" })
map("n", "<space>dt", '<cmd>lua require"dap".terminate()<CR>', { desc = "Terminate" })
map("n", "<space>dr", '<cmd>lua require"dap".repl.toggle({}, "split")<CR><C-w>j<C-W>J', { desc = "Toggle Repl" })
map("n", "<space>ds", '<cmd>lua local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes)<CR>',
  { desc = "Scopes" })
map("n", "<space>dE", "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<CR>", { desc = "Evaluate Input" })
map("n", "<space>d?", "<cmd>Telescope dap commands<CR>", { desc = "List Commands" })
map("n", "<space>b", '<cmd>lua require"dap".toggle_breakpoint()<CR>', { desc = "Toggle Breakpoint" })
map("n", "<space>B", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
  { desc = "Conditional Breakpoint" })
map("n", "<space>c", '<cmd>silent w<CR> :lua require"dap".continue()<CR>', { desc = "Continue" })
map("n", "<space>x", "<cmd>lua require'dap'.close()<cr>", { desc = "Quit" })
map("n", "<space>j", '<cmd>lua require"dap".step_over()<CR>', { desc = "Step Over" })
map("n", "<space>i", '<cmd>lua require"dap".step_into()<CR>', { desc = "Step Into" })
map("n", "<space>o", '<cmd>lua require"dap".step_out()<CR>', { desc = "Step Out" })
map("n", "<space>n", '<cmd>lua require"dap".run_to_cursor()<CR>', { desc = "Run to Cursor" })
map("n", "<space>K", "<cmd>lua require'dap.ui.widgets'.hover()<CR>", { desc = "Hover Variables by DAP" })
map("n", "<space>w", "<cmd>lua require'dapui'.toggle()<cr>", { desc = "Toggle UI" })
map("n", "<space>e", '<cmd>lua require"dap".repl.toggle({}, "split")<CR><C-w>j<C-W>J', { desc = "Toggle Repl" })


-- TODO
-- ["<F5>"] = { '<cmd>lua require"dap".step_out()<CR>', "Step Out" },
-- f8 = { '<cmd>lua require"dap".step_over()<CR>', "Step Over" },
-- f7 = { '<cmd>lua require"dap".step_into()<CR>', "Step Into" },
-- f9 = { '<cmd>w<CR> :lua require"dap".continue()<CR>', "Continue" },

-- wk.add({ { "m", group = "Mark by Harpoon" } })
-- map("n", "sm", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", { desc = "Marks Table" })
-- map("n", "<C-n>", "<cmd>lua require('harpoon.ui').nav_next()<CR>", { desc = "Next mark" })
-- map("n", "<C-p>", "<cmd>lua require('harpoon.ui').nav_prev()<CR>", { desc = "Prev mark" })
-- map("n", "ma",
--   "<cmd>lua require('harpoon.mark').add_file(); vim.notify(vim.fn.expand('%:t') .. ' marked', vim.log.levels.INFO)<CR>",
--   { desc = "[M]ark [A]dd" })
-- map("n", "md",
--   "<cmd>lua require('harpoon.mark').rm_file(); vim.notify(vim.fn.expand('%:t') .. ' unmarked', vim.log.levels.INFO)<CR>",
--   { desc = "[M]ark [D]eleted" })
-- map("n", "mc", "<cmd>lua require('harpoon.mark').clear_all(); vim.notify('All marks cleared', vim.log.levels.INFO)<CR>",
--   { desc = "[M]arks [C]leared" })
-- for i = 0, 9 do
--   map("n", string.format("m%s", i), string.format("<cmd>lua require('harpoon.ui').nav_file(%s)<CR>", i),
--     { desc = string.format("Go to mark %s", i) })
-- end


local gs = package.loaded.gitsigns
map('n', ']g', function()
  if vim.wo.diff then return ']g' end
  vim.schedule(function() gs.next_hunk() end)
  return '<Ignore>'
end, { expr = true, desc = "Next Hunk" })
map('n', '[g', function()
  if vim.wo.diff then return '[g' end
  vim.schedule(function() gs.prev_hunk() end)
  return '<Ignore>'
end, { expr = true, desc = "Prev Hunk" })
-- map('n', 'ghs', gs.stage_hunk, { desc = "Stage Hunk" })
-- map('v', 'ghs', function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end, { desc = "Stage Hunk by range" })
-- map('n', "ghr", gs.reset_hunk, { desc = "Reset Hunk" })
-- map('v', 'ghr', function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end, { desc = "Reset Hunk by range" })
-- map('n', 'gbs', gs.stage_buffer, { desc = "Stage Buffer" })
-- map('n', 'gbr', gs.reset_buffer, { desc = "Reset Buffer" })

-- Git operations
map('n', '<space>gb', function() require('gitsigns').blame_line { full = true } end, { desc = "Blame Line" })
map('n', '<space>hp', require('gitsigns').preview_hunk, { desc = "Preview Hunk" })
map('n', '<space>tb', require('gitsigns').toggle_current_line_blame, { desc = "Toggle Current Line Blame" })
map('n', '<space>gd', require('gitsigns').diffthis, { desc = "Diff This" })
map('n', '<space>gD', function() require('gitsigns').diffthis('~') end, { desc = "Diff This ~" })
map('n', "<space>gv", "<cmd>Gvdiffsplit<CR>", { desc = "Gvdiffsplit" })
map('n', "<space>gs", "<cmd>Gdiffsplit<CR>", { desc = "Gdiffsplit" })
map('n', "<space>gw", "<cmd>windo diffthis<CR>", { desc = "Diff windows" })
map('n', "<space>gf", "<cmd>GV!<CR>", { desc = "list commits for current file" })
map('n', "<space>gl", "<cmd>GV?<CR>", { desc = "fills the location list with the revisions of the current file" })
map('n', "<space>gF", "<cmd>GV<CR>", { desc = "open commit browser" })
map('n', "<space>dp", "<cmd>diffput<CR>", { desc = "diffput" })
map('n', "<space>dg", "<cmd>diffget<CR>", { desc = "diffget" })


-- Text object
map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>',
  { desc = "Select Hunk, used in visual or followed by d/y commands" })


vim.cmd([[
" Save with root permission
command! W w !sudo tee > /dev/null %

" autocmd FileType python map <buffer> <F5> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
" autocmd FileType python imap <buffer> <F5> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>
" autocmd FileType python map <buffer> <F5> :w<CR>:exec '!python' '%'<CR>
" autocmd FileType python imap <buffer> <F5> <esc>:w<CR>:exec '!python' '%'<CR>
" TODO F6 to open book url in browser
" :!open "https://play.google.com/books/reader?id=nFRWEAAAQBAJ&pg=GBS.SA4-PA15"
" utocmd FileType python map <buffer> <F6> :echo expand('%:t') \| exec 's/\-*//'<CR>
" utocmd FileType python imap <buffer> <F5> <esc>:w<CR>:terminal python %<CR>

if executable("python3")
  " autocmd FileType python noremap <buffer> <F5> :w<CR>:split<CR>:terminal python '%'<CR>
  " autocmd FileType python noremap <buffer> <F5> :w<CR>:TermExec cmd='python3 "%"' direction='horizontal' size=15<CR>
  autocmd FileType python noremap <buffer> go :w<CR>:TermExec cmd='python3 "%"' direction='horizontal' size=15<CR>
else
  " autocmd FileType python noremap <buffer> <F5> :echo "Need to install Python3 first!"<CR>
  autocmd FileType python noremap <buffer> go :echo "Need to install Python3 first!"<CR>
endif

if executable("fish")
  " autocmd FileType fish noremap <buffer> <F5> :w<CR>:split<CR> :terminal fish '%'<CR>
  " autocmd FileType fish noremap <buffer> <F5> :w<CR>:TermExec cmd='fish "%"' direction='horizontal' size=15<CR>
  autocmd FileType fish noremap <buffer> go :w<CR>:TermExec cmd='fish "%"' direction='horizontal' size=15<CR>
else
  " autocmd FileType fish noremap <buffer> <F5> :echo "Need to install fish first!"<CR>
  autocmd FileType fish noremap <buffer> go :echo "Need to install fish first!"<CR>
endif

if executable("node")
  " autocmd FileType javascript noremap <buffer> <F5> :w<CR>:split<CR>:terminal node '%'<CR>
  " autocmd FileType javascript noremap <buffer> <F5> :w<CR>:TermExec cmd='node "%"' direction='horizontal' size=15<CR>
  autocmd FileType javascript noremap <buffer> go :w<CR>:TermExec cmd='node "%"' direction='horizontal' size=15<CR>
else
  " autocmd FileType javascript noremap <buffer> <F5> :echo "Need to install Node first!"<CR>
  autocmd FileType javascript noremap <buffer> go :echo "Need to install Node first!"<CR>
end

if executable("lua")
  " autocmd FileType lua noremap <buffer> <F5> :w<CR>:split<CR>:terminal lua '%'<CR>
  " autocmd FileType lua noremap <buffer> <F5> :w<CR>:TermExec cmd='lua "%"' direction='horizontal' size=15<CR>
  autocmd FileType lua noremap <buffer> go :w<CR>:TermExec cmd='lua "%"' direction='horizontal' size=15<CR>
else
  " autocmd FileType lua noremap <buffer> <F5> :echo "Need to install Lua first!"<CR>
  autocmd FileType lua noremap <buffer> go :echo "Need to install Lua first!"<CR>
end

if executable("ts-node")
  " autocmd FileType lua noremap <buffer> <F5> :w<CR>:split<CR>:terminal lua '%'<CR>
  " autocmd FileType typescript noremap <buffer> <F5> :w<CR>:TermExec cmd='ts-node "%"' direction='horizontal' size=15<CR>
  autocmd FileType typescript noremap <buffer> go :w<CR>:TermExec cmd='ts-node "%"' direction='horizontal' size=15<CR>
else
  " autocmd FileType typescript noremap <buffer> <F5> :echo "Need to 'npm i ts-node' first!"<CR>
  autocmd FileType typescript noremap <buffer> go :echo "Need to 'npm i ts-node' first!"<CR>
end

if executable("gcc")
  " For C files
  autocmd FileType c noremap <buffer> go :w<CR>:TermExec cmd='gcc "%" -o "%:r" && "./%:r"' direction='horizontal' size=15<CR>
else
  autocmd FileType c noremap <buffer> go :echo "Need to install gcc first!"<CR>
end

if executable("g++")
  " For C++ files
  autocmd FileType cpp noremap <buffer> go :w<CR>:TermExec cmd='g++ "%" -o "%:r" && "./%:r"' direction='horizontal' size=15<CR>
else
  autocmd FileType cpp noremap <buffer> go :echo "Need to install g++ first!"<CR>
end

if executable("coffee")
  " For CoffeeScript files
  autocmd FileType coffee noremap <buffer> go :w<CR>:TermExec cmd='coffee "%" -o "%:r" && "./%:r"' direction='horizontal' size=15<CR>
else
  autocmd FileType coffee noremap <buffer> go :echo "Need to install coffeescript first!"<CR>
end
]])


-- Telescope
----------------------------------------------------------------------
-- map("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
-- map("n", "<leader>r", "<cmd>Telescope live_grep<cr>", opts)
-- map("n", "<leader>b", "<cmd>Telescope buffers<cr>", opts)
-- map("n", "<leader>m", "<cmd>Telescope bookmarks<cr>", opts)
-- map("n", "<leader>h", "<cmd>Telescope help_tags<cr>", opts)
-- map("n", "<leader>gs", "<cmd>Telescope git_status<cr>", opts)
-- map("n", "<leader>gf", "<cmd>Telescope git_files<cr>", opts)
-- map("n", "<leader>z", ":lua require'telescope'.extensions.zoxide.list{}<CR>", opts)
-- -- keymap("n", "<leader>f", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
-- -- map(
-- -- 	"n",
-- -- 	"<leader>f",
-- -- 	"<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>",
-- -- 	opts
-- -- )

-- HTML/JSX element navigation with treesitter

-- Debug function for printing node info
-- local function debug_node(node, prefix)
--   if not node then return "nil" end
--   local result = string.format("%sType: %s\n", prefix or "", node:type())
--   for i = 0, node:child_count() - 1 do
--     local child = node:child(i)
--     result = result .. debug_node(child, (prefix or "") .. "  ")
--   end
--   return result
-- end

local function find_jsx_parent(node)
  if not node then return nil end

  local parent = node:parent()
  while parent do
    -- 检查是否在 JSX 表达式中
    if parent:type() == "jsx_expression" then
      -- 继续向上查找，直到找到 jsx_attribute
      local next_parent = parent:parent()
      while next_parent do
        if next_parent:type() == "jsx_attribute" then
          -- 找到包含此属性的 self-closing tag
          local tag_parent = next_parent:parent()
          if tag_parent and tag_parent:type() == "jsx_self_closing_element" then
            return tag_parent
          end
        end
        next_parent = next_parent:parent()
      end
    end
    -- 检查是否是 JSX 元素
    if parent:type() == "jsx_element" or
        parent:type() == "jsx_fragment" or
        parent:type() == "jsx_self_closing_element" then
      return parent
    end
    parent = parent:parent()
  end
  return nil
end

local function find_jsx_in_node(node)
  if not node then return nil end

  -- 直接返回JSX元素
  if node:type() == "jsx_element" or
      node:type() == "jsx_fragment" or
      node:type() == "jsx_self_closing_element" then
    return node
  end

  -- 遍历所有子节点
  for i = 0, node:child_count() - 1 do
    local child = node:child(i)
    -- 递归检查每个子节点
    local result = find_jsx_in_node(child)
    if result then
      return result
    end
  end

  return nil
end

local function get_first_jsx_in_map(expression)
  -- print("\n=== Checking map expression ===")
  -- print("Expression type: " .. expression:type())

  -- 找到 map 调用
  local call_node = nil
  for i = 0, expression:child_count() - 1 do
    local child = expression:child(i)
    -- print("Child type: " .. child:type())
    if child:type() == "call_expression" then
      call_node = child
      break
    end
  end

  if not call_node then
    -- print("No call_expression found")
    return nil
  end

  -- 遍历 call_expression 的参数
  for i = 0, call_node:child_count() - 1 do
    local child = call_node:child(i)
    -- print("Call child type: " .. child:type())

    -- 检查是否是参数列表
    if child:type() == "arguments" then
      -- print("Found arguments")
      -- 查找箭头函数参数
      for j = 0, child:child_count() - 1 do
        local arg = child:child(j)
        -- print("Argument type: " .. arg:type())

        if arg:type() == "arrow_function" then
          -- print("Found arrow function")
          -- 获取箭头函数的主体
          for k = 0, arg:child_count() - 1 do
            local func_part = arg:child(k)
            -- print("Function part type: " .. func_part:type())

            -- 处理箭头函数主体（可能被括号包裹）
            if func_part:type() == "parenthesized_expression" then
              for l = 0, func_part:child_count() - 1 do
                local body_item = func_part:child(l)
                -- print("Body item type: " .. body_item:type())

                if body_item:type() == "jsx_element" then
                  -- print("Found JSX element in map!")
                  return body_item
                end
              end
            end
          end
        end
      end
    end
  end

  -- print("No JSX found in map")
  return nil
end

local function find_next_map_expression(node)
  if not node then return nil end
  -- print("\n=== Finding next map expression ===")
  -- print("Starting from node type: " .. node:type())

  local ts_utils = require('nvim-treesitter.ts_utils')
  local current = node

  -- 寻找下一个兄弟节点
  local next_node = ts_utils.get_next_node(current, true, true)
  while next_node do
    -- print("Checking next node type: " .. next_node:type())
    -- 当找到 jsx_expression 时，尝试在其中查找 map
    if next_node:type() == "jsx_expression" then
      -- print("Found jsx_expression")

      -- 首先尝试直接在表达式中查找 JSX 元素
      for i = 0, next_node:child_count() - 1 do
        local child = next_node:child(i)
        if child:type() == "call_expression" then
          -- 检查是否是 map 调用
          local first_child = child:child(0)
          if first_child and first_child:type() == "member_expression" then
            -- print("Found potential map call")
            local map_jsx = get_first_jsx_in_map(next_node)
            if map_jsx then
              return map_jsx
            end
          end
        end
      end
    end
    next_node = ts_utils.get_next_node(next_node, true, true)
  end

  -- print("No map expression found")
  return nil
end

local function get_jsx_from_attribute_value(attr_value)
  if not attr_value then return nil end

  if attr_value:type() == "jsx_expression" then
    -- 遍历表达式的内容
    for i = 0, attr_value:child_count() - 1 do
      local expr_child = attr_value:child(i)

      if expr_child:type() == "arrow_function" then
        -- 获取箭头函数的主体
        for j = 0, expr_child:child_count() - 1 do
          local func_child = expr_child:child(j)
          if func_child:type() == "parenthesized_expression" then
            local jsx = find_jsx_in_node(func_child)
            if jsx then return jsx end
          end
        end
      else
        -- 对于非箭头函数的表达式，直接搜索JSX
        local jsx = find_jsx_in_node(expr_child)
        if jsx then return jsx end
      end
    end
  end
  return nil
end

local function get_first_jsx_in_attributes(node)
  -- 遍历所有属性
  for i = 0, node:child_count() - 1 do
    local child = node:child(i)
    if child:type() == "jsx_attribute" then
      for j = 0, child:child_count() - 1 do
        local attr_part = child:child(j)
        local jsx = get_jsx_from_attribute_value(attr_part)
        if jsx then return jsx end
      end
    end
  end
  return nil
end

local function get_first_child(node)
  if not node then return nil end
  -- print("\n=== Getting first child ===")
  -- print("Parent node type: " .. node:type())
  -- print("Full node structure:")
  -- print(debug_node(node))

  -- 首先检查直接子元素
  local has_children = false
  for i = 0, node:child_count() - 1 do
    local child = node:child(i)
    -- print("Checking direct child type: " .. child:type())
    if child:type() == "jsx_element" or
        child:type() == "jsx_fragment" or
        child:type() == "jsx_self_closing_element" then
      has_children = true
      -- print("Found direct JSX child")
      return child
    end
  end

  -- 如果是self-closing标签，检查其属性中的JSX
  if node:type() == "jsx_self_closing_element" then
    -- print("Checking self-closing tag attributes")
    local jsx_in_attr = get_first_jsx_in_attributes(node)
    if jsx_in_attr then
      -- print("Found JSX in attributes")
      return jsx_in_attr
    end
  end

  -- 如果没有子元素，尝试查找下一个 map 表达式中的元素
  if not has_children then
    -- print("No direct children, looking for map")
    local map_jsx = find_next_map_expression(node)
    if map_jsx then
      -- print("Found JSX in map")
      return map_jsx
    end
  end

  -- print("No children or map found")
  return nil
end

local function is_jsx_node(node)
  if not node then return false end
  local type = node:type()
  return type == "jsx_element" or
      type == "jsx_fragment" or
      type == "jsx_self_closing_element"
end

local function get_next_sibling(node)
  local ts_utils = require('nvim-treesitter.ts_utils')
  local current = node

  -- 如果节点在JSX表达式内，先找到最外层的JSX父节点
  if not is_jsx_node(current) then
    current = find_jsx_parent(current)
  end

  if not current then return nil end

  local next_node = ts_utils.get_next_node(current, true, true)
  while next_node ~= nil and next_node:parent() == current:parent() do
    if is_jsx_node(next_node) then
      return next_node
    end
    next_node = ts_utils.get_next_node(next_node, true, true)
  end
  return nil
end

local function get_previous_sibling(node)
  local ts_utils = require('nvim-treesitter.ts_utils')
  local current = node

  -- 如果节点在JSX表达式内，先找到最外层的JSX父节点
  if not is_jsx_node(current) then
    current = find_jsx_parent(current)
  end

  if not current then return nil end

  local prev_node = ts_utils.get_previous_node(current, true, true)
  while prev_node ~= nil and prev_node:parent() == current:parent() do
    if is_jsx_node(prev_node) then
      return prev_node
    end
    prev_node = ts_utils.get_previous_node(prev_node, true, true)
  end
  return nil
end

local function get_master_node()
  local ts_utils = require('nvim-treesitter.ts_utils')
  local node = ts_utils.get_node_at_cursor()
  if node == nil then return nil end

  local start_row = node:start()
  local parent = node:parent()

  while parent ~= nil and parent:start() == start_row do
    node = parent
    parent = node:parent()
  end

  return node
end

local function goto_child_or_sibling_node()
  local ts_utils = require('nvim-treesitter.ts_utils')
  local node = get_master_node()
  if node == nil then return end

  -- Try to get child first
  local child = get_first_child(node)
  if child ~= nil then
    ts_utils.goto_node(child)
    return
  end

  -- If no child found, try to get next sibling
  local sibling = get_next_sibling(node)
  if sibling ~= nil then
    ts_utils.goto_node(sibling)
  end
end

local function goto_parent_node()
  local ts_utils = require('nvim-treesitter.ts_utils')
  local node = get_master_node()
  if node == nil then return end

  -- Try to find parent JSX element
  local parent = find_jsx_parent(node)
  if parent then
    ts_utils.goto_node(parent)
  end
end

local function goto_next_sibling_node()
  local ts_utils = require('nvim-treesitter.ts_utils')
  local node = get_master_node()
  if node == nil then return end

  local sibling = get_next_sibling(node)
  if sibling ~= nil then
    ts_utils.goto_node(sibling)
  end
end

local function goto_prev_sibling_node()
  local ts_utils = require('nvim-treesitter.ts_utils')
  local node = get_master_node()
  if node == nil then return end

  local sibling = get_previous_sibling(node)
  if sibling ~= nil then
    ts_utils.goto_node(sibling)
  end
end

local function goto_root_node()
  local ts_utils = require('nvim-treesitter.ts_utils')
  local node = ts_utils.get_node_at_cursor()
  if node == nil then return end

  local root = node
  while node ~= nil do
    local type = node:type()
    if type == "jsx_element" or
        type == "jsx_fragment" or
        type == "jsx_self_closing_element" or
        type == "element" then
      root = node
    end
    node = node:parent()
  end

  ts_utils.goto_node(root)
end

-- 创建 Filetype autocmd
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "typescriptreact", "javascriptreact" },
  callback = function()
    -- Original mappings
    vim.keymap.set("n", "[t", function()
      local filetype = vim.bo.filetype
      if filetype == "typescriptreact" or filetype == "javascriptreact" then
        local ts_utils = require('nvim-treesitter.ts_utils')
        local node = ts_utils.get_node_at_cursor()
        if node == nil then return end

        while node ~= nil do
          if node:type() == "jsx_element" or
              node:type() == "jsx_fragment" or
              node:type() == "jsx_self_closing_element" then
            goto_parent_node()
            return
          end
          node = node:parent()
        end
      else
        goto_parent_node()
      end
    end, { buffer = true, desc = "Goto parent HTML/JSX element" })

    vim.keymap.set("n", "]t", function()
      local filetype = vim.bo.filetype
      if filetype == "typescriptreact" or filetype == "javascriptreact" then
        local ts_utils = require('nvim-treesitter.ts_utils')
        local node = ts_utils.get_node_at_cursor()
        if node == nil then return end

        while node ~= nil do
          if node:type() == "jsx_element" or
              node:type() == "jsx_fragment" or
              node:type() == "jsx_self_closing_element" then
            goto_child_or_sibling_node()
            return
          end
          node = node:parent()
        end
      else
        goto_child_or_sibling_node()
      end
    end, { buffer = true, desc = "Goto child, expression, or next sibling HTML/JSX element" })

    -- New sibling navigation mappings
    vim.keymap.set("n", "]s", function()
      local filetype = vim.bo.filetype
      if filetype == "typescriptreact" or filetype == "javascriptreact" then
        goto_next_sibling_node()
      end
    end, { buffer = true, desc = "Goto next sibling HTML/JSX element" })

    vim.keymap.set("n", "[s", function()
      local filetype = vim.bo.filetype
      if filetype == "typescriptreact" or filetype == "javascriptreact" then
        goto_prev_sibling_node()
      end
    end, { buffer = true, desc = "Goto previous sibling HTML/JSX element" })

    -- Root navigation mapping
    vim.keymap.set("n", "[r", function()
      local filetype = vim.bo.filetype
      if filetype == "typescriptreact" or filetype == "javascriptreact" then
        local ts_utils = require('nvim-treesitter.ts_utils')
        local node = ts_utils.get_node_at_cursor()
        if node == nil then return end

        while node ~= nil do
          if node:type() == "jsx_element" or
              node:type() == "jsx_fragment" or
              node:type() == "jsx_self_closing_element" then
            goto_root_node()
            return
          end
          node = node:parent()
        end
      else
        goto_root_node()
      end
    end, { buffer = true, desc = "Goto root HTML/JSX element" })
  end
})
