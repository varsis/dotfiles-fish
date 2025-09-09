-- TypeScript specific settings
vim.opt_local.foldlevel = 0
vim.opt_local.foldnestmax = 3

-- Auto-fold specific patterns
vim.api.nvim_create_autocmd("BufReadPost", {
  buffer = 0,
  callback = function()
    -- Fold import statements
    vim.cmd("silent! %foldopen")
    vim.cmd("silent! g/^import/normal! zc")

    -- Fold type definitions
    vim.cmd("silent! g/^\\(export \\)\\?\\(interface\\|type\\|enum\\)/normal! zc")

    -- Position cursor at first non-folded line
    vim.cmd("normal! gg")
    vim.cmd("silent! /^\\(import\\|export\\|type\\|interface\\|enum\\)\\@!")
  end,
})
