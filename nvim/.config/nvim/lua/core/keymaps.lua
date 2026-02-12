-- nvim/.config/nvim/lua/core/keymaps.lua
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local wk = require("which-key")

-- BufOnly: close all buffers except current
vim.api.nvim_create_user_command("BufOnly", function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end
end, {})

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
map(
  "n",
  "<leader><leader>rsf",
  ":!open https://github.com/rafamadriz/friendly-snippets/wiki<CR>",
  { desc = "Read Doc of friendly snippets" }
)
map(
  "n",
  "<leader><leader>rsv",
  ":!open https://github.com/honza/vim-snippets/tree/master/snippets<CR>",
  { desc = "Read Doc of vim-snippets" }
)

-- Utility
map("n", "<space>m", ":message<CR>", { desc = "message" })
map("n", "<space>L", "<cmd>LspInfo<CR>", { desc = "LSP Info" })
map("n", "<space>M", "<cmd>Mason<CR>", { desc = "Mason LSP manager" })
map("n", "<space>W", "<cmd>WhichKey<CR>", { desc = "WhichKey menu" })
map("n", "<space>/", "<cmd>Telescope keymaps<CR>", { desc = "Query Keymaps by Telescope" })
map("n", "<space>?", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
map("n", "<leader>f", function()
  require("conform").format({
    timeout_ms = 500,
    lsp_format = "fallback",
  })
end, { desc = "Format current buffer" })

-- 複製絕對路徑函數
local function copy_absolute_path()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Absolute filepath copied", vim.log.levels.INFO)
end

-- 複製相對路徑函數
local function copy_relative_path()
  local path =
    vim.fn.substitute(vim.fn.expand("%:p"), vim.fn.fnamemodify(vim.fn.finddir(".git", ";"), ":p:h:h") .. "/", "", "")
  vim.fn.setreg("+", path)
  vim.notify("Relative filepath copied", vim.log.levels.INFO)
end

-- 複製所有 buffers 的絕對路徑函數
local function copy_all_buffer_absolute_paths()
  local paths = {} -- 初始化陣列，用於存儲所有路徑

  for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do -- 遍歷所有 buffer
    local buf_path = vim.api.nvim_buf_get_name(buf.bufnr) -- 獲取 buffer 的完整路徑
    if buf_path ~= "" then -- 檢查是否為有效檔案
      table.insert(paths, buf_path) -- 添加絕對路徑到陣列
    end
  end

  if #paths > 0 then
    local all_paths = table.concat(paths, "\n") -- 將所有路徑合併成字串，以換行符分隔
    vim.fn.setreg("+", all_paths) -- 將所有路徑寫入系統剪貼板
    vim.notify("All buffer absolute paths copied to clipboard!", vim.log.levels.INFO)
  else
    vim.notify("No valid buffers found", vim.log.levels.WARN)
  end
end

-- 複製 quickfix 中的絕對路徑函數
local function copy_quickfix_absolute_paths()
  local paths = {} -- 初始化陣列，用於存儲所有路徑

  -- 取得 quickfix 列表
  local qf_items = vim.fn.getqflist()
  for _, item in ipairs(qf_items) do
    if item.bufnr > 0 then
      local buf_path = vim.api.nvim_buf_get_name(item.bufnr) -- 獲取 buffer 的完整路徑
      if buf_path ~= "" then -- 檢查是否為有效檔案
        -- 避免重複路徑
        if not vim.tbl_contains(paths, buf_path) then
          table.insert(paths, buf_path) -- 添加絕對路徑到陣列
        end
      end
    end
  end

  if #paths > 0 then
    local all_paths = table.concat(paths, "\n") -- 將所有路徑合併成字串，以換行符分隔
    vim.fn.setreg("+", all_paths) -- 將所有路徑寫入系統剪貼板
    vim.notify("All quickfix absolute paths copied to clipboard!", vim.log.levels.INFO)
  else
    vim.notify("No valid paths in quickfix list", vim.log.levels.WARN)
  end
end

-- 複製所有 buffers 的相對路徑函數
local function copy_all_buffer_relative_paths()
  local paths = {} -- 初始化陣列，用於存儲所有路徑

  -- 獲取專案根目錄
  local project_root = vim.fn.getcwd() -- 當前工作目錄作為專案根目錄
  if project_root:sub(-1) ~= "/" then
    project_root = project_root .. "/" -- 確保根目錄以 / 結尾
  end

  for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do -- 遍歷所有 buffer
    local buf_path = vim.api.nvim_buf_get_name(buf.bufnr) -- 獲取 buffer 的完整路徑
    if buf_path ~= "" then -- 檢查是否為有效檔案
      -- 計算相對路徑
      local relative_path = buf_path:gsub(project_root, "")
      table.insert(paths, relative_path) -- 添加相對路徑到陣列
    end
  end

  if #paths > 0 then
    local all_paths = table.concat(paths, "\n") -- 將所有路徑合併成字串，以換行符分隔
    vim.fn.setreg("+", all_paths) -- 將所有路徑寫入系統剪貼板
    vim.notify("All buffer relative paths copied to clipboard!", vim.log.levels.INFO)
  else
    vim.notify("No valid buffers found", vim.log.levels.WARN)
  end
end

-- 複製 quickfix 中的相對路徑函數
local function copy_quickfix_relative_paths()
  local paths = {} -- 初始化陣列，用於存儲所有路徑

  -- 獲取專案根目錄
  local project_root = vim.fn.getcwd() -- 當前工作目錄作為專案根目錄
  if project_root:sub(-1) ~= "/" then
    project_root = project_root .. "/" -- 確保根目錄以 / 結尾
  end

  -- 取得 quickfix 列表
  local qf_items = vim.fn.getqflist()
  for _, item in ipairs(qf_items) do
    if item.bufnr > 0 then
      local buf_path = vim.api.nvim_buf_get_name(item.bufnr) -- 獲取 buffer 的完整路徑
      if buf_path ~= "" then -- 檢查是否為有效檔案
        -- 計算相對路徑
        local relative_path = buf_path:gsub(project_root, "")
        -- 避免重複路徑
        if not vim.tbl_contains(paths, relative_path) then
          table.insert(paths, relative_path) -- 添加相對路徑到陣列
        end
      end
    end
  end

  if #paths > 0 then
    local all_paths = table.concat(paths, "\n") -- 將所有路徑合併成字串，以換行符分隔
    vim.fn.setreg("+", all_paths) -- 將所有路徑寫入系統剪貼板
    vim.notify("All quickfix relative paths copied to clipboard!", vim.log.levels.INFO)
  else
    vim.notify("No valid paths in quickfix list", vim.log.levels.WARN)
  end
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
    local lines = vim.fn.getbufline(vim.api.nvim_get_current_buf(), 1, "$")
    local win_content = table.concat(
      vim.tbl_map(function(line)
        return tostring(line)
      end, lines),
      "\n"
    )

    -- 組合檔案路徑和內容
    local content_to_copy = "//file: " .. relative_path .. "\n" .. win_content

    vim.fn.setreg("+", content_to_copy) -- 將內容寫入系統剪貼板
    vim.notify("Current file content copied to clipboard with file path!", vim.log.levels.INFO)
  else
    vim.notify("No file name for current buffer!", vim.log.levels.WARN)
  end
end

-- 定義函數：將所有 buffer 內容複製到剪貼板，並在每個 buffer 前加上檔案路徑
local function copy_all_buffers_to_clipboard()
  local all_content = "" -- 初始化變數，用於存儲所有內容

  -- 獲取專案根目錄
  local project_root = vim.fn.getcwd() -- 當前工作目錄作為專案根目錄
  if project_root:sub(-1) ~= "/" then
    project_root = project_root .. "/" -- 確保根目錄以 / 結尾
  end

  for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do -- 遍歷所有 buffer
    local buf_path = vim.api.nvim_buf_get_name(buf.bufnr) -- 獲取 buffer 的完整路徑
    if buf_path ~= "" then -- 檢查是否為有效檔案
      -- 計算相對路徑
      local relative_path = buf_path:gsub(project_root, "") -- 從完整路徑中移除專案根目錄
      relative_path = "/" .. relative_path -- 加上 / 作為根目錄標記

      -- 讀取 buffer 內容
      local lines = vim.fn.getbufline(buf.bufnr, 1, "$") -- 獲取所有行
      local buf_content = table.concat(
        vim.tbl_map(function(line)
          return tostring(line) -- 確保每一行都是字符串
        end, lines),
        "\n"
      )

      -- 將檔案路徑和內容追加到變數
      all_content = all_content .. "//file: " .. relative_path .. "\n" .. buf_content .. "\n\n"
    end
  end

  vim.fn.setreg("+", all_content) -- 將所有內容寫入系統剪貼板
  vim.notify("All buffers copied to clipboard with file paths!", vim.log.levels.INFO)
end

-- 複製路徑
map("n", "<leader>ca", copy_absolute_path, { desc = "[y]ank [a]bsolute filepath", silent = true })
map("n", "<leader>cr", copy_relative_path, { desc = "[y]ank [r]elative filepath", silent = true })
map("n", "<leader>cm", ":let @+ = execute('message')<CR>", { desc = "[y]ank [m]essage outputs to clipboard" })
map("n", "<leader>cbr", copy_all_buffer_relative_paths, { desc = "[y]ank all [b]uffers relative paths", silent = true })
map("n", "<leader>cba", copy_all_buffer_absolute_paths, { desc = "[y]ank all [B]uffers absolute paths", silent = true })
map("n", "<leader>cqr", copy_quickfix_relative_paths, { desc = "[y]ank all [q]uickfix relative paths", silent = true })
map("n", "<leader>cqa", copy_quickfix_absolute_paths, { desc = "[y]ank all [q]uickfix absolute paths", silent = true })

-- 複製內容
map("n", "<space>by", copy_all_buffers_to_clipboard, { desc = "Copy all buffers to clipboard with file paths" })
map(
  "n",
  "<space>wy",
  copy_current_window_to_clipboard,
  { desc = "Copy current file content to clipboard with file path" }
)

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

-- Telescope
wk.add({ { "<leader>s", name = "Search ..." } })
map(
  "n",
  "<leader>sf",
  "<cmd>Telescope find_files find_command=rg,--files,--follow,--hidden,--ignore-case,--glob=!.git,--glob=!backup<CR>",
  { desc = "[S]earch [F]iles" }
)
map("n", "<leader>sg", "<cmd>Telescope git_status<CR>", { desc = "[s]earch [g]it status" })
map("n", "<leader>sr", "<cmd>Telescope live_grep<CR>", { desc = "[s]earch by g[r]ep" })
map("n", "<leader>sa", "<cmd>Telescope live_grep_args<CR>", { desc = "[s]earch by grep [a]rgs" })
map(
  "n",
  "<leader>sw",
  "<cmd>Telescope grep_string<CR>",
  { desc = "[S]earch the string under cursor in current [w]orking directory" }
)
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

-- Goyo mode
map("n", "<leader>G", "<cmd>Goyo<CR>", { desc = "Goyo mode / Lite mode" })

-- LSP and Gitsigns
wk.add({ { "g", name = "LSP / Gitsigns ..." } })
map("n", "gd", function()
  vim.lsp.buf.definition()
end, { desc = "Definition" })
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "Declaration" })
map("n", "gI", vim.lsp.buf.implementation, { desc = "[G]oto [I]mplementation" })
map("n", "gS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", { desc = "[W]orkspace [S]ymbols" })
map("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", { desc = "Workspace Symbol" })
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Hover" })
map("n", "<space>s", vim.lsp.buf.signature_help, { desc = "Signature Documentation" })
map("n", "gr", "<cmd>Telescope lsp_references<CR>", { desc = "[G]oto [R]eferences" })
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
map("n", "gwl", "<cmd>lua vim.lsp.buf.list_workspace_folders()<CR>", { desc = "[W]orkspace [L]ist Folders" })

-- Diagnostic navigation
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next({ border = 'rounded' })<CR>", { desc = "Diagnostic Next" })
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev({ border = 'rounded' })<CR>", { desc = "Diagnostic Prev" })

-- Select all
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

map({ "n", "v" }, "<space>", "<Nop>", opts)
-- Remap for dealing with word wrap
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

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
map("n", "sf", "<cmd>Oil<CR>", { desc = "Oil file explorer" })
map("n", "sF", "<cmd>Oil .<CR>", { desc = "Oil from project root" })
map("n", "so", "<cmd>Telescope oldfiles<CR>", { desc = "[s]earch [o]ldfiles" })
map("n", "sb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
map(
  "n",
  "sw",
  "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>",
  { desc = "[S]earch [W]orktree" }
)
map(
  "n",
  "sW",
  "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>",
  { desc = "[S]et [W]orktree" }
)
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
map(
  "n",
  "stL",
  "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
  { desc = "LSP Definitions / references / ... (Trouble)" }
)
map("n", "stl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
map("n", "str", "<cmd>TroubleToggle lst_references<cr>", { desc = "Trouble, LSP Reference" })
map("n", "stn", "<cmd>lua require('trouble').next({skip_groups = true, jump = true})<cr>", { desc = "[N]ext trouble" })
map(
  "n",
  "stp",
  "<cmd>lua require('trouble').prev({skip_groups = true, jump = true})<cr>",
  { desc = "[P]revious trouble" }
)

-- DAP (Debugger)
wk.add({ { "<space>d", name = "Neovim DAP ..." } })
map("n", "<space>dc", '<cmd>lua require"dap".clear_breakpoints()<CR>', { desc = "Clear Breakpoints" })
map(
  "n",
  "<space>de",
  '<cmd>lua require"dap".set_exception_breakpoints({"all"})<CR>',
  { desc = "Set Exception Breakpoints" }
)
map("n", "<space>dl", "<cmd>Telescope dap list_breakpoints<CR>", { desc = "List Breakpoints" })
map("n", "<space>dk", '<cmd>lua require"dap".up()<CR>zz', { desc = "Up" })
map("n", "<space>dj", '<cmd>lua require"dap".down()<CR>zz', { desc = "Down" })
map("n", "<space>dt", '<cmd>lua require"dap".terminate()<CR>', { desc = "Terminate" })
map("n", "<space>dr", '<cmd>lua require"dap".repl.toggle({}, "split")<CR><C-w>j<C-W>J', { desc = "Toggle Repl" })
map(
  "n",
  "<space>ds",
  '<cmd>lua local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes)<CR>',
  { desc = "Scopes" }
)
map("n", "<space>dE", "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<CR>", { desc = "Evaluate Input" })
map("n", "<space>d?", "<cmd>Telescope dap commands<CR>", { desc = "List Commands" })
map("n", "<space>b", '<cmd>lua require"dap".toggle_breakpoint()<CR>', { desc = "Toggle Breakpoint" })
map(
  "n",
  "<space>B",
  "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
  { desc = "Conditional Breakpoint" }
)
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

local gs = package.loaded.gitsigns
map("n", "]g", function()
  if vim.wo.diff then
    return "]g"
  end
  vim.schedule(function()
    gs.next_hunk()
  end)
  return "<Ignore>"
end, { expr = true, desc = "Next Hunk" })
map("n", "[g", function()
  if vim.wo.diff then
    return "[g"
  end
  vim.schedule(function()
    gs.prev_hunk()
  end)
  return "<Ignore>"
end, { expr = true, desc = "Prev Hunk" })
-- Git operations
map("n", "<space>gb", function()
  require("gitsigns").blame_line({ full = true })
end, { desc = "Blame Line" })
map("n", "<space>hp", require("gitsigns").preview_hunk, { desc = "Preview Hunk" })
map("n", "<space>tb", require("gitsigns").toggle_current_line_blame, { desc = "Toggle Current Line Blame" })
map("n", "<space>gd", require("gitsigns").diffthis, { desc = "Diff This" })
map("n", "<space>gD", function()
  require("gitsigns").diffthis("~")
end, { desc = "Diff This ~" })
map("n", "<space>gv", "<cmd>Gvdiffsplit<CR>", { desc = "Gvdiffsplit" })
map("n", "<space>gs", "<cmd>Gdiffsplit<CR>", { desc = "Gdiffsplit" })
map("n", "<space>gw", "<cmd>windo diffthis<CR>", { desc = "Diff windows" })
map("n", "<space>gf", "<cmd>GV!<CR>", { desc = "list commits for current file" })
map("n", "<space>gl", "<cmd>GV?<CR>", { desc = "fills the location list with the revisions of the current file" })
map("n", "<space>gF", "<cmd>GV<CR>", { desc = "open commit browser" })
map("n", "<space>dp", "<cmd>diffput<CR>", { desc = "diffput" })
map("n", "<space>dg", "<cmd>diffget<CR>", { desc = "diffget" })

-- Text object
map(
  { "o", "x" },
  "ih",
  ":<C-U>Gitsigns select_hunk<CR>",
  { desc = "Select Hunk, used in visual or followed by d/y commands" }
)

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

]])

-- HTML/JSX element navigation with treesitter (extracted to separate module)
require("core.jsx-navigation").setup()
