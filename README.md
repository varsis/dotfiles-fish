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
