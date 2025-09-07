# Agent Guidelines for Dotfiles

## Build/Test Commands
- Setup: `./setup` (symlinks configs, installs dependencies)
- Release: `./scripts/release.sh`
- Neovim sync: `nvim --headless "+Lazy! sync" +qa`
- Style check (Lua): `stylua --check .` (format with `stylua .`)

## Code Style Guidelines
- **Indentation**: 2 spaces for most files, 4 tabs for Go/Rust/Zig/Fish (see .editorconfig)
- **Line width**: 78-80 chars for most files, 120 for Lua (stylua.toml)
- **Lua style**: snake_case for variables/functions, 2-space indents, double quotes
- **Fish style**: kebab-case for functions, single quotes preferred
- **Shell scripts**: Use `set -euo pipefail`, quote variables, prefer `$PWD` over `pwd`

## File Organization
- Configs in language-specific directories (fish/, nvim/, git/, etc.)
- Scripts in bin/ (no extensions, executable)
- Neovim plugins as separate files in nvim/lua/plugins/
- Use symlinks via setup script, not direct copies

## Error Handling
- Shell: Always use `set -euo pipefail` and proper error checking
- Lua: Use pcall() for risky operations, provide meaningful error messages