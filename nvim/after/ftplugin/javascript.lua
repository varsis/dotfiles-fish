-- JavaScript specific settings
vim.opt_local.foldlevel = 99
vim.opt_local.foldnestmax = 3

-- Auto-fold patterns for JS
vim.api.nvim_create_autocmd("BufReadPost", {
  buffer = 0,
  callback = function()
    vim.cmd("silent! %foldopen")

    -- Fold import/require statements
    vim.cmd("silent! g/^\\(import\\|const.*require\\)/normal! zc")

    -- Position cursor at first non-import line
    vim.cmd("normal! gg")
    vim.cmd("silent! /^\\(import\\|const.*require\\)\\@!")
  end,
})

-- Source TypeScript F-key bindings
dofile(vim.fn.stdpath("config") .. "/after/ftplugin/typescript.lua")
