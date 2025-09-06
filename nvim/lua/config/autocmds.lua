-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

require("config.lsp-debug")

-- Ensure TypeScript files get proper LSP attachment in monorepo
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
  callback = function(ev)
    local util = require("lspconfig.util")
    local root = util.root_pattern("pnpm-workspace.yaml")(vim.fn.expand("%:p"))
    if root then
      vim.b.workspace_root = root
      vim.notify("Workspace root: " .. root, vim.log.levels.DEBUG)
    end
  end,
})
