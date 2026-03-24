#!/bin/bash
# Fedora package installer — mirrors Brewfile for Linux
# Usage: chmod +x packages-fedora.sh && ./packages-fedora.sh

set -euo pipefail

echo "==> Installing dnf packages..."

# Core shell & terminal
sudo dnf install -y \
  zsh \
  tmux \
  neovim \
  stow \
  tree \
  wget \
  curl \
  unzip \
  git

# Search & file tools
sudo dnf install -y \
  fzf \
  fd-find \
  bat \
  eza \
  ripgrep \
  zoxide \
  jq

# Languages & runtimes
sudo dnf install -y \
  golang \
  python3 \
  python3-pip \
  pipx \
  nodejs \
  npm \
  lua \
  elixir

# Build tools
sudo dnf install -y \
  gcc \
  gcc-c++ \
  make \
  cmake \
  llvm \
  protobuf-compiler

# Cloud & DevOps
sudo dnf install -y \
  awscli2 \
  helm \
  httpie

# Terraform (requires HashiCorp repo)
if ! command -v terraform &>/dev/null; then
  sudo dnf install -y 'dnf-command(config-manager)' 2>/dev/null
  sudo dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo 2>/dev/null
  sudo dnf install -y terraform 2>/dev/null || echo "WARN: terraform install failed — add HashiCorp repo manually"
fi

# Databases (install only if needed)
# sudo dnf install -y mariadb-server mongodb-mongosh

echo ""
echo "==> Installing tools not in dnf..."

# Starship prompt
if ! command -v starship &>/dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Go-based tools
echo "Installing Go tools..."
go install github.com/jesseduffield/lazygit@latest
go install github.com/jesseduffield/lazydocker@latest
go install github.com/joshmedeski/sesh@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install golang.org/x/tools/gopls@latest
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
go install honnef.co/go/tools/cmd/staticcheck@latest

# GitHub CLI
if ! command -v gh &>/dev/null; then
  sudo dnf install -y 'dnf-command(config-manager)'
  sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
  sudo dnf install -y gh
fi

# Television
if ! command -v tv &>/dev/null; then
  echo "Install television from: https://github.com/alexpasmantier/television/releases"
  echo "  or: cargo install television"
fi

# Yazi (terminal file manager)
if ! command -v yazi &>/dev/null; then
  echo "Install yazi from: https://github.com/sxyazi/yazi/releases"
  echo "  or: cargo install yazi-fm yazi-cli"
fi

# diffnav + delta
if ! command -v diffnav &>/dev/null; then
  echo "Install diffnav from: https://github.com/dlvhdr/diffnav/releases"
fi
if ! command -v delta &>/dev/null; then
  sudo dnf install -y git-delta
fi

# k9s
if ! command -v k9s &>/dev/null; then
  echo "Install k9s from: https://github.com/derailed/k9s/releases"
fi

# SDKMAN (Java toolchain)
if [ ! -d "$HOME/.sdkman" ]; then
  curl -s "https://get.sdkman.io" | bash
fi

echo ""
echo "==> Installing Nerd Fonts..."
mkdir -p ~/.local/share/fonts

# Download MesloLGS Nerd Font (matches macOS setup)
if [ ! -f ~/.local/share/fonts/MesloLGSNerdFont-Regular.ttf ]; then
  FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.tar.xz"
  curl -L "$FONT_URL" -o /tmp/meslo-nerd-font.tar.xz
  tar -xf /tmp/meslo-nerd-font.tar.xz -C ~/.local/share/fonts/
  fc-cache -fv
  rm /tmp/meslo-nerd-font.tar.xz
fi

echo ""
echo "==> Installing zsh plugins..."
ZSH_PLUGIN_DIR="${HOME}/.local/share/zsh/plugins"
mkdir -p "$ZSH_PLUGIN_DIR"

if [ ! -d "$ZSH_PLUGIN_DIR/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGIN_DIR/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting"
fi

echo ""
echo "==> Setting zsh as default shell..."
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)"
fi

echo ""
echo "==> Done! Next steps:"
echo "  1. cd ~/dotfiles && stow -t ~ ."
echo "  2. Update .zshrc plugin paths for Linux (see OS detection block)"
echo "  3. nvim --headless '+Lazy! sync' +qa"
echo "  4. touch ~/.secrets && chmod 600 ~/.secrets"
echo "  5. Log out and back in for zsh to take effect"
