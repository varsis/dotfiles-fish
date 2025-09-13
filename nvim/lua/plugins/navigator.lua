return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
    { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
    { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
    { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
  },
  config = function()
    vim.keymap.set("t", "<C-h>", "<C-\\><C-n>:TmuxNavigateLeft<cr>")
    vim.keymap.set("t", "<C-j>", "<C-\\><C-n>:TmuxNavigateDown<cr>")
    vim.keymap.set("t", "<C-k>", "<C-\\><C-n>:TmuxNavigateUp<cr>")
    vim.keymap.set("t", "<C-l>", "<C-\\><C-n>:TmuxNavigateRight<cr>")
  end,
}
