# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for managing development environment configuration across macOS and Debian/Ubuntu systems. The setup uses symlinks to deploy configuration files from this repo to their expected locations in the user's home directory.

## Installation and Setup

### Initial Installation
```bash
make install
```
This runs `install.zsh`, which:
- Detects the OS (macOS or Debian/Ubuntu)
- Installs dependencies via Homebrew (macOS) or apt (Debian/Ubuntu)
- Installs WezTerm (terminal), Starship (prompt), fonts, and development tools
- Installs Node.js via nvm and sets up LSP servers (TypeScript, Lua, Biome, GitHub Copilot)
- Creates symlinks from `config/*` to `~/.config/`
- Creates symlink from `.zshrc` to `~/.zshrc`

### Reloading Configuration
```bash
# Reload zsh configuration
reload

# Or manually
source ~/.zshrc
```

## Architecture

### Configuration Structure

The repository follows XDG Base Directory conventions:
- `config/` - Contains all application configs, symlinked to `~/.config/`
- `.zshrc` - Zsh shell configuration, symlinked to `~/.zshrc`
- `install.zsh` - OS-agnostic installation script with platform detection

### Key Components

**WezTerm** (`config/wezterm/wezterm.lua`)
- Terminal emulator configuration
- Launches tmux by default: `tmux -f ~/.config/tmux/tmux.conf`
- Dynamic wallpaper rotation from `~/wallpapers` using CMD+R
- Custom keybindings that pass through CMD+E and CMD+S as Ctrl equivalents

**Neovim** (`config/nvim/`)
- Entry point: `init.lua` requires `personal/` modules
- Plugin manager: Lazy.nvim (bootstrapped in `personal/lazy.lua`)
- Plugins are defined in `lua/plugins/*.lua` files
- Auto-format on save for TS/JS/Lua/Python files
- LSP configuration in `plugins/lsp.lua`
- Leader key: Space

**Tmux** (`config/tmux/tmux.conf`)
- Uses TPM (Tmux Plugin Manager) installed via Homebrew
- Plugins: tmux-cpu, catppuccin theme, tmux-sensible, tmux-resurrect
- Custom keybindings:
  - `Prefix + R`: Rename window
  - `Ctrl-S`: Save tmux session
  - `Ctrl-R`: Restore tmux session
- Vi-mode copy with automatic clipboard integration (pbcopy on macOS)

**Starship** (`config/starship.toml`)
- Cross-shell prompt with custom module layout
- Multi-segment prompt showing: OS, user, directory, git, language versions, time
- Three color palettes available: `pastel`, `pastel_brite`, `catppuccin_mocha`

### Development Tools Stack

**Installed by default:**
- **Terminal**: WezTerm (nightly on macOS)
- **Shell**: Zsh with syntax highlighting
- **Multiplexer**: tmux with session persistence
- **Editor**: Neovim with LSP support
- **CLI Tools**: eza (ls replacement), ripgrep (grep replacement), lazygit
- **Node**: Managed via nvm (LTS version)
- **LSP Servers**: TypeScript, Lua, Biome formatter, GitHub Copilot
- **Fonts**: JetBrains Mono Nerd Font, Fira Code Nerd Font, Fragment Mono

## Making Changes

### Adding New Neovim Plugins
Create a new file in `config/nvim/lua/plugins/` that returns a Lazy.nvim plugin spec:
```lua
return {
  "author/plugin-name",
  config = function()
    -- plugin setup
  end,
}
```

### Modifying Neovim Settings
- Global settings: `config/nvim/lua/personal/settings.lua`
- Keymaps: `config/nvim/lua/personal/remap.lua`
- Plugin configs: Individual files in `config/nvim/lua/plugins/`

### Adding Tmux Plugins
Add to `config/tmux/tmux.conf`:
```bash
set -g @plugin 'author/plugin-name'
```
Then reload tmux: `tmux source-file ~/.config/tmux/tmux.conf` and install with Prefix + I

### Modifying Zsh Configuration
Edit `.zshrc` directly. Changes take effect after running `reload` or restarting the shell.

## Important Notes

- The install script uses `ln -snf` for symlinks, so re-running is safe (force overwrites)
- WezTerm config expects wallpapers in `~/wallpapers/` directory
- Tmux is configured to auto-attach to existing session or create new one
- NVM is initialized in `.zshrc` - use `nvm install/use` to manage Node versions
- Auto-formatting on save is enabled in Neovim for TS/JS/Lua/Python files
