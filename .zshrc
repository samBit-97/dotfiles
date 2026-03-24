# Zsh completion system — recompile dump only once per day
autoload -Uz compinit
if [[ -z "$ZSH_COMPDUMP" ]]; then
  ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"
fi
if [[ "$ZSH_COMPDUMP"(#qNmh-24) ]]; then
  compinit -C -d "$ZSH_COMPDUMP"
else
  compinit -d "$ZSH_COMPDUMP"
fi

# ---- starship ----
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"  # Replace 'zsh' with your shell if different

# ---- FZF -----
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# -- Use fd instead of fzf --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

source ~/fzf-git.sh/fzf-git.sh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# ---- Television (tv) ----
eval "$(tv init zsh)"

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

alias f="z"
alias cat="bat"
v() {
  local count=$(pgrep -c nvim 2>/dev/null || echo 0)
  if (( count >= 5 )); then
    echo "\033[33m⚠ $count nvim instances running. Consider closing some first.\033[0m"
    echo "  Run: nvm-mem"
  fi
  nvim "$@"
}

# ---- Autosuggestions and syntax highlighting ----
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Sesh config to list directories and tmux sessions
sesh_menu_with_icons() {
  sesh connect "$(
    sesh list --icons | fzf \
      --ansi --no-sort --border-label ' sesh ' --prompt '⚡  ' \
      --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
      --bind 'tab:down,btab:up' \
      --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
      --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
      --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
      --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
      --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
      --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)'
  )"
}

# Aliases 
alias menu="sesh_menu_with_icons"
alias ld="lazydocker"
alias lg="lazygit"
alias gd="gh dash"
alias k="kubectl"
alias nvm-mem="ps aux | grep nvim | grep -v grep | awk '{sum+=\$6} END {printf \"Neovim total: %.0f MB (%d instances)\\n\", sum/1024, NR}'"
alias awslocal='aws --endpoint-url=http://localhost:4566'
# Alias to run java from terminal
jcompile() {
    mkdir -p bin
    javac -d bin $(find . -name "*.java") || return 1
}
# ---- Eza (better ls) -----
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ll='eza --color=always --long --git --icons=always'

# SDKMAN Initialization
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

. "$HOME/.local/bin/env"

# kubectl autocomplete — lazy-loaded (saves ~250ms startup)
if (( $+commands[kubectl] )); then
  function kubectl() {
    unfunction kubectl
    source <(command kubectl completion zsh)
    command kubectl "$@"
  }
fi

# Default editor
export EDITOR="nvim"

# Neovim theme
export NVIM_THEME="gruvbox"

### Secrets (API keys, tokens — not tracked in git)
[ -f ~/.secrets ] && source ~/.secrets

# Cache go env GOPATH (saves ~30ms vs running go env every shell)
if [[ -z "$GOPATH" ]]; then
  export GOPATH="${HOME}/go"
fi
export PATH="$PATH:${GOPATH}/bin"

# Added by Antigravity
export PATH="/Users/sambitbehera/.antigravity/antigravity/bin:$PATH"
