# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# =============================================
# OH-MY-ZSH (Optional but recommended)
# =============================================
# If you want a framework, install oh-my-zsh:
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Then uncomment:
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k" # or "agnoster", "robbyrussel"
export TERM=xterm-256color 
export COLORTERM=truecolor


plugins=(
    git
    sudo
    systemd
    archlinux
    docker
    kubectl
    terraform
    command-not-found # Suggests packages for missing commands
    zsh-autosuggestions
    zsh-syntax-highlighting )

source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# =============================================
# HISTORY
# ============================================= HISTFILE=~/.zsh_history
HISTSIZE=200000
SAVEHIST=500000
setopt appendhistory
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space

# =============================================
# COMPLETION
# =============================================
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'

# =============================================
# PROMPT (Clean but informative)
# =============================================
PROMPT='%F{blue}%n@%m%f %F{green}%~%f %# '
RPROMPT='%F{red}%(?..[%?])%f'
if [[ -n "$KITTY_WINDOW_ID" ]]; then
  # Truecolor hex styles for Kitty
  ZSH_HIGHLIGHT_STYLES[command]='fg=#a6e3a1'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#a6e3a1,bold'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6e3a1,italic, bold'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#6c7086'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#6c7086'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#89b4fa'
  ZSH_HIGHLIGHT_STYLES[string]='fg=#fab387'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f38ba8,bold'
  ZSH_HIGHLIGHT_STYLES[redirection]='fg=#f9e2af'
  ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#f9e2af'
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'
else
  # Fallback 256-color styles for other terminals
  ZSH_HIGHLIGHT_STYLES[command]='fg=114'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=244'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=244'
  ZSH_HIGHLIGHT_STYLES[path]='fg=111'
  ZSH_HIGHLIGHT_STYLES[string]='fg=214'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=203,bold'
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
fi

# Or for git info in prompt (no framework needed):
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '(%b)'
setopt prompt_subst
PROMPT='%F{blue}%n@%m%f %F{green}%~%f %F{yellow}${vcs_info_msg_0_}%f %# '

# =============================================
# ALIASES (Your Linux Admin Specials)
# =============================================
# Network/WiFi
alias wifi-ap='sudo ~/scripts/hotspot.sh start && echo "Hotspot: ap0 on 192.168.12.1"'
alias wifi-off='sudo ~/scripts/hotspot.sh stop'
alias wifi-status='ip -c addr show dev wlan0; ip -c addr show dev ap0 2>/dev/null || echo "ap0 not active"'
alias nm-status='nmcli -c no dev status'
alias netinfo='ip -c addr; echo "---"; ip -c route; echo "---"; nmcli con show --active'

# Daily Needs
alias stfu='sudo pacman -Syuq'
alias fucking='sudo -E env "PATH=$PATH" zsh -ic'
alias ll='lsd -la'
alias why='systemctl status'
alias fix='sudo systemctl restart'
alias nope='kill -9'
alias ls='lsd -a'
alias fuck='reboot'
alias :wq='exit'

# System
alias sys='sudo systemctl'
alias journal='sudo journalctl -xe'
alias pac='sudo pacman'
alias yay='yay --sudoloop'
alias update='sudo pacman -Syu'

# Quick editing
alias zshrc='nvim ~/.zshrc'
alias sz='source ~/.zshrc'
alias vim='nvim'

# Docker/Containers
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dka='docker kill $(docker ps -q)'
alias dcu='docker-compose up'
alias dcd='docker-compose down'

# Quality of life
alias l='lsd'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -c'
alias cat='bat --paging=never --theme=TwoDark' # Better cat
alias tf='terraform'
alias k='kubectl'
alias mkdir='mkdir -p'
alias rm='rm -I' # Safety first

# Hardware/Network debugging
alias lsmodg='lsmod | grep -i'
alias dmesgw='sudo dmesg -w'
alias iwscan='sudo iw dev wlan0 scan | grep -E "SSID|signal|freq"'
alias ports='sudo ss -tulpn'

# =============================================
# FUNCTIONS (Your custom tools)
# =============================================
# Quick hotspot status
function wifimode() {
    if iw dev ap0 info >/dev/null 2>&1; then
        echo "📡 AP Mode: ap0 active"
        ip -c addr show dev ap0
    else
        echo "📶 Client Mode: wlan0"
        iw dev wlan0 link
    fi
}

# Quick QR code for hotspot
function wifi-qr() {
    echo "WIFI:S:MyHotspot;T:WPA;P:12345678;;" | qrencode -t UTF8
}

# Find what's using a port
function port-user() {
    sudo lsof -i :$1
}

# Git shortcut
function gacp() {
    git add .
    git commit -m "$1"
    git push
}

# Quick script template
function mkscript() {
    cat > $1 << 'EOF'
#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Usage: $0 [options]
# Description:

main() {
    # Your code here
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
EOF
    chmod +x $1
    $EDITOR $1
}

# =============================================
# ENVIRONMENT
# =============================================
export EDITOR=nano
export VISUAL=nano
export PAGER=less
export LESS='-R'

# If you code
export PATH="$HOME/.local/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# For Rust
export PATH="$HOME/.cargo/bin:$PATH"

# For Python virtualenvs
export WORKON_HOME=~/.virtualenvs

# Color for man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# GTK is a dick
export GTK_THEME=Adwaita-dark  # or your preferred dark theme
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"


# =============================================
# KEY BINDINGS
# =============================================
bindkey '^R' history-incremental-search-backward
bindkey '^U' backward-kill-line

bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
# =============================================
# MISC SETTINGS
# =============================================
setopt autocd
setopt correct
setopt extendedglob
setopt notify
unsetopt beep

# Auto-ls after cd
function chpwd() {
    emulate -L zsh
    ls
}




# =============================================
# WELCOME MESSAGE - in .zprofile
# =============================================

