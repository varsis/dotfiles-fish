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
    local function get_journal_files()
      local journal_dir = vim.fn.expand("~/orgfiles/journal")
      local files = vim.fn.glob(journal_dir .. "/*.org", false, true)

      -- Filter out weekly reviews and other non-daily files
      local daily_files = {}
      for _, file in ipairs(files) do
        local filename = vim.fn.fnamemodify(file, ":t")
        -- Only include files matching YYYY-MM-DD.org pattern
        if filename:match("^%d%d%d%d%-%d%d%-%d%d%.org$") then
          table.insert(daily_files, file)
        end
      end

      table.sort(daily_files)
      return daily_files
    end

    local function navigate_journal_files(direction)
      local current_file = vim.fn.expand("%:p")
      local journal_files = get_journal_files()

      if #journal_files == 0 then
        vim.notify("No journal files found", vim.log.levels.WARN)
        return
      end

      -- Find current file in the list
      local current_index = nil
      for i, file in ipairs(journal_files) do
        if file == current_file then
          current_index = i
          break
        end
      end

      local target_index
      if current_index then
        target_index = current_index + direction
      else
        -- Not in a journal file, go to first or last depending on direction
        target_index = direction > 0 and 1 or #journal_files
      end

      if target_index < 1 or target_index > #journal_files then
        vim.notify("No more journal entries in that direction", vim.log.levels.INFO)
        return
      end

      vim.cmd("edit " .. journal_files[target_index])
    end

    local function open_daily_journal(offset, create_if_missing)
      offset = offset or 0
      create_if_missing = create_if_missing == nil and true or create_if_missing

      local current_date = get_file_date()
      local journal_dir = vim.fn.expand("~/orgfiles/journal")
      local target_date = current_date + (offset * 86400)
      local date_str = os.date("%Y-%m-%d", target_date)
      local journal_path = journal_dir .. "/" .. date_str .. ".org"

      -- Check if file exists when navigating
      if not create_if_missing and vim.fn.filereadable(journal_path) == 0 then
        vim.notify("No journal entry for " .. date_str, vim.log.levels.INFO)
        return
      end

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

    local function create_journal_for_date()
      vim.ui.input({ prompt = "Enter date (YYYY-MM-DD) or leave empty for today: " }, function(input)
        if input == nil then
          return -- User cancelled
        end

        local date_str = input:match("^%s*(.-)%s*$") -- Trim whitespace
        local target_date

        if date_str == "" then
          target_date = os.time()
          date_str = os.date("%Y-%m-%d", target_date)
        else
          local year, month, day = date_str:match("^(%d%d%d%d)-(%d%d)-(%d%d)$")
          if not year or not month or not day then
            vim.notify("Invalid date format. Use YYYY-MM-DD", vim.log.levels.ERROR)
            return
          end
          target_date = os.time({ year = year, month = month, day = day })
          date_str = os.date("%Y-%m-%d", target_date) -- Normalize date
        end

        local journal_dir = vim.fn.expand("~/orgfiles/journal")
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
          vim.cmd("normal! 5G$")
        end
      end)
    end

    local function create_weekly_review()
      local journal_dir = vim.fn.expand("~/orgfiles/journal")
      local date_str = os.date("%Y-%m-%d")
      local week_str = os.date("Week %U - %Y")
      local review_path = journal_dir .. "/weekly-review-" .. date_str .. ".org"

      vim.fn.mkdir(journal_dir, "p")
      vim.cmd("edit " .. review_path)

      if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
        local lines = {
          "#+TITLE: Weekly Review - " .. week_str,
          "#+DATE: " .. date_str,
          "",
          "* Weekly Review Checklist",
          "** TODO Process Inbox (refile.org)",
          "   - [ ] Process all items in inbox",
          "   - [ ] Clarify unclear items",
          "   - [ ] File or delete as needed",
          "",
          "** TODO Review Projects",
          "   - [ ] Review all PROJECT items",
          "   - [ ] Ensure each project has a NEXT action",
          "   - [ ] Archive completed projects",
          "",
          "** TODO Review WAITING items",
          "   - [ ] Check on delegated tasks",
          "   - [ ] Follow up if needed",
          "   - [ ] Update or remove stale items",
          "",
          "** TODO Review Next Week's Calendar",
          "   - [ ] Check upcoming appointments",
          "   - [ ] Prepare materials needed",
          "   - [ ] Block time for important tasks",
          "",
          "** TODO Review SOMEDAY/Maybe list",
          "   - [ ] Review someday items",
          "   - [ ] Promote any items to active",
          "   - [ ] Remove items no longer relevant",
          "",
          "** TODO Get Clear",
          "   - [ ] Empty head - capture any lingering thoughts",
          "   - [ ] Review notes from past week",
          "   - [ ] Set goals for next week",
          "",
          "* Notes",
          "",
          "* Wins This Week",
          "",
          "* Learnings",
          "",
        }
        vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
        vim.cmd("normal! 5G")
        vim.notify("Created weekly review for " .. week_str, vim.log.levels.INFO)
      end
    end

    local function add_todo_for_date()
      vim.ui.input({ prompt = "Enter date (YYYY-MM-DD) or leave empty for today: " }, function(date_input)
        if date_input == nil then
          return -- User cancelled
        end

        local date_str = date_input:match("^%s*(.-)%s*$") -- Trim whitespace
        local target_date

        if date_str == "" then
          target_date = os.time()
          date_str = os.date("%Y-%m-%d", target_date)
        else
          local year, month, day = date_str:match("^(%d%d%d%d)-(%d%d)-(%d%d)$")
          if not year or not month or not day then
            vim.notify("Invalid date format. Use YYYY-MM-DD", vim.log.levels.ERROR)
            return
          end
          target_date = os.time({ year = year, month = month, day = day })
          date_str = os.date("%Y-%m-%d", target_date) -- Normalize date
        end

        -- Prompt for task state
        vim.ui.select(
          { "TODO", "NEXT", "WAITING", "SOMEDAY", "PROJECT", "IN_PROGRESS" },
          { prompt = "Task state: " },
          function(task_state)
            if task_state == nil then
              return -- User cancelled
            end

            -- Now prompt for the todo text
            vim.ui.input({ prompt = "Todo: " }, function(todo_input)
          if todo_input == nil or todo_input:match("^%s*$") then
            return -- User cancelled or empty
          end

          local journal_dir = vim.fn.expand("~/orgfiles/journal")
          local journal_path = journal_dir .. "/" .. date_str .. ".org"

          vim.fn.mkdir(journal_dir, "p")

          -- Check if file exists and has content
          local file_exists = vim.fn.filereadable(journal_path) == 1
          local file_has_content = false

          if file_exists then
            local lines = vim.fn.readfile(journal_path)
            file_has_content = #lines > 1 or (#lines == 1 and lines[1] ~= "")
          end

              -- Create journal with template if it doesn't exist or is empty
              if not file_has_content then
                local day_name = os.date("%A", target_date)
                local lines = {
                  "#+TITLE: Journal " .. date_str,
                  "#+DATE: " .. date_str .. " " .. day_name,
                  "",
                  "* Tasks",
                  "** " .. task_state .. " " .. todo_input,
                  "   SCHEDULED: <" .. date_str .. ">",
                  "",
                  "* Daily Log",
                  "** " .. os.date("%H:%M") .. " ",
                  "",
                }
                vim.fn.writefile(lines, journal_path)
                vim.notify("Created journal and added " .. task_state .. " for " .. date_str, vim.log.levels.INFO)
              else
                -- File exists, find Tasks section and add todo
                local lines = vim.fn.readfile(journal_path)
                local tasks_line = nil

                -- Find the Tasks section
                for i, line in ipairs(lines) do
                  if line:match("^%* Tasks") then
                    tasks_line = i
                    break
                  end
                end

                if tasks_line then
                  -- Insert after Tasks heading
                  table.insert(lines, tasks_line + 1, "   SCHEDULED: <" .. date_str .. ">")
                  table.insert(lines, tasks_line + 1, "** " .. task_state .. " " .. todo_input)
                else
                  -- No Tasks section, add it before Daily Log or at end
                  local insert_pos = #lines + 1
                  for i, line in ipairs(lines) do
                    if line:match("^%* Daily Log") then
                      insert_pos = i
                      break
                    end
                  end
                  table.insert(lines, insert_pos, "")
                  table.insert(lines, insert_pos + 1, "* Tasks")
                  table.insert(lines, insert_pos + 2, "** " .. task_state .. " " .. todo_input)
                  table.insert(lines, insert_pos + 3, "   SCHEDULED: <" .. date_str .. ">")
                  table.insert(lines, insert_pos + 4, "")
                end

                vim.fn.writefile(lines, journal_path)
                vim.notify("Added " .. task_state .. " to " .. date_str, vim.log.levels.INFO)
              end
            end)
          end
        )
      end)
    end

    -- Keybindings
    vim.keymap.set("n", "<Leader>ww", function()
      open_daily_journal(0)
    end, { desc = "Open today's journal" })
    vim.keymap.set("n", "<Leader>w<Leader>i", function()
      open_daily_journal(0)
    end, { desc = "Open today's journal (index)" })
    vim.keymap.set("n", "<C-Up>", function()
      navigate_journal_files(-1)
    end, { desc = "Open previous journal" })
    vim.keymap.set("n", "<C-Down>", function()
      navigate_journal_files(1)
    end, { desc = "Open next journal" })
    vim.keymap.set("n", "<Leader>wt", function()
      create_journal_for_date()
    end, { desc = "Create journal for specific date" })
    vim.keymap.set("n", "<Leader>wT", function()
      add_todo_for_date()
    end, { desc = "Add todo for specific date" })
    vim.keymap.set("n", "<Leader>wr", function()
      create_weekly_review()
    end, { desc = "Create weekly review" })

    -- Checkbox toggle and TODO shortcuts for org files (set as autocommand for org filetype)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "org",
      callback = function()
        -- Toggle checkbox
        vim.keymap.set("n", "<Leader>x", function()
          local line = vim.api.nvim_get_current_line()
          local new_line
          if line:match("^%s*%- %[ %]") then
            new_line = line:gsub("^(%s*%- )%[ %]", "%1[X]")
          elseif line:match("^%s*%- %[X%]") then
            new_line = line:gsub("^(%s*%- )%[X%]", "%1[ ]")
          else
            return
          end
          vim.api.nvim_set_current_line(new_line)
          vim.cmd("stopinsert")
        end, { desc = "Toggle checkbox", buffer = true })

        -- Mark TODO as DONE
        vim.keymap.set("n", "<Leader>d", function()
          local line = vim.api.nvim_get_current_line()
          local todo_states = { "TODO", "NEXT", "WAITING", "SOMEDAY", "PROJECT", "IN_PROGRESS" }
          local new_line = line

          for _, state in ipairs(todo_states) do
            if line:match("^%s*%*+ " .. state .. " ") then
              new_line = line:gsub("^(%s*%*+ )" .. state .. " ", "%1DONE ")
              -- Add CLOSED timestamp
              local timestamp = os.date("[%Y-%m-%d %a %H:%M]")
              if not new_line:match("CLOSED:") then
                new_line = new_line:gsub("^(%s*%*+ DONE [^\n]+)", "%1 CLOSED: " .. timestamp)
              end
              vim.api.nvim_set_current_line(new_line)
              vim.notify("Marked as DONE", vim.log.levels.INFO)
              return
            end
          end
          vim.notify("No TODO state found on this line", vim.log.levels.WARN)
        end, { desc = "Mark TODO as DONE", buffer = true })
      end,
    })

    vim.keymap.set("n", "<Leader>oq", function()
      local config = require("orgmode").config
      print("Agenda files: " .. vim.inspect(config.org_agenda_files))
    end, { desc = "Show agenda files" })

    -- Setup orgmode
    require("orgmode").setup({
      org_agenda_files = {
        "~/orgfiles/journal/*.org",
        "~/orgfiles/refile.org",
        "~/orgfiles/projects.org",
        "~/orgfiles/reference.org",
        "~/orgfiles/areas.org",
      },
      org_default_notes_file = "~/orgfiles/refile.org",
      org_todo_keywords = { "TODO", "NEXT", "WAITING", "SOMEDAY", "PROJECT", "IN_PROGRESS", "|", "DONE", "CANCELLED" },
      org_tag_alist = {
        { "@home", "h" },
        { "@work", "w" },
        { "@computer", "c" },
        { "@phone", "p" },
        { "@errands", "e" },
        { "@online", "o" },
      },
      org_agenda_custom_commands = {
        n = {
          description = "Next Actions",
          matcher = "TODO=\"NEXT\"",
        },
        w = {
          description = "Waiting For",
          matcher = "TODO=\"WAITING\"",
        },
        p = {
          description = "Projects",
          matcher = "TODO=\"PROJECT\"",
        },
        s = {
          description = "Someday/Maybe",
          matcher = "TODO=\"SOMEDAY\"",
        },
      },
      org_capture_templates = {
        i = {
          description = "Inbox (quick capture)",
          template = "* TODO %?\n  %U",
          target = "~/orgfiles/refile.org",
        },
        t = {
          description = "Todo to inbox",
          template = "* TODO %?\n  %U",
          target = "~/orgfiles/refile.org",
        },
        n = {
          description = "Next Action (today)",
          template = "* NEXT %? %^g\n  SCHEDULED: %t",
          target = "~/orgfiles/journal/%<%Y-%m-%d>.org",
          headline = "Tasks",
        },
        j = {
          description = "Journal entry (today)",
          template = "* %U %?\n",
          target = "~/orgfiles/journal/%<%Y-%m-%d>.org",
        },
        p = {
          description = "Project",
          template = "* PROJECT %?\n** Context\n%?\n\n** NEXT First action\n   SCHEDULED: %t\n\n** Notes\n",
          target = "~/orgfiles/projects.org",
        },
        r = {
          description = "Reference note",
          template = "* %?\n%U\n\n",
          target = "~/orgfiles/reference.org",
        },
        m = {
          description = "Meeting notes (today)",
          template = "* Meeting: %?\n  %U\n\n** Attendees\n- \n\n** Agenda\n- \n\n** Notes\n\n** Action Items\n- [ ] \n",
          target = "~/orgfiles/journal/%<%Y-%m-%d>.org",
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
