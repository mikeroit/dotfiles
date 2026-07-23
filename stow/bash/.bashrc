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
