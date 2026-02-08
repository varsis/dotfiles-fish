---@diagnostic disable: undefined-global
local bufnr = vim.api.nvim_get_current_buf()

-- TypeScript specific settings
vim.opt_local.foldlevel = 99
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

--- Add a normal keymap.
---@param lhs string Keymap
---@param rhs function Action
local keymap = function(lhs, rhs)
  vim.keymap.set("n", lhs, rhs, {
    noremap = true,
    silent = true,
    buffer = bufnr,
  })
end

local function copen()
  if vim.fn.getqflist({ size = 0 }).size > 1 then
    vim.cmd("copen")
  else
    vim.cmd("cclose")
  end
end

local function cclear()
  vim.fn.setqflist({}, "r")
end

-- Check if current directory is an NX workspace
local function is_nx_workspace()
  local root = vim.fn.getcwd()
  return vim.fn.filereadable(root .. "/nx.json") == 1 or vim.fn.filereadable(root .. "/workspace.json") == 1
end

-- Get current project from file path using nxproject script
local function get_current_project()
  local filepath = vim.fn.expand("%:p")
  local output = vim.fn.system("nxproject " .. vim.fn.shellescape(filepath))
  return vim.trim(output)
end

-- Detect package manager from lockfile
local function get_package_manager()
  local root = vim.fn.getcwd()
  if vim.fn.filereadable(root .. "/pnpm-lock.yaml") == 1 then
    return "pnpm"
  elseif vim.fn.filereadable(root .. "/package-lock.json") == 1 then
    return "npm"
  elseif vim.fn.filereadable(root .. "/yarn.lock") == 1 then
    return "yarn"
  end
  return "npm"
end

-- Get base branch for affected commands
local function get_base_branch()
  local branch = vim.fn.system("git config --get init.defaultBranch 2>/dev/null")
  if vim.v.shell_error == 0 and vim.trim(branch) ~= "" then
    return vim.trim(branch)
  end
  return "origin/main"
end

-- F1: Build current project
keymap("<F1>", function()
  if is_nx_workspace() then
    local project = get_current_project()
    if project == "" then
      vim.notify("Could not detect project", vim.log.levels.WARN)
      return
    end
    vim.notify("Building " .. project .. "...")
    cclear()
    vim.schedule(function()
      vim.cmd("make! nx\\ build\\ " .. project)
      copen()
      vim.notify("Done!")
    end)
  else
    vim.notify("Type checking...")
    cclear()
    vim.schedule(function()
      vim.cmd("make! tsc\\ --noEmit")
      copen()
      vim.notify("Done!")
    end)
  end
end)

-- F2: Run/serve current project
keymap("<F2>", function()
  if is_nx_workspace() then
    local project = get_current_project()
    if project == "" then
      vim.notify("Could not detect project", vim.log.levels.WARN)
      return
    end
    vim.notify("Serving " .. project .. "...")
    vim.fn.jobstart("nx serve " .. project)
  else
    vim.notify("Starting dev server...")
    vim.fn.jobstart("npm start")
  end
end)

-- F3: Test current project
keymap("<F3>", function()
  if is_nx_workspace() then
    local project = get_current_project()
    if project == "" then
      vim.notify("Could not detect project", vim.log.levels.WARN)
      return
    end
    vim.notify("Testing " .. project .. "...")
    cclear()
    vim.schedule(function()
      vim.cmd("make! nx\\ test\\ " .. project)
      copen()
      vim.notify("Done!")
    end)
  else
    vim.notify("Running tests...")
    cclear()
    vim.schedule(function()
      vim.cmd("make! npm\\ test")
      copen()
      vim.notify("Done!")
    end)
  end
end)

-- F4: Test affected
keymap("<F4>", function()
  if not is_nx_workspace() then
    vim.notify("Not in NX workspace", vim.log.levels.WARN)
    return
  end
  local base = get_base_branch()
  vim.notify("Testing affected (base: " .. base .. ")...")
  cclear()
  vim.schedule(function()
    vim.cmd("make! nx\\ affected:test\\ --base=" .. base)
    copen()
    vim.notify("Done!")
  end)
end)

-- F5: Lint current project
keymap("<F5>", function()
  if is_nx_workspace() then
    local project = get_current_project()
    if project == "" then
      vim.notify("Could not detect project", vim.log.levels.WARN)
      return
    end
    vim.notify("Linting " .. project .. "...")
    cclear()
    vim.schedule(function()
      vim.cmd("make! nx\\ lint\\ " .. project)
      copen()
      vim.notify("Done!")
    end)
  else
    vim.notify("Running eslint...")
    cclear()
    vim.schedule(function()
      vim.cmd("make! npx\\ eslint\\ .")
      copen()
      vim.notify("Done!")
    end)
  end
end)

-- F6: Package install
keymap("<F6>", function()
  local pm = get_package_manager()
  vim.notify("Installing packages with " .. pm .. "...")
  vim.fn.jobstart(pm .. " install")
end)

-- F7: Type check
keymap("<F7>", function()
  vim.notify("Type checking...")
  cclear()
  vim.schedule(function()
    vim.cmd("make! tsc\\ --noEmit")
    copen()
    vim.notify("Done!")
  end)
end)
