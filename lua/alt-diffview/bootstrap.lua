if AltDiffviewGlobal and AltDiffviewGlobal.bootstrap_done then
  return AltDiffviewGlobal.bootstrap_ok
end

local lazy = require("alt-diffview.lazy")

local EventEmitter = lazy.access("alt-diffview.events", "EventEmitter") ---@type EventEmitter|LazyModule
local Logger = lazy.access("alt-diffview.logger", "Logger") ---@type Logger|LazyModule
local config = lazy.require("alt-diffview.config") ---@module "alt-diffview.config"
local diffview = lazy.require("alt-diffview") ---@module "alt-diffview"
local utils = lazy.require("alt-diffview.utils") ---@module "alt-diffview.utils"

local uv = vim.loop

local function err(msg)
  msg = msg:gsub("'", "''")
  vim.cmd("echohl Error")
  vim.cmd(string.format("echom '[alt-diffview.nvim] %s'", msg))
  vim.cmd("echohl NONE")
end

_G.AltDiffviewGlobal = {
  bootstrap_done = true,
  bootstrap_ok = false,
}

if vim.fn.has("nvim-0.7") ~= 1 then
  err(
    "Minimum required version is Neovim 0.7.0! Cannot continue."
    .. " (See ':h alt-diffview.changelog-137')"
  )
  return false
end

_G.AltDiffviewGlobal = {
  ---Debug Levels:
  ---0:     NOTHING
  ---1:     NORMAL
  ---5:     LOADING
  ---10:    RENDERING & ASYNC
  ---@diagnostic disable-next-line: missing-parameter
  debug_level = tonumber((uv.os_getenv("DEBUG_ALT_DIFFVIEW"))) or 0,
  state = {},
  bootstrap_done = true,
  bootstrap_ok = true,
}

AltDiffviewGlobal.logger = Logger()
AltDiffviewGlobal.emitter = EventEmitter()

AltDiffviewGlobal.emitter:on_any(function(e, args)
  diffview.nore_emit(e.id, utils.tbl_unpack(args))
  config.user_emitter:nore_emit(e.id, utils.tbl_unpack(args))
end)

return true
