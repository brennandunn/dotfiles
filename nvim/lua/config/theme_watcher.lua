local uv = vim.loop

local spec_path = vim.fn.expand("~/.config/nvim/lua/plugins/theme.lua")
local watched_path = vim.fn.resolve(spec_path)

local function reload_theme()
  package.loaded["plugins.theme"] = nil
  local ok, spec = pcall(require, "plugins.theme")
  if not ok then
    vim.notify("theme_watcher: failed to reload theme: " .. spec, vim.log.levels.WARN)
    return
  end
  if type(spec.config) == "function" then
    pcall(spec.config)
  end
end

local w = uv.new_fs_event()
w:start(watched_path, {}, function()
  vim.schedule(reload_theme)
end)

-- apply once at startup
reload_theme()
