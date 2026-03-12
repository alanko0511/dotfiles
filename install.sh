#!/usr/bin/env bash
set -euo pipefail

# ── Colours ──────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
RESET='\033[0m'

info()  { printf "${GREEN}[✓]${RESET} %s\n" "$1"; }
warn()  { printf "${YELLOW}[!]${RESET} %s\n" "$1"; }
error() { printf "${RED}[✗]${RESET} %s\n" "$1"; }

# ── Setup ────────────────────────────────────────────────────────────
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
BACKED_UP=false

OS="$(uname -s)"
case "$OS" in
  Darwin) OS_NAME="macOS" ;;
  Linux)  OS_NAME="Linux" ;;
  *)      error "Unsupported OS: $OS"; exit 1 ;;
esac

printf "${BOLD}Dotfiles installer${RESET} — detected %s\n\n" "$OS_NAME"

# ── Helpers ──────────────────────────────────────────────────────────
backup_and_copy() {
  local src="$1" dest="$2"

  if [ -f "$dest" ]; then
    if ! $BACKED_UP; then
      mkdir -p "$BACKUP_DIR"
      BACKED_UP=true
    fi
    cp "$dest" "$BACKUP_DIR/"
    warn "Backed up existing $(basename "$dest") → $BACKUP_DIR/"
  fi

  cp "$src" "$dest"
  info "Installed $(basename "$dest")"
}

# ── Install Config Files ────────────────────────────────────────────
backup_and_copy "$DOTFILES_DIR/zsh/.zshrc"     "$HOME/.zshrc"
backup_and_copy "$DOTFILES_DIR/zsh/.zshenv"    "$HOME/.zshenv"
backup_and_copy "$DOTFILES_DIR/git/.gitconfig"  "$HOME/.gitconfig"

# ── OS-Specific: Credential Helper ──────────────────────────────────
case "$OS" in
  Darwin)
    git config --global credential.helper osxkeychain
    info "Set git credential helper → osxkeychain"
    ;;
  Linux)
    git config --global credential.helper store
    info "Set git credential helper → store"
    ;;
esac

# ── Summary ──────────────────────────────────────────────────────────
printf "\n${BOLD}Done!${RESET} Installed:\n"
printf "  • ~/.zshrc\n"
printf "  • ~/.zshenv\n"
printf "  • ~/.gitconfig\n"
if $BACKED_UP; then
  printf "\nPrevious files backed up to ${YELLOW}%s${RESET}\n" "$BACKUP_DIR"
fi
printf "\nRestart your shell or run ${BOLD}source ~/.zshrc${RESET} to apply changes.\n"
