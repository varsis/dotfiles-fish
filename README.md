# caarlos0/dotfiles

This is my latest dotfiles generation.

I've been experimenting with many different tools to manage them properly, from
Ansible to shell scripts, and never liked any of them that much, to be honest.

You can see the history on these repositories:

- [dotfiles.zsh](https://github.com/caarlos0/dotfiles.zsh)
- [dotfiles.fish](https://github.com/caarlos0/dotfiles.fish)

Then, I tried nix, which seemed fine, but also overkill for my case.
In the end, what I really wanted was just a simple shell script, which is this
version here!

## Applying

```bash
./setup
```

## Key Bindings

### Neovim
- **Leader**: `,` (comma)

#### Buffer Management
- `,n` - Create new buffer
- `,q` - Delete current buffer  
- `,bad` - Delete all buffers
- `,bsd` - Delete surrounding buffers (keep current)

#### File Operations
- `,w` - Save file
- `,W` - Save without autocommands
- `,py` - Copy current file path to clipboard

#### Navigation & Movement
- `<C-u>`, `<C-d>`, `<C-o>`, `<C-i>` - Page up/down with cursor centering
- `n`, `N` - Search next/prev with cursor centering
- `<Alt-Up/Down/Left/Right>` - Resize windows

#### Clipboard & Registers
- `,y`, `,Y` - Copy to system clipboard
- `,d`, `,D` - Delete to blackhole register
- `,p` - Paste without replacing register

#### Git Integration
- `,gs` - Open Git status in new tab
- `<F9>` - Git mergetool

#### Plugin-Specific
- `<C-n>` - Toggle NeoTree file explorer
- `,ot` - Toggle opencode AI assistant
- `,oa` - Ask opencode about cursor/selection
- `,jf` - Format JSON with jq
- `,x` - Toggle markdown checkbox

### Org-mode & GTD (Getting Things Done)

#### Journal Navigation
- `,ww` - Open today's journal
- `,w,i` - Open today's journal (alternative)
- `,wt` - Create journal for specific date
- `<C-Up>` - Navigate to previous journal entry
- `<C-Down>` - Navigate to next journal entry
- `,wf` - Browse all journal entries (Telescope)
- `,wR` - Browse all weekly reviews (Telescope)
- `,wi` - Open inbox (refile.org)
- `,wo` - Browse all org files (Telescope)

#### Task Management
- `,wT` - Add task for specific date (prompts for state and description)
- `,cc` - Open capture menu
  - `i` or `t` - Quick TODO to inbox (process later)
  - `n` - NEXT action (with tag prompt, scheduled today)
  - `j` - Journal entry (today's journal)
  - `p` - New PROJECT (creates in projects.org)
  - `r` - Reference note (saves to reference.org)
  - `m` - Meeting notes (structured template in today's journal)
- `,w` - Finalize capture
- `,r` - Refile capture to different location
- `,x` - Toggle checkbox `[ ]` ↔ `[X]` (in org files)

#### Agenda & Views
- `,aa` - Open agenda view
  - Press `n` - View NEXT actions
  - Press `w` - View WAITING items
  - Press `p` - View PROJECTS
  - Press `s` - View SOMEDAY/Maybe items
  - Press `H/L` - Earlier/later dates
  - Press `q` - Quit agenda

#### Weekly Review
- `,wr` - Create weekly review checklist

#### Telescope Search (GTD)
- `,ft` - Find active TODOs (TODO + IN_PROGRESS)
- `,fT` - Find all tasks (including DONE)
- `,fn` - Find NEXT actions
- `,fw` - Find WAITING items
- `,fp` - Find PROJECTS
- `,fs` - Find SOMEDAY items
- `,wf` - Browse all journal entries

#### Task States
- **TODO** - Captured but not clarified
- **NEXT** - Next actionable task (single concrete action)
- **WAITING** - Waiting on someone else
- **SOMEDAY** - Maybe/someday list
- **PROJECT** - Multi-step outcome
- **IN_PROGRESS** - Currently working on
- **DONE** - Completed
- **CANCELLED** - Cancelled

#### Context Tags
Quick-add with `Ctrl+C Ctrl+C` on a heading:
- `@home` (h), `@work` (w), `@computer` (c), `@phone` (p), `@errands` (e), `@online` (o)

#### Org File Structure
- `~/orgfiles/journal/*.org` - Daily journals with tasks and logs
- `~/orgfiles/refile.org` - Inbox for quick captures (process to zero weekly)
- `~/orgfiles/projects.org` - Active multi-step projects
- `~/orgfiles/reference.org` - Reference material and notes (no actions)
- `~/orgfiles/areas.org` - Life areas and responsibilities
- `~/orgfiles/journal/weekly-review-*.org` - Weekly review checklists

#### GTD Workflow
1. **Capture**: Quick capture throughout the day
   - Anything that pops up → `,cc` → `i` or `t` (goes to inbox)
   - If you know it's a project → `,cc` → `p` (goes to projects.org)
   - Reference info → `,cc` → `r` (goes to reference.org)
   - When you need it scheduled today → `,cc` → `n` (NEXT action)
2. **Clarify**: Daily or weekly review inbox (`,wi`)
   - For each item ask: "What is it? Is it actionable?"
3. **Organize**: Process each inbox item (use `,r` to refile)
   - Single action → Change to NEXT, add context tag, refile to today or specific date
   - Multiple steps → Change to PROJECT, refile to projects.org, create NEXT actions
   - Reference info → Refile to reference.org
   - Waiting on someone → Change to WAITING
   - Not now → Change to SOMEDAY
   - Not needed → Delete
4. **Reflect**: Weekly run `,wr` for review, process inbox to zero
5. **Engage**: Use `,fn` to see NEXT actions, pick one and work on it

### Hammerspoon (macOS Window Management)
**Hyper Key**: `Alt+Ctrl+Cmd+Shift`

#### Window Positioning
- `Hyper + Left/Right/Up/Down` - Move window to half of screen
- `Hyper + ;` - Maximize window
- `Hyper + '` - Center window at 80% size

#### Application Launchers
- `Hyper + U` - Launch Ghostty (terminal)
- `Hyper + I` - Launch Safari
- `Hyper + M` - Launch Claude
- `Hyper + Y/O/P/H/J/K` - Launch Music/Notes/Discord/Reminders/Calendar/Mail

### Tmux
#### Pane Management
- `u` - Split horizontal (30% bottom)
- `i` - Split vertical (40% right)  
- `h/j/k/l` - Select panes (vim-like)
- `<C-h/j/k/l>` - Smart navigation (works with Vim)

#### Session Management
- `s/S` - Previous/next session
- `p` - Run tmux-sessionizer
- `<S-Left/Right>` - Switch windows

#### Copy Mode
- `v` - Begin selection
- `y` - Copy to system clipboard

## Releasing

```bash
./scripts/release.sh
```
