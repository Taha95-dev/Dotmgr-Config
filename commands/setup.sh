#!/usr/bin/env bash

set -e

echo "User: $USER"
echo "Home: $HOME"

# ---- Directories
echo "📁 Creating standard directories..."
mkdir -p ~/Documents ~/Downloads ~/Music ~/Pictures/Screenshots ~/Videos
mkdir -p ~/Projects/go ~/Projects/python ~/Projects/cpp ~/Projects/arch
mkdir -p ~/.local/bin ~/.local/share ~/.config ~/.cache ~/.local/state

echo "✅ Directories created"

# ---- Yay Install
if ! command -v yay &>/dev/null; then
  echo "AUR: Installing 'yay' dependency manager..."
  (
    mkdir -p /tmp/yay-build
    cd /tmp/yay-build
    git clone https://aur.archlinux.org/yay.git .
    makepkg -si --noconfirm
  )
fi

# ---- Git
echo "🔧 Configuring Git..."
git config --global user.name "Taha"
git config --global user.email "kashiftaha976@gmail.com"
git config --global init.defaultBranch main
git config --global core.editor nvim
git config --global pull.rebase false

echo "🔑 Logging into GitHub..."
if ! gh auth status &>/dev/null; then
  echo "Please authenticate with GitHub:"
  gh auth login || true
else
  echo "✅ Already logged in to GitHub"
fi

# ---- GTK themes
echo "🎨 Applying GTK dark theme..."
if command -v gsettings &>/dev/null; then
    gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
fi

# ---- Zsh
echo "🖥️  Setting up Zsh..."
if [ "$SHELL" != "$(which zsh)" ]; then
  sudo chsh -s "$(which zsh)" "$USER"
  echo "✅ Default shell changed to zsh (will apply after logout)"
else
  echo "✅ Zsh is already your default shell"
fi

# ---- Loom
echo "📦 Cloning Loom..."
if [ ! -d "$HOME/Projects/Loom" ]; then
  git clone https://github.com/Loom-V2/Loom-paid.git "$HOME/Projects/Loom"
else
  echo "✅ loom already cloned"
fi

echo "🔨 Building Loom..."
(
  cd "$HOME/Projects/Loom"
  go build -o loom
  sudo cp loom /usr/local/bin/
)
loom version || echo "⚠️  loom binary built but couldn't execute display version"

# ---- Nvim
echo "📝 Initializing Neovim Ecosystem..."

nvim --headless "+Lazy! sync" +qa || true
echo "🌳 Installing Tree-sitter parsers and LSP Engines via Mason..."
nvim --headless -c "MasonInstall clangd" -c "qa" || true
nvim --headless -c "TSInstallSync c cpp lua" -c "qa" || true

# ---- Verify
echo "🔍 Verifying setup..."
for f in "$HOME/.zshrc" "$HOME/.config/nvim/init.lua" "$HOME/.editorconfig" "$HOME/.config/gtk-3.0"; do
  if [ -e "$f" ]; then
    echo "  ✅ $f"
  else
    echo "  ❌ $f missing"
  fi
done
