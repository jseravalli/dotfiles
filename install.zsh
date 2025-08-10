#!/usr/bin/env zsh
set -euo pipefail

# Config paths
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/code/jseravalli/dotfiles}"
CONFIG_SRC="$DOTFILES_DIR/config"
CONFIG_DEST="${XDG_CONFIG_HOME:-$HOME/.config}"
ZSHRC_SRC="$DOTFILES_DIR/.zshrc"
ZSHRC_DEST="$HOME/.zshrc"


# Detect OS and install
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "→ Installing WezTerm and Starship..."
    # macOS
    if ! command -v brew >/dev/null 2>&1; then
        echo "❌ Homebrew not found. Please install it first: https://brew.sh"
        exit 1
    fi
    brew install --cask wezterm
    brew install starship

  echo "→ Installing fonts (macOS)…"
  # Nerd Font variants (include Symbols-Only for guaranteed icons)
  brew install --cask font-jetbrains-mono-nerd-font
  brew install --cask font-fira-code-nerd-font
  brew install --cask font-symbols-only-nerd-font
  # Fragment Mono (Google font; not Nerd-patched, but fine as primary text face)
  brew install --cask font-fragment-mono

  echo "→ Installing syntax highlighting (macOS)"
  brew install zsh-syntax-highlighting

  echo "→ Installing Lazy Git (macOS)"
  brew install lazygit

  echo "→ Installing Eza (macOS)"
  brew install eza

elif [[ -f /etc/debian_version ]]; then
    # Debian/Ubuntu
    sudo apt update
    sudo apt install -y curl wezterm starship lazygit eza

  echo "→ Installing fonts (Debian/Ubuntu)…"
  FONT_DIR="$HOME/.local/share/fonts"
  mkdir -p "$FONT_DIR"
  pushd "$FONT_DIR" >/dev/null

  # JetBrains Mono Nerd Font (for rich symbols)
  curl -fsSL -o JetBrainsMono.zip \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
  unzip -o JetBrainsMono.zip && rm JetBrainsMono.zip

  # Nerd Fonts Symbols Only (icon fallback without changing your main font)
  curl -fsSL -o SymbolsOnly.zip \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/SymbolsOnly.zip
  unzip -o SymbolsOnly.zip && rm SymbolsOnly.zip

  # Fragment Mono (Google Fonts)
  curl -fsSL -o FragmentMono.zip \
    https://github.com/google/fonts/raw/main/ofl/fragmentmono/FragmentMono%5Bwght%5D.ttf
  # Some distros ship it already; if we downloaded a single TTF, just leave it.
  # If curl saved as .ttf, rename properly:
  if file FragmentMono.zip | grep -qi 'TrueType'; then
    mv FragmentMono.zip "FragmentMono[wght].ttf"
  fi

  fc-cache -f
  popd >/dev/null

  echo "→ Installing syntax highlighting (Debian)"
  sudo apt-get -y install zsh-syntax-highlighting
else
    echo "⚠️ Unsupported OS. Please install WezTerm and Starship manually."
fi

echo "→ Creating symlink for config folder..."
mkdir -p "$CONFIG_DEST"
ln -snf "$CONFIG_SRC"/* "$CONFIG_DEST/"

echo "→ Creating symlink for .zshrc..."
ln -snf "$ZSHRC_SRC" "$ZSHRC_DEST"

echo "✅ Done!"
