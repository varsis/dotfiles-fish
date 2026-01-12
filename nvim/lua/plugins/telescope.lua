local select_one_or_multi = function(prompt_bufnr)
  local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()
  if not vim.tbl_isempty(multi) then
    require("telescope.actions").close(prompt_bufnr)
    for _, j in pairs(multi) do
      if j.path ~= nil then
        vim.cmd(string.format("%s %s", "edit", j.path))
      end
    end
  else
    require("telescope.actions").select_default(prompt_bufnr)
  end
end

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-github.nvim",
    "nvim-orgmode/orgmode",
    "telescope-orgmode.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  opts = {
    defaults = {
      pickers = {
        find_files = {
          theme = "ivy",
        },
      },
      mappings = {
        i = {
          ["<CR>"] = select_one_or_multi,
          ["<C-y>"] = select_one_or_multi,
        },
      },
      prompt_prefix = "   ",
      selection_caret = " ❯ ",
      entry_prefix = "   ",
      multi_icon = "+ ",
      path_display = { "filename_first" },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--sort=path",
      },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("gh")
    telescope.load_extension("harpoon")
    telescope.load_extension("fzf")
    telescope.load_extension("orgmode")
  end,
  keys = function()
    local function ivy(opts)
      return require("telescope.themes").get_ivy(opts)
    end

    return {
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files(ivy({
            find_command = {
              "fd",
              "--type",
              "f",
              "--strip-cwd-prefix",
              "--hidden",
            },
          }))
        end,
      },
      {
        "<leader>of",
        function()
          require("telescope.builtin").oldfiles({ only_cwd = true })
        end,
      },
      {
        "<leader>lg",
        function()
          require("config.telescope-multi")()
        end,
      },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers(ivy())
        end,
      },
      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags(ivy())
        end,
      },
      {
        "<leader>fc",
        function()
          require("telescope.builtin").commands(ivy())
        end,
      },
      {
        "<leader>fr",
        function()
          require("telescope.builtin").resume(ivy())
        end,
      },
      {
        "<leader>fq",
        function()
          require("telescope.builtin").quickfix(ivy())
        end,
      },
      {
        "<leader>/",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find(ivy())
        end,
      },
      {
        "<leader>xx",
        function()
          require("telescope.builtin").diagnostics(ivy())
        end,
      },
      {
        "<leader>ghi",
        function()
          require("telescope").extensions.gh.issues(ivy())
        end,
      },
      {
        "<leader>fj",
        function()
          require("telescope").extensions.harpoon.marks(ivy())
        end,
      },
      {
        "<leader>r",
        function()
          require("telescope").extensions.orgmode.refile_heading()
        end,
      },
      {
        "<leader>fh",
        function()
          require("telescope").extensions.orgmode.search_headings()
        end,
      },
      {
        "<leader>li",
        function()
          require("telescope").extensions.orgmode.insert_link()
        end,
      },
      {
        "<leader>wf",
        function()
          require("telescope.builtin").find_files({
            prompt_title = "Journal Entries",
            cwd = vim.fn.expand("~/orgfiles/journal"),
            find_command = { "find", ".", "-name", "*.org", "-type", "f" },
          })
        end,
      },
      {
        "<leader>wR",
        function()
          require("telescope.builtin").find_files({
            prompt_title = "Weekly Reviews",
            cwd = vim.fn.expand("~/orgfiles/journal"),
            find_command = { "find", ".", "-name", "weekly-review-*.org", "-type", "f" },
          })
        end,
        desc = "Browse weekly reviews",
      },
      {
        "<leader>wi",
        function()
          vim.cmd("edit " .. vim.fn.expand("~/orgfiles/refile.org"))
        end,
        desc = "Open inbox (refile.org)",
      },
      {
        "<leader>wo",
        function()
          require("telescope.builtin").find_files(ivy({
            prompt_title = "All Org Files",
            cwd = vim.fn.expand("~/orgfiles"),
            find_command = { "find", ".", "-name", "*.org", "-type", "f" },
          }))
        end,
        desc = "Browse all org files",
      },
      {
        "<leader>ft",
        function()
          require("telescope.builtin").live_grep(ivy({
            prompt_title = "All TODOs",
            search_dirs = {
              vim.fn.expand("~/orgfiles/journal"),
              vim.fn.expand("~/orgfiles/refile.org"),
              vim.fn.expand("~/orgfiles/projects.org"),
              vim.fn.expand("~/orgfiles/areas.org"),
            },
            default_text = "^\\*\\* (TODO|IN_PROGRESS)",
            additional_args = function()
              return { "--pcre2" }
            end,
          }))
        end,
        desc = "Find all TODOs",
      },
      {
        "<leader>fT",
        function()
          require("telescope.builtin").live_grep(ivy({
            prompt_title = "All Tasks",
            search_dirs = {
              vim.fn.expand("~/orgfiles/journal"),
              vim.fn.expand("~/orgfiles/refile.org"),
              vim.fn.expand("~/orgfiles/projects.org"),
              vim.fn.expand("~/orgfiles/areas.org"),
            },
            default_text = "^\\*\\* (TODO|IN_PROGRESS|DONE|CANCELLED)",
            additional_args = function()
              return { "--pcre2" }
            end,
          }))
        end,
        desc = "Find all tasks (including DONE)",
      },
      {
        "<leader>fn",
        function()
          require("telescope.builtin").live_grep(ivy({
            prompt_title = "Next Actions",
            search_dirs = {
              vim.fn.expand("~/orgfiles/journal"),
              vim.fn.expand("~/orgfiles/refile.org"),
              vim.fn.expand("~/orgfiles/projects.org"),
              vim.fn.expand("~/orgfiles/areas.org"),
            },
            default_text = "^\\*\\* NEXT",
            additional_args = function()
              return { "--pcre2" }
            end,
          }))
        end,
        desc = "Find NEXT actions",
      },
      {
        "<leader>fw",
        function()
          require("telescope.builtin").live_grep(ivy({
            prompt_title = "Waiting For",
            search_dirs = {
              vim.fn.expand("~/orgfiles/journal"),
              vim.fn.expand("~/orgfiles/refile.org"),
              vim.fn.expand("~/orgfiles/projects.org"),
              vim.fn.expand("~/orgfiles/areas.org"),
            },
            default_text = "^\\*\\* WAITING",
            additional_args = function()
              return { "--pcre2" }
            end,
          }))
        end,
        desc = "Find WAITING items",
      },
      {
        "<leader>fp",
        function()
          require("telescope.builtin").live_grep(ivy({
            prompt_title = "Projects",
            search_dirs = {
              vim.fn.expand("~/orgfiles/journal"),
              vim.fn.expand("~/orgfiles/refile.org"),
              vim.fn.expand("~/orgfiles/projects.org"),
              vim.fn.expand("~/orgfiles/areas.org"),
            },
            default_text = "^\\*\\* PROJECT",
            additional_args = function()
              return { "--pcre2" }
            end,
          }))
        end,
        desc = "Find all projects",
      },
      {
        "<leader>fs",
        function()
          require("telescope.builtin").live_grep(ivy({
            prompt_title = "Someday/Maybe",
            search_dirs = {
              vim.fn.expand("~/orgfiles/journal"),
              vim.fn.expand("~/orgfiles/refile.org"),
              vim.fn.expand("~/orgfiles/projects.org"),
              vim.fn.expand("~/orgfiles/areas.org"),
            },
            default_text = "^\\*\\* SOMEDAY",
            additional_args = function()
              return { "--pcre2" }
            end,
          }))
        end,
        desc = "Find SOMEDAY items",
      },
    }
  end,
}