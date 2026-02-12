-- HTML/JSX element navigation with treesitter
local M = {}

local function find_jsx_parent(node)
  if not node then
    return nil
  end

  local parent = node:parent()
  while parent do
    if parent:type() == "jsx_expression" then
      local next_parent = parent:parent()
      while next_parent do
        if next_parent:type() == "jsx_attribute" then
          local tag_parent = next_parent:parent()
          if tag_parent and tag_parent:type() == "jsx_self_closing_element" then
            return tag_parent
          end
        end
        next_parent = next_parent:parent()
      end
    end
    if
      parent:type() == "jsx_element"
      or parent:type() == "jsx_fragment"
      or parent:type() == "jsx_self_closing_element"
    then
      return parent
    end
    parent = parent:parent()
  end
  return nil
end

local function find_jsx_in_node(node)
  if not node then
    return nil
  end

  if node:type() == "jsx_element" or node:type() == "jsx_fragment" or node:type() == "jsx_self_closing_element" then
    return node
  end

  for i = 0, node:child_count() - 1 do
    local child = node:child(i)
    local result = find_jsx_in_node(child)
    if result then
      return result
    end
  end

  return nil
end

local function get_first_jsx_in_map(expression)
  local call_node = nil
  for i = 0, expression:child_count() - 1 do
    local child = expression:child(i)
    if child:type() == "call_expression" then
      call_node = child
      break
    end
  end

  if not call_node then
    return nil
  end

  for i = 0, call_node:child_count() - 1 do
    local child = call_node:child(i)
    if child:type() == "arguments" then
      for j = 0, child:child_count() - 1 do
        local arg = child:child(j)
        if arg:type() == "arrow_function" then
          for k = 0, arg:child_count() - 1 do
            local func_part = arg:child(k)
            if func_part:type() == "parenthesized_expression" then
              for l = 0, func_part:child_count() - 1 do
                local body_item = func_part:child(l)
                if body_item:type() == "jsx_element" then
                  return body_item
                end
              end
            end
          end
        end
      end
    end
  end

  return nil
end

local function find_next_map_expression(node)
  if not node then
    return nil
  end

  local ts_utils = require("nvim-treesitter.ts_utils")

  local next_node = ts_utils.get_next_node(node, true, true)
  while next_node do
    if next_node:type() == "jsx_expression" then
      for i = 0, next_node:child_count() - 1 do
        local child = next_node:child(i)
        if child:type() == "call_expression" then
          local first_child = child:child(0)
          if first_child and first_child:type() == "member_expression" then
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

  return nil
end

local function get_jsx_from_attribute_value(attr_value)
  if not attr_value then
    return nil
  end

  if attr_value:type() == "jsx_expression" then
    for i = 0, attr_value:child_count() - 1 do
      local expr_child = attr_value:child(i)
      if expr_child:type() == "arrow_function" then
        for j = 0, expr_child:child_count() - 1 do
          local func_child = expr_child:child(j)
          if func_child:type() == "parenthesized_expression" then
            local jsx = find_jsx_in_node(func_child)
            if jsx then
              return jsx
            end
          end
        end
      else
        local jsx = find_jsx_in_node(expr_child)
        if jsx then
          return jsx
        end
      end
    end
  end
  return nil
end

local function get_first_jsx_in_attributes(node)
  for i = 0, node:child_count() - 1 do
    local child = node:child(i)
    if child:type() == "jsx_attribute" then
      for j = 0, child:child_count() - 1 do
        local attr_part = child:child(j)
        local jsx = get_jsx_from_attribute_value(attr_part)
        if jsx then
          return jsx
        end
      end
    end
  end
  return nil
end

local function get_first_child(node)
  if not node then
    return nil
  end

  local has_children = false
  for i = 0, node:child_count() - 1 do
    local child = node:child(i)
    if
      child:type() == "jsx_element"
      or child:type() == "jsx_fragment"
      or child:type() == "jsx_self_closing_element"
    then
      has_children = true
      return child
    end
  end

  if node:type() == "jsx_self_closing_element" then
    local jsx_in_attr = get_first_jsx_in_attributes(node)
    if jsx_in_attr then
      return jsx_in_attr
    end
  end

  if not has_children then
    local map_jsx = find_next_map_expression(node)
    if map_jsx then
      return map_jsx
    end
  end

  return nil
end

local function is_jsx_node(node)
  if not node then
    return false
  end
  local type = node:type()
  return type == "jsx_element" or type == "jsx_fragment" or type == "jsx_self_closing_element"
end

local function get_next_sibling(node)
  local ts_utils = require("nvim-treesitter.ts_utils")
  local current = node

  if not is_jsx_node(current) then
    current = find_jsx_parent(current)
  end

  if not current then
    return nil
  end

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
  local ts_utils = require("nvim-treesitter.ts_utils")
  local current = node

  if not is_jsx_node(current) then
    current = find_jsx_parent(current)
  end

  if not current then
    return nil
  end

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
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()
  if node == nil then
    return nil
  end

  local start_row = node:start()
  local parent = node:parent()

  while parent ~= nil and parent:start() == start_row do
    node = parent
    parent = node:parent()
  end

  return node
end

local function goto_child_or_sibling_node()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = get_master_node()
  if node == nil then
    return
  end

  local child = get_first_child(node)
  if child ~= nil then
    ts_utils.goto_node(child)
    return
  end

  local sibling = get_next_sibling(node)
  if sibling ~= nil then
    ts_utils.goto_node(sibling)
  end
end

local function goto_parent_node()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = get_master_node()
  if node == nil then
    return
  end

  local parent = find_jsx_parent(node)
  if parent then
    ts_utils.goto_node(parent)
  end
end

local function goto_next_sibling_node()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = get_master_node()
  if node == nil then
    return
  end

  local sibling = get_next_sibling(node)
  if sibling ~= nil then
    ts_utils.goto_node(sibling)
  end
end

local function goto_prev_sibling_node()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = get_master_node()
  if node == nil then
    return
  end

  local sibling = get_previous_sibling(node)
  if sibling ~= nil then
    ts_utils.goto_node(sibling)
  end
end

local function goto_root_node()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()
  if node == nil then
    return
  end

  local root = node
  while node ~= nil do
    local type = node:type()
    if type == "jsx_element" or type == "jsx_fragment" or type == "jsx_self_closing_element" or type == "element" then
      root = node
    end
    node = node:parent()
  end

  ts_utils.goto_node(root)
end

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "html", "typescriptreact", "javascriptreact" },
    callback = function()
      vim.keymap.set("n", "[t", function()
        local filetype = vim.bo.filetype
        if filetype == "typescriptreact" or filetype == "javascriptreact" then
          local ts_utils = require("nvim-treesitter.ts_utils")
          local node = ts_utils.get_node_at_cursor()
          if node == nil then
            return
          end
          while node ~= nil do
            if
              node:type() == "jsx_element"
              or node:type() == "jsx_fragment"
              or node:type() == "jsx_self_closing_element"
            then
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
          local ts_utils = require("nvim-treesitter.ts_utils")
          local node = ts_utils.get_node_at_cursor()
          if node == nil then
            return
          end
          while node ~= nil do
            if
              node:type() == "jsx_element"
              or node:type() == "jsx_fragment"
              or node:type() == "jsx_self_closing_element"
            then
              goto_child_or_sibling_node()
              return
            end
            node = node:parent()
          end
        else
          goto_child_or_sibling_node()
        end
      end, { buffer = true, desc = "Goto child, expression, or next sibling HTML/JSX element" })

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

      vim.keymap.set("n", "[r", function()
        local filetype = vim.bo.filetype
        if filetype == "typescriptreact" or filetype == "javascriptreact" then
          local ts_utils = require("nvim-treesitter.ts_utils")
          local node = ts_utils.get_node_at_cursor()
          if node == nil then
            return
          end
          while node ~= nil do
            if
              node:type() == "jsx_element"
              or node:type() == "jsx_fragment"
              or node:type() == "jsx_self_closing_element"
            then
              goto_root_node()
              return
            end
            node = node:parent()
          end
        else
          goto_root_node()
        end
      end, { buffer = true, desc = "Goto root HTML/JSX element" })
    end,
  })
end

return M
