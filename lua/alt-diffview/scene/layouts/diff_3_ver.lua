local async = require("alt-diffview.async")
local Window = require("alt-diffview.scene.window").Window
local Diff3 = require("alt-diffview.scene.layouts.diff_3").Diff3
local oop = require("alt-diffview.oop")

local api = vim.api
local await = async.await

local M = {}

---@class Diff3Ver : Diff3
---@field a Window
---@field b Window
---@field c Window
local Diff3Ver = oop.create_class("Diff3Ver", Diff3)

Diff3Ver.name = "diff3_vertical"

function Diff3Ver:init(opt)
  self:super(opt)
end

---@override
---@param self Diff3Ver
---@param pivot integer?
Diff3Ver.create = async.void(function(self, pivot)
  self:create_pre()
  local curwin

  pivot = pivot or self:find_pivot()
  assert(api.nvim_win_is_valid(pivot), "Layout creation requires a valid window pivot!")

  for _, win in ipairs(self.windows) do
    if win.id ~= pivot then
      win:close(true)
    end
  end

  api.nvim_win_call(pivot, function()
    vim.cmd("aboveleft sp")
    curwin = api.nvim_get_current_win()

    if self.a then
      self.a:set_id(curwin)
    else
      self.a = Window({ id = curwin })
    end
  end)

  api.nvim_win_call(pivot, function()
    vim.cmd("aboveleft sp")
    curwin = api.nvim_get_current_win()

    if self.b then
      self.b:set_id(curwin)
    else
      self.b = Window({ id = curwin })
    end
  end)

  api.nvim_win_call(pivot, function()
    vim.cmd("aboveleft sp")
    curwin = api.nvim_get_current_win()

    if self.c then
      self.c:set_id(curwin)
    else
      self.c = Window({ id = curwin })
    end
  end)

  api.nvim_win_close(pivot, true)
  self.windows = { self.a, self.b, self.c }
  await(self:create_post())
end)

M.Diff3Ver = Diff3Ver
return M
