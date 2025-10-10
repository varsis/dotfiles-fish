return {
  "nvim-orgmode/orgmode",
  event = "VeryLazy",
  ft = { "org" },

  config = function()
    local function get_file_date()
      local filename = vim.fn.expand("%:t:r") -- Get filename without extension
      local year, month, day = filename:match("(%d%d%d%d)-(%d%d)-(%d%d)")

      if year and month and day then
        return os.time({ year = year, month = month, day = day })
      end
      return os.time() -- Default to today if not a dated file
    end
    local function open_daily_journal(offset)
      offset = offset or 0
      local current_date = get_file_date()
      local journal_dir = vim.fn.expand("~/orgfiles/journal")
      local target_date = current_date + (offset * 86400)
      local date_str = os.date("%Y-%m-%d", target_date)
      local journal_path = journal_dir .. "/" .. date_str .. ".org"

      vim.fn.mkdir(journal_dir, "p")
      vim.cmd("edit " .. journal_path)

      if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
        local day_name = os.date("%A", target_date)
        local lines = {
          "#+TITLE: Journal " .. date_str,
          "#+DATE: " .. date_str .. " " .. day_name,
          "",
          "* Tasks",
          "** TODO ",
          "",
          "* Daily Log",
          "** " .. os.date("%H:%M") .. " ",
          "",
        }
        vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
        vim.cmd("normal! 5G$") -- Jump to TODO line
      end
    end

    -- Keybindings
    vim.keymap.set("n", "<Leader>ww", function()
      open_daily_journal(0)
    end, { desc = "Open today's journal" })
    vim.keymap.set("n", "<Leader>w<Leader>i", function()
      open_daily_journal(0)
    end, { desc = "Open today's journal (index)" })
    vim.keymap.set("n", "<C-Up>", function()
      open_daily_journal(-1)
    end, { desc = "Open yesterday's journal" })
    vim.keymap.set("n", "<C-Down>", function()
      open_daily_journal(1)
    end, { desc = "Open tomorrow's journal" })

    vim.keymap.set("n", "<Leader>oq", function()
      local config = require("orgmode").config
      print("Agenda files: " .. vim.inspect(config.org_agenda_files))
    end, { desc = "Show agenda files" })

    -- Setup orgmode
    require("orgmode").setup({
      org_agenda_files = { "~/orgfiles/journal/*.org", "~/orgfiles/refile.org" },
      org_default_notes_file = "~/orgfiles/refile.org",
      org_todo_keywords = { "TODO", "IN_PROGRESS", "|", "DONE", "CANCELLED" },
      org_capture_templates = {
        j = {
          description = "Journal entry",
          template = "* %U %?\n",
          target = "~/orgfiles/journal/%<%Y-%m-%d>.org",
        },
        t = {
          description = "Todo",
          template = "* TODO %?\n  SCHEDULED: %t",
          target = "~/orgfiles/journal/%<%Y-%m-%d>.org",
          headline = "Tasks",
        },
      },
      mappings = {
        global = {
          org_agenda = "<leader>aa",  -- instead of \oa
          org_capture = "<leader>cc", -- instead of \oc
        },
        agenda = {
          org_agenda_later = "L",
          org_agenda_quit = "q",
          org_agenda_earlier = "H",
        },
        capture = {
          org_capture_finalize = "<leader>w",
          org_capture_refile = "<leader>r",
        },
        org_refile_targets = {
          ["~/orgfiles/journal/*.org"] = { ":level", 1 },
        },
      },
    })
  end,
}
