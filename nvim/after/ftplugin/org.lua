-- Ensure orgmode is loaded for .org files
vim.bo.filetype = "org"

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.org",
  callback = function()
    -- Change to your org directory
    local org_dir = "~/orgfiles"
    local date = os.date("%Y-%m-%d %H:%M:%S")

    -- Run git commands directly
    vim.fn.jobstart({
      "bash",
      "-c",
      string.format("cd %s && git add -A && git commit -m 'Auto-sync: %s' && git push origin main", org_dir, date),
    }, { detach = true })
  end,
})
