# ============================================================
# ZSH CONFIG — Taha's Dotfiles
# ============================================================
setopt interactivecomments
[[ -o interactive ]] && stty -ixon

# Only run fastfetch if not in VS Code terminal
if [[ -z "$VSCODE_PID" && -z "$VSCODE_IPC_HOOK_CLI" && "$TERM_PROGRAM" != "vscode" && -z "$FASTFETCH_LOADED" ]]; then
    export FASTFETCH_LOADED=1
    /usr/bin/fastfetch
fi


# Load zsh-autosuggestions if it exists
#if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
#    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
#    ZSH_AUTOSUGGEST_USE_ASYNC=1
#fi
# Optional: make the ghost text a bit more visible (default is dim)
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"


# Aliases
alias ..="cd .."
alias ...="cd ../.."


# ============================================================
# FZF Integration (Black Screen of Death Edition)
# ============================================================

# Theme switcher
function ts() {
    local theme=$(ls ~/dotfiles/themes | fzf \
        --prompt="🎨 Switch to: " \
        --height=10 \
        --border \
        --preview="cat ~/dotfiles/themes/{}/theme.conf 2>/dev/null" \
        --preview-window=up:1)
    if [ -n "$theme" ]; then
        theme switch "$theme"
    fi
}

# File finder (opens in nvim)
function ff() {
    local file=$(fd --type f --hidden --exclude .git | fzf \
        --prompt="📁 Find file: " \
        --height=40% \
        --border \
        --preview="bat --style=numbers --color=always {} 2>/dev/null || cat {}" \
        --preview-window=right:60%)
    if [ -n "$file" ]; then
        nvim "$file"
    fi
}

function fcd() {
    # If an argument is provided, use zoxide directly
    if [ -n "$1" ]; then
        z "$1"
        return
    fi

    # Get zoxide's database
    local zoxide_dirs=$(zoxide query -l 2>/dev/null)

    local dir
    if [ -n "$zoxide_dirs" ]; then
        # Use zoxide if it has entries
        dir=$(echo "$zoxide_dirs" | while read -r path; do
            local exclude=0
            while read -r pattern; do
                if [[ "$path" == *"$pattern"* ]]; then
                    exclude=1
                    break
                fi
            done < ~/.config/fzf/exclude-dirs.txt
            if [ $exclude -eq 0 ]; then
                echo "$path"
            fi
        done | fzf \
            --prompt="📂 Find directory: " \
            --height=40% \
            --border \
            --preview="ls -la {} 2>/dev/null | head -10" \
            --preview-window=right:40%)
    else
        # Fallback to fd if zoxide is empty
        local exclude_pattern=$(cat ~/.config/fzf/exclude-dirs.txt | sed 's/^/--exclude /' | tr '\n' ' ')
        dir=$(eval "fd --type d --hidden $exclude_pattern 2>/dev/null" | fzf \
            --prompt="📂 Find directory: " \
            --height=40% \
            --border \
            --preview="ls -la {} 2>/dev/null | head -10" \
            --preview-window=right:40%)
    fi

    if [ -n "$dir" ]; then
        cd "$dir"
    fi
}

# Git branch switcher
function gb() {
    local branch=$(git branch --format='%(refname:short)' | fzf \
        --prompt="🌿 Switch branch: " \
        --height=40% \
        --border)
    if [ -n "$branch" ]; then
        git checkout "$branch"
    fi
}

# Search and open file (like Telescope grep)
function fgrep() {
    local pattern="$1"
    if [ -z "$pattern" ]; then
        echo "Usage: fgrep <pattern>"
        return 1
    fi
    local file=$(grep -r --line-number "$pattern" . 2>/dev/null | fzf \
        --prompt="🔍 Search: " \
        --height=40% \
        --border \
        --delimiter=':' \
        --preview="bat --style=numbers --color=always {1} 2>/dev/null || cat {1}" \
        --preview-window=right:60%)
    if [ -n "$file" ]; then
        local filename=$(echo "$file" | cut -d':' -f1)
        local line=$(echo "$file" | cut -d':' -f2)
        nvim "$filename" +"$line"
    fi
}

# Command history
function fh() {
    local cmd=$(history | tail -100 | fzf \
        --prompt="⚡ Run command: " \
        --height=40% \
        --border)
    if [ -n "$cmd" ]; then
        eval "$(echo "$cmd" | sed 's/^[0-9 ]*//')"
    fi
}

# Kill process
function fk() {
    local pid=$(ps -ef | fzf \
        --prompt="💀 Kill process: " \
        --height=40% \
        --border \
        --preview="ps -p {2} -o pid,ppid,cmd" \
        --preview-window=right:60% | awk '{print $2}')
    if [ -n "$pid" ]; then
        kill -9 "$pid"
        echo "💀 Killed PID: $pid"
    fi
}

# Quick aliases
alias tg="theme switch green"
alias te="theme switch ember"
alias tl="theme list"
alias tc="theme current"

# Additional FZF Goodies
function ec() {
    local file=$(find ~/.config ~/dotfiles -type f \( \
        -name "*.toml" -o \
        -name "*.lua" -o \
        -name "*.css" -o \
        -name "*.conf" -o \
        -name "*.h" -o \
        -name "*.yaml" -o \
        -name "*.yml" -o \
        -name "*.json" -o \
        -name "*.ini" -o \
        -name "*.cfg" -o \
        -name "*.xml" -o \
        -name "*.sh" -o \
        -name "*.bash" -o \
        -name "*.zsh" \) 2>/dev/null | fzf \
        --prompt="⚙️ Edit config: " \
        --height=40% \
        --border \
        --preview="bat --style=numbers --color=always {} 2>/dev/null || cat {}" \
        --preview-window=right:60%)
    if [ -n "$file" ]; then
        nvim "$file"
    fi
}

# Find and open at specific line (interactive)
function ffl() {
    local file=$(fd --type f --hidden --exclude .git | fzf \
        --prompt="📁 Open at line: " \
        --height=40% \
        --border \
        --preview="bat --style=numbers --color=always {} 2>/dev/null || cat {}" \
        --preview-window=right:60%)
    if [ -n "$file" ]; then
        echo -n "Line number (or Enter to open): "
        read line
        if [[ "$line" =~ ^[0-9]+$ ]]; then
            nvim "$file" +"$line"
        else
            nvim "$file"
        fi
    fi
}

# Show all running processes with fzf
function fp() {
    local pid
    pid=$(ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu \
        | fzf --header="PID USER %CPU %MEM COMMAND" \
              --prompt="📊 " --height=40% --border \
              --preview="ps -p {1} -o pid,ppid,user,%cpu,%mem,lstart,cmd" \
              --preview-window=right:60% \
        | awk '{print $1}')
    [[ -n "$pid" ]] && echo "$pid"
}

# ============================================================
# FZF Help Menu
# ============================================================

function fzf-help() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  🎯 FZF Power User Commands                                 ║
║  Black Screen of Death Edition                              ║
╚══════════════════════════════════════════════════════════════╝

📂 NAVIGATION
───────────────────────────────────────────────────────────────
  c        Fuzzy find directories and cd into them
  fcd      Smart directory finder (excludes junk)
  docs     cd ~/Documents
  down     cd ~/Downloads
  proj     cd ~/Projects
  dot      cd ~/dotfiles
  cfg      cd ~/.config

📁 FILE FINDING
───────────────────────────────────────────────────────────────
  ff       Find and open file in nvim
  ffl      Find file and open at specific line
  fgrep    Search for pattern and open file at match

🌿 GIT
───────────────────────────────────────────────────────────────
  gb       Fuzzy find and switch git branches

⚡ COMMAND HISTORY
───────────────────────────────────────────────────────────────
  fh       Search and rerun command history

💀 SYSTEM
───────────────────────────────────────────────────────────────
  fk       Fuzzy find and kill processes
  fp       Show process info

🎨 THEME
───────────────────────────────────────────────────────────────
  ts       Fuzzy find and switch themes
  tg       Switch to green theme (alias)
  te       Switch to ember theme (alias)
  tl       List all themes
  tc       Show current theme

⚙️ CONFIG
───────────────────────────────────────────────────────────────
  ec       Fuzzy find and edit config files

🔄 RELOAD
───────────────────────────────────────────────────────────────
  reload-zsh    Reload zsh configuration

📖 HELP
───────────────────────────────────────────────────────────────
  fzf-help   Show this help menu

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  💡 TIP: Most commands use fuzzy finder. Start typing to
     filter results, use arrow keys to select, Enter to
     confirm, and Esc to cancel.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}

# Quick alias for help
alias help="fzf-help"
alias ls='eza --icons --group-directories-first'

export LOOM_ENV=sandbox
# export LOOM_LICENSE="LOOM--3D19194D-EB9A-4A80-9587-A20C517D5482"

# Go path
export PATH=$PATH:$HOME/go/bin

#default Terminal
export TERMINAL=alacritty
export TERMCMD=alacritty


export PATH="$PATH:~/go/bin:$HOME/.local/bin"
export PATH=/usr/local/bin:$PATH
export EDITOR=nvim
export VISUAL=nvim
export MANPAGER='nvim +Man!'
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
export PATH="$HOME/.local/bin:$PATH"
eval "$(zoxide init zsh)"

# Loom shortcuts — managed by 'loom init'
source /home/taha/.loom/shortcuts.zsh.sh
eval "$(starship init zsh)"

# zsh-syntax-highlighting (must be at the end)
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

