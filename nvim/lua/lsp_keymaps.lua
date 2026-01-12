local M = {}

--- Add a normal keymap.
---@param lhs string Keymap
---@param rhs function Action
---@param bufnr number Buffer number
local keymap = function(lhs, rhs, bufnr)
  vim.keymap.set("n", lhs, rhs, {
    noremap = true,
    silent = true,
    buffer = bufnr,
  })
end

local telescope = function(action)
  return function()
    local ivy = require("telescope.themes").get_ivy()
    require("telescope.builtin")["lsp_" .. action](ivy)
  end
end

--- On attach for key maps.
---@param bufnr number Buffer number
M.on_attach = function(bufnr)
  keymap("gd", telescope("definitions"), bufnr)
  keymap("grr", telescope("references"), bufnr)
  keymap("gO", telescope("document_symbols"), bufnr)
  keymap("gri", telescope("implementations"), bufnr)
  keymap("gD", vim.lsp.buf.declaration, bufnr)
  keymap("K", vim.lsp.buf.hover, bufnr)
  keymap("<leader>D", telescope("type_definitions"), bufnr)
  keymap("grl", vim.lsp.codelens.run, bufnr)
  keymap("gl", vim.diagnostic.open_float, bufnr)
  keymap("<leader>ld", function()
    local ivy = require("telescope.themes").get_ivy()
    require("telescope.builtin").diagnostics(vim.tbl_extend("force", ivy, { bufnr = 0 }))
  end, bufnr)
  keymap("<leader>ca", vim.lsp.buf.code_action, bufnr)
  keymap("<leader>rn", vim.lsp.buf.rename, bufnr)
  keymap("<leader>f", vim.lsp.buf.format, bufnr)
  keymap("<leader>oi", function()
    vim.lsp.buf.execute_command({
      command = "_typescript.organizeImports",
      arguments = { vim.api.nvim_buf_get_name(0) }
    })
  end, bufnr)
  keymap("<leader>ai", function()
    vim.lsp.buf.execute_command({
      command = "_typescript.addMissingImports",
      arguments = { vim.api.nvim_buf_get_name(0) }
    })
  end, bufnr)
  keymap("<leader>ih", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, bufnr)
  keymap("[d", function()
    vim.diagnostic.jump({ count = -1 })
    vim.cmd("norm zz")
  end, bufnr)
  keymap("]d", function()
    vim.diagnostic.jump({ count = 1 })
    vim.cmd("norm zz")
  end, bufnr)

  keymap("<leader>v", function()
    vim.cmd("vsplit | lua vim.lsp.buf.definition()")
    vim.cmd("norm zz")
  end, bufnr)

  keymap("<leader>ls", function()
    -- XXX: remove soon
    vim.notify("Use gO instead")
  end, bufnr)
  keymap("gi", function()
    -- XXX: remove soon
    vim.notify("Use gri instead")
  end, bufnr)
end

return M
