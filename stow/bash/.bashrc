# ~/.bashrc — Arch-native config
# Rebuilt from scratch to replace an unmodified Debian/Ubuntu skeleton.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Git-aware prompt
# Shows the current branch in the prompt, with a trailing '*' if there are
# modified or staged changes. Untracked files are ignored on purpose —
# stray build artifacts or scratch files shouldn't flag the prompt as dirty.
# Prints nothing outside a git repo, so the prompt stays clean elsewhere.
__git_prompt_info() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
    if [[ -n "$(git status --porcelain --untracked-files=no 2>/dev/null)" ]]; then
        printf ' (%s*)' "$branch"
    else
        printf ' (%s)' "$branch"
    fi
}

PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;33m\]$(__git_prompt_info)\[\033[00m\]\$ '

# vim is not installed as a separate package — nvim is the only editor
# in use here. This alias exists so muscle-memory `vim` still lands you
# in the real config instead of silently falling through to whatever
# stock vim happens to be on the system.
alias vim="nvim"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'



# --- Color support: ls family + grep ---
# Uses standard ANSI SGR codes only (no hardcoded hex), so these follow
# whichever kitty theme (soft/contrast) is currently active automatically —
# no separate per-theme color files needed here, unlike kitty/waybar/rofi/nvim.

# GNU ls's built-in default LS_COLORS is already theme-aware in this sense,
# so we don't need to hand-roll one — just turn coloring on.
alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'

# git aliases
alias gl="git log"
alias gs="git status"
alias gap="git add ."
alias gp="git push"
gcm() {
    git commit -m "$*"
}

# grep family — same reasoning, no custom GREP_COLORS needed unless you
# want to tune match-highlight color/weight later.
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# personal or proj-specific aliases to navigate or open
alias dot='cd ~/.dotfiles'
alias vb='vim ~/.dotfiles/stow/bash/.bashrc'
alias snt='cd ~/workspace/SwarmNet'
alias pck='cd ~/workspace/SwarmNet/packages/simulation/src/'
alias loginwpdir='/usr/share/sddm/themes/catppuccin/backgrounds/'

# alias to show power use in watts
alias watts='upower -i $(upower -e | grep BAT) | grep energy-rate'

#SwarmNet aliases
alias simrun='cargo run -p simulation-runtime'
alias ctest='cargo test'
