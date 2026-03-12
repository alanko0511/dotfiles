# ~/.zshrc — Interactive shell configuration
# Managed by dotfiles repo. Machine-specific config goes in ~/.zshrc.local

# ── History ──────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY

# ── Completion ───────────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select

# ── Shell Options ────────────────────────────────────────────────────
setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP
setopt EXTENDED_GLOB

# ── Local Overrides ──────────────────────────────────────────────────
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
