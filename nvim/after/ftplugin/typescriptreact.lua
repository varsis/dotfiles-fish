-- TypeScript React specific settings  
vim.opt_local.foldlevel = 1
vim.opt_local.foldnestmax = 4

-- Auto-fold specific patterns for TSX
vim.api.nvim_create_autocmd("BufReadPost", {
  buffer = 0,
  callback = function()
    vim.cmd("silent! %foldopen")
    
    -- Fold import statements
    vim.cmd("silent! g/^import/normal! zc")
    
    -- Fold type definitions
    vim.cmd("silent! g/^\\(export \\)\\?\\(interface\\|type\\|enum\\)/normal! zc")
    
    -- Fold styled-components or large const objects
    vim.cmd("silent! g/^const.*styled/normal! zc")
    
    -- Position cursor appropriately
    vim.cmd("normal! gg")
    vim.cmd("silent! /^\\(import\\|export\\|type\\|interface\\|enum\\|const.*styled\\)\\@!")
  end,
})