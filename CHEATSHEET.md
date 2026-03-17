# Dotfiles Cheatsheet

## Key Prefixes

| Context           | Key    |
| ----------------- | ------ |
| Neovim leader     | `,`    |
| Tmux prefix       | `C-b`  |
| Hammerspoon hyper | `⌥⌃⌘⇧` |

---

## Neovim — General

| Key         | Action                   |
| ----------- | ------------------------ |
| `,w`        | Save                     |
| `,q`        | Close buffer             |
| `,n`        | New buffer               |
| `,p`        | Paste (no replace)       |
| `,y` / `,Y` | Yank to system clipboard |
| `,d` / `,D` | Delete to blackhole      |
| `Q`         | Record macro             |
| `A-j/k`     | Move line up/down        |

## Neovim — Navigation

| Key         | Action                    |
| ----------- | ------------------------- |
| `C-n`       | Toggle file tree          |
| `C-u/d`     | Scroll + center           |
| `C-o/i`     | Jump prev/next + center   |
| `n/N`       | Next/prev search + center |
| `A-e`       | Harpoon menu              |
| `A-h/j/k/l` | Harpoon files 1–4         |
| `,m`        | Mark file in Harpoon      |

## Neovim — Telescope

| Key   | Action              |
| ----- | ------------------- |
| `,ff` | Find files          |
| `,fg` | Live grep           |
| `,fb` | Buffers             |
| `,of` | Old files           |
| `,fr` | Resume search       |
| `,/`  | Grep current buffer |
| `,xx` | Diagnostics         |

## Neovim — LSP

| Key         | Action                |
| ----------- | --------------------- |
| `gd`        | Go to definition      |
| `gD`        | Go to declaration     |
| `gri`       | Go to implementation  |
| `grr`       | Find references       |
| `gO`        | Document symbols      |
| `K`         | Hover docs            |
| `gl`        | Float diagnostic      |
| `]d` / `[d` | Next/prev diagnostic  |
| `,ca`       | Code action           |
| `,rn`       | Rename                |
| `,f`        | Format                |
| `,v`        | Definition in vsplit  |
| `,oi`       | Organize imports (TS) |
| `,ih`       | Toggle inlay hints    |

## Neovim — Git

| Key   | Action         |
| ----- | -------------- |
| `,gs` | Fugitive       |
| `,gd` | Diffview open  |
| `,gh` | File history   |
| `,gc` | Close diffview |
| `F9`  | Mergetool      |

## Neovim — Testing

| Key   | Action           |
| ----- | ---------------- |
| `,tn` | Run nearest test |
| `,tf` | Run file tests   |
| `,td` | Debug test       |
| `,ts` | Test summary     |
| `,tl` | Re-run last      |
| `,tw` | Watch mode       |

## Neovim — Debug (DAP)

| Key   | Action            |
| ----- | ----------------- |
| `,db` | Toggle breakpoint |
| `,dc` | Continue          |
| `,ds` | Step over         |
| `,di` | Step into         |
| `,do` | Step out          |
| `,dt` | Terminate         |
| `,du` | Toggle UI         |

## Neovim — Windows

| Key         | Action        |
| ----------- | ------------- |
| `A-Up/Down` | Resize height |
| `A-h/l`     | Resize width  |

---

## Tmux (after `C-b`)

| Key       | Action                 |
| --------- | ---------------------- |
| `i`       | Split horizontal (40%) |
| `u`       | Split vertical (30%)   |
| `c`       | New window             |
| `o`       | Last pane/window       |
| `h/j/k/l` | Navigate panes         |
| `s/S`     | Prev/next session      |
| `p`       | Session picker         |
| `r`       | Reload config          |
| `x`       | Fuzzy URL open         |
| `e`       | gh-dash                |

## Tmux — Without prefix

| Key            | Action                          |
| -------------- | ------------------------------- |
| `C-h/j/k/l`    | Navigate panes (vim-integrated) |
| `C-\`          | Last pane                       |
| `S-Left/Right` | Prev/next window                |

---

## Fish Shell — Git

| Alias          | Command                   |
| -------------- | ------------------------- |
| `gs`           | `git status -sb`          |
| `ga` / `gaa`   | `git add` / `git add -A`  |
| `gc` / `gcm`   | commit / commit -m        |
| `gp`           | push origin HEAD          |
| `gl`           | pull --prune              |
| `gco`          | checkout                  |
| `gw` / `gwc`   | switch / switch -c        |
| `gm` / `gms`   | switch to main / + sync   |
| `glg` / `glga` | pretty log / all branches |
| `gpr`          | create PR                 |

## Fish Shell — General

| Alias          | Command              |
| -------------- | -------------------- |
| `e` / `v`      | `nvim`               |
| `ta`           | tmux attach default  |
| `c [project]`  | cd into `$PROJECTS/` |
| `h [path]`     | cd into `$HOME/`     |
| `la/ll/lla/lt` | lsd variants         |
| `fd`           | fd --hidden          |

## Fish Shell — Keybindings

| Key   | Action                |
| ----- | --------------------- |
| `A-e` | Edit cmd in `$EDITOR` |

---

## Hammerspoon (Hyper = `⌥⌃⌘⇧`)

| Key                  | Action               |
| -------------------- | -------------------- |
| `Hyper + \`          | Reload config        |
| `Hyper + Left/Right` | Snap left/right half |
| `Hyper + Up/Down`    | Snap top/bottom half |
| `Hyper + ;`          | Maximize             |
| `Hyper + '`          | Center 80%           |
| `Hyper + N`          | Move to next screen  |

## App Launchers (Hyper)

| Key | App       |
| --- | --------- |
| `U` | Ghostty   |
| `I` | Safari    |
| `O` | Notes     |
| `P` | Discord   |
| `H` | Reminders |
| `J` | Calendar  |
| `K` | Mail      |
| `M` | Claude    |
| `Y` | Music     |

---

## Ghostty (`⌘`)

| Key     | Action              |
| ------- | ------------------- |
| `⌘K`    | Tmux session picker |
| `⌘T`    | New tmux window     |
| `⌘D`    | Split right         |
| `⇧⌘D`   | Split bottom        |
| `⌘1–9`  | Tmux window 1–9     |
| `⌃Tab`  | Next session        |
| `⇧⌃Tab` | Prev session        |

---

## Neovim — Org / GTD

### Journal

| Key         | Action                     |
| ----------- | -------------------------- |
| `,ww`       | Open today's journal       |
| `,wt`       | Create journal for date    |
| `,wT`       | Add todo for specific date |
| `,wr`       | Create weekly review       |
| `C-Up/Down` | Prev/next journal file     |

### Capture & Agenda

| Key   | Action  |
| ----- | ------- |
| `,aa` | Agenda (n=NEXT, w=WAITING, p=Projects, s=Someday) |
| `,cc` | Capture |

### Capture Templates

| Key | Template              |
| --- | --------------------- |
| `i` | Inbox (quick capture) |
| `t` | Todo to inbox         |
| `n` | Next action (today)   |
| `j` | Journal entry (today) |
| `p` | Project               |
| `r` | Reference note        |
| `m` | Meeting notes (today) |

### In `.org` files

| Key  | Action            |
| ---- | ----------------- |
| `,x` | Toggle checkbox   |
| `,d` | Mark TODO as DONE |
| `,w` | Finalize capture  |
| `,r` | Refile capture    |

### Search

| Key   | Action                          |
| ----- | ------------------------------- |
| `,wg` | Search all org files (live grep) |
| `,wo` | Browse all org files            |
| `,wf` | Browse journal entries          |
| `,wR` | Browse weekly reviews           |
| `,wi` | Open inbox (refile.org)         |
| `,fh` | Search headings                 |
| `,ft` | Find TODOs / IN_PROGRESS        |
| `,fT` | Find all tasks (inc. DONE)      |
| `,fn` | Find NEXT actions               |
| `,fw` | Find WAITING items              |
| `,fp` | Find PROJECTs                   |
| `,fs` | Find SOMEDAY items              |
| `,li` | Insert link                     |

### TODO States

`TODO` → `NEXT` → `IN_PROGRESS` → `WAITING` → `SOMEDAY` → `PROJECT` → `DONE` / `CANCELLED`

---

## Git Aliases (in `.gitconfig`)

| Alias         | Action                    |
| ------------- | ------------------------- |
| `git commend` | Amend without editing msg |
| `git please`  | Force push with lease     |
| `git lt`      | Log tags only             |
| `git count`   | Commits by author         |
