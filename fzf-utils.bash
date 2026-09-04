# shellcheck shell=bash

# fzf-utils bash implementation
# Note: This provides basic functionality. Some features may be limited compared to zsh version.

# File browser widget implementation
fzf-utils::_file() {
    local selected
    selected=$(fzf-file run -- "$@" 2>/dev/null)
    echo "$selected"
}

# History widget implementation for bash
fzf-utils::_history() {
    local selected
    # Bash history format is different from zsh
    history |
        fzf --tac --no-sort --reverse \
            -q "$1" --with-nth 2.. --no-multi \
            --preview "echo {}" \
            --preview-window bottom:3:wrap:hidden \
            --bind 'ctrl-s:toggle-sort' |
        awk '{$1=""; print substr($0,2)}'
}

# Docker container widget
fzf-utils::_docker-container() {
    fzf-docker container "$@"
}

# Docker image widget
fzf-utils::_docker-image() {
    fzf-docker image "$@"
}

# Docker volume widget
fzf-utils::_docker-volume() {
    fzf-docker volume "$@"
}

# Git branch widget
fzf-utils::_git-branch() {
    fzf-git branch "$@"
}

# Git file widget
fzf-utils::_git-file() {
    fzf-git file "$@"
}

# Git hash widget
fzf-utils::_git-hash() {
    fzf-git hash "$@"
}

# Git remote widget
fzf-utils::_git-remote() {
    fzf-git remote "$@"
}

# Git stash widget
fzf-utils::_git-stash() {
    fzf-git stash "$@"
}

# Git tag widget
fzf-utils::_git-tag() {
    fzf-git tag "$@"
}

# GitLab issue widget
fzf-utils::_glab-issue() {
    fzf-glab issue run "$@"
}

# GitLab merge request widget
fzf-utils::_glab-mr() {
    fzf-glab mr run "$@"
}

# Process selection widget
fzf-utils::_ps() {
    fzf-ps run "$@"
}

# Ripgrep widget
fzf-utils::_rg() {
    fzf-grep run "$@"
}

# File widget - inserts selected files to command line
fzf-utils::file-widget() {
    local selected
    selected=$(fzf-utils::_file "$@")
    READLINE_LINE="${READLINE_LINE:0:READLINE_POINT}$selected${READLINE_LINE:READLINE_POINT}"
    READLINE_POINT=$((READLINE_POINT + ${#selected}))
}

# History widget - replaces command line with selected history entry
fzf-utils::history-widget() {
    local selected
    selected=$(fzf-utils::_history "$READLINE_LINE")
    if [[ -n $selected ]]; then
        READLINE_LINE="$selected"
        READLINE_POINT=${#selected}
    fi
}

# Tmux pane widget
fzf-utils::tmux-pane-widget() {
    if [[ -z $TMUX ]]; then
        echo "Not in a tmux session" >&2
        return 1
    fi
    local result
    result=$(fzf-tmux-pane run --border 2>/dev/null)
    if [[ -n $result ]]; then
        tmux switch-client -t "$result"
    fi
}

# Join lines helper function
fzf-utils::join-lines() {
    local item
    while read -r item; do
        printf '%q ' "$item"
    done
}

# Generic widget handler
fzf-utils::do-widget() {
    local func="fzf-utils::_$1"
    shift

    # Check if function exists
    if ! declare -f "$func" >/dev/null; then
        echo "Function $func not found" >&2
        return 1
    fi

    local result
    result=$("$func" "$@" | fzf-utils::join-lines)
    if [[ -n $result ]]; then
        READLINE_LINE="${READLINE_LINE:0:READLINE_POINT}$result${READLINE_LINE:READLINE_POINT}"
        READLINE_POINT=$((READLINE_POINT + ${#result}))
    fi
}

# Create widget functions dynamically
fzf-utils::create-widget() {
    local x
    for x in "$@"; do
        eval "function fzf-utils::$x-widget() { fzf-utils::do-widget '$x' \"\$@\"; }"
    done
}

# Create all widgets
fzf-utils::create-widget \
    docker-container \
    docker-image \
    docker-volume \
    git-branch \
    git-file \
    git-hash \
    git-remote \
    git-stash \
    git-tag \
    glab-issue \
    glab-mr \
    ps \
    rg
unset -f fzf-utils::create-widget

# Set up key bindings if not disabled
if [[ -z $FZF_UTILS_NO_MAPPINGS ]]; then
    # File/directory browser
    bind -m emacs-standard -x '"\C-/": fzf-utils::file-widget'
    bind -m vi-command -x '"\C-/": fzf-utils::file-widget'
    bind -m vi-insert -x '"\C-/": fzf-utils::file-widget'

    # History search
    bind -m emacs-standard -x '"\C-r": fzf-utils::history-widget'
    bind -m vi-command -x '"\C-r": fzf-utils::history-widget'
    bind -m vi-insert -x '"\C-r": fzf-utils::history-widget'

    # Git operations
    bind -m emacs-standard -x '"\C-g\C-b": fzf-utils::git-branch-widget'
    bind -m emacs-standard -x '"\C-gb": fzf-utils::git-branch-widget'

    bind -m emacs-standard -x '"\C-g\C-f": fzf-utils::git-file-widget'
    bind -m emacs-standard -x '"\C-gf": fzf-utils::git-file-widget'

    bind -m emacs-standard -x '"\C-g\C-h": fzf-utils::git-hash-widget'
    bind -m emacs-standard -x '"\C-gh": fzf-utils::git-hash-widget'

    bind -m emacs-standard -x '"\C-g\C-r": fzf-utils::git-remote-widget'
    bind -m emacs-standard -x '"\C-gr": fzf-utils::git-remote-widget'

    bind -m emacs-standard -x '"\C-g\C-s": fzf-utils::git-stash-widget'
    bind -m emacs-standard -x '"\C-gs": fzf-utils::git-stash-widget'

    bind -m emacs-standard -x '"\C-g\C-t": fzf-utils::git-tag-widget'
    bind -m emacs-standard -x '"\C-gt": fzf-utils::git-tag-widget'

    # Docker operations
    bind -m emacs-standard -x '"\C-g\C-c": fzf-utils::docker-container-widget'
    bind -m emacs-standard -x '"\C-gc": fzf-utils::docker-container-widget'

    bind -m emacs-standard -x '"\C-g\C-i": fzf-utils::docker-image-widget'
    bind -m emacs-standard -x '"\C-gi": fzf-utils::docker-image-widget'

    bind -m emacs-standard -x '"\C-g\C-v": fzf-utils::docker-volume-widget'
    bind -m emacs-standard -x '"\C-gv": fzf-utils::docker-volume-widget'

    # Other utilities
    bind -m emacs-standard -x '"\C-g\C-p": fzf-utils::ps-widget'
    bind -m emacs-standard -x '"\C-gp": fzf-utils::ps-widget'

    bind -m emacs-standard -x '"\C-g\C-g": fzf-utils::rg-widget'
    bind -m emacs-standard -x '"\C-gg": fzf-utils::rg-widget'

    # Tmux pane selection
    bind -m emacs-standard -x '"\C-s": fzf-utils::tmux-pane-widget'
fi

# Add bin directory to PATH
_fzf_utils_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
export PATH=$PATH:$_fzf_utils_dir/bin
unset _fzf_utils_dir
