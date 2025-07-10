if vim.g.alt_diffview_nvim_loaded or not require("alt-diffview.bootstrap") then
  return
end

vim.g.alt_diffview_nvim_loaded = 1

local lazy = require("alt-diffview.lazy")

---@module "alt-diffview"
local arg_parser = lazy.require("alt-diffview.arg_parser") ---@module "alt-diffview.arg_parser"
local alt_diffview = lazy.require("alt-diffview") ---@module "alt-diffview"

local api = vim.api
local command = api.nvim_create_user_command

-- NOTE: Need this wrapper around the completion function becuase it doesn't
-- exist yet.
local function completion(...)
  return alt_diffview.completion(...)
end

-- Create commands
command("AltDiffviewOpen", function(ctx)
  alt_diffview.open(arg_parser.scan(ctx.args).args)
end, { nargs = "*", complete = completion })

command("AltDiffviewFileHistory", function(ctx)
  local range

  if ctx.range > 0 then
    range = { ctx.line1, ctx.line2 }
  end

  alt_diffview.file_history(range, arg_parser.scan(ctx.args).args)
end, { nargs = "*", complete = completion, range = true })

command("AltDiffviewClose", function()
  alt_diffview.close()
end, { nargs = 0, bang = true })

command("AltDiffviewFocusFiles", function()
  alt_diffview.emit("focus_files")
end, { nargs = 0, bang = true })

command("AltDiffviewToggleFiles", function()
  alt_diffview.emit("toggle_files")
end, { nargs = 0, bang = true })

command("AltDiffviewRefresh", function()
  alt_diffview.emit("refresh_files")
end, { nargs = 0, bang = true })

command("AltDiffviewLog", function()
  vim.cmd(("sp %s | norm! G"):format(
    vim.fn.fnameescape(AltDiffviewGlobal.logger.outfile)
  ))
end, { nargs = 0, bang = true })
