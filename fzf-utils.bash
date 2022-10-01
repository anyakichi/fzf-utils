# shellcheck shell=bash

fzf-utils::_cdr() {
    cdr -l | sed 's/^[[:digit:]]*[[:space:]]*//' |
        fzf --no-multi \
            --bind 'ctrl-r:reload:zsh -c "source ~/.zsh/cdr.zsh; cdr -l | sed \"s/^[[:digit:]]*[[:space:]]*//\""'
}

fzf-utils::_docker-container() {
    fzf-docker container "$@"
}

fzf-utils::_docker-image() {
    fzf-docker image "$@"
}

fzf-utils::_docker-volume() {
    fzf-docker volume "$@"
}

fzf-utils::_file() {
    echo not implemented
}

fzf-utils::_history() {
    setopt localoptions pipefail

    fc -rl 1 |
        fzf -q "$1" --with-nth 2.. --no-multi -0 --print-query \
            --expect=ctrl-o,ctrl-q,ctrl-y \
            --tiebreak=index \
            --preview "echo {}" \
            --preview-window bottom:3:wrap:hidden \
            --bind 'ctrl-s:toggle-sort' \
            --bind 'ctrl-r:down'
}

fzf-utils::_git-branch() {
    fzf-git branch "$@"
}

fzf-utils::_git-file() {
    fzf-git file "$@"
}

fzf-utils::_git-hash() {
    fzf-git hash "$@"
}

fzf-utils::_git-remote() {
    fzf-git remote "$@"
}

fzf-utils::_git-stash() {
    fzf-git stash "$@"
}

fzf-utils::_git-tag() {
    fzf-git tag "$@"
}

fzf-utils::_glab-issue() {
    fzf-glab issue run
}

fzf-utils::_glab-mr() {
    fzf-glab mr run
}

fzf-utils::_ps() {
    fzf-ps run
}

fzf-utils::_rg() {
    fzf-grep run "$@"
}

fzf-utils::cdr-widget() {
    echo not implemented
}

fzf-utils::cdr-or-file-widget() {
    echo not implemented
}

fzf-utils::file-widget() {
    echo not implemented
}

fzf-utils::history-widget() {
    echo not implemented

}

fzf-utils::tmux-pane-widget() {
    local result
    result=$(fzf-tmux-pane run --border)
    tmux switch-client -t "${result}"
}

fzf-utils::join-lines() {
    local item
    while read -r item; do
        printf '%q ' "$item"
    done
}

fzf-utils::do-widget() {
    local func="fzf-utils::_$1"
    shift

    local result
    result=$($func "$@" | fzf-utils::join-lines)
    READLINE_LINE="${READLINE_LINE:0:READLINE_POINT}$result${READLINE_LINE:READLINE_POINT}"
    READLINE_POINT=$((READLINE_POINT + ${#result}))
}

fzf-utils::create-widget() {
    local x
    for x in "$@"; do
        eval "function fzf-utils::$x-widget() { fzf-utils::do-widget '$x' \"\$@\"; }"
    done
}
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

if [[ -z $FZF_UTILS_NO_MAPPINGS ]]; then
    bind -m emacs-standard -x '"\C-g\C-b": fzf-utils::git-branch-widget'
    bind -m emacs-standard -x '"\C-gb": fzf-utils::git-branch-widget'

    bind -m emacs-standard -x '"\C-g\C-c": fzf-utils::docker-container-widget'
    bind -m emacs-standard -x '"\C-gc": fzf-utils::docker-container-widget'

    bind -m emacs-standard -x '"\C-g\C-f": fzf-utils::git-file-widget'
    bind -m emacs-standard -x '"\C-gf": fzf-utils::git-file-widget'

    bind -m emacs-standard -x '"\C-g\C-r": fzf-utils::rg-widget'
    bind -m emacs-standard -x '"\C-gr": fzf-utils::rg-widget'

    bind -m emacs-standard -x '"\C-g\C-h": fzf-utils::git-hash-widget'
    bind -m emacs-standard -x '"\C-gh": fzf-utils::git-hash-widget'

    bind -m emacs-standard -x '"\C-g\C-i": fzf-utils::docker-image-widget'
    bind -m emacs-standard -x '"\C-gi": fzf-utils::docker-image-widget'

    bind -m emacs-standard -x '"\C-g\C-p": fzf-utils::ps-widget'
    bind -m emacs-standard -x '"\C-gp": fzf-utils::ps-widget'

    bind -m emacs-standard -x '"\C-g\C-r": fzf-utils::git-remote-widget'
    bind -m emacs-standard -x '"\C-gr": fzf-utils::git-remote-widget'

    bind -m emacs-standard -x '"\C-g\C-s": fzf-utils::git-stash-widget'
    bind -m emacs-standard -x '"\C-gs": fzf-utils::git-stash-widget'

    bind -m emacs-standard -x '"\C-g\C-t": fzf-utils::git-tag-widget'
    bind -m emacs-standard -x '"\C-gt": fzf-utils::git-tag-widget'

    bind -m emacs-standard -x '"\C-g\C-v": fzf-utils::docker-volume-widget'
    bind -m emacs-standard -x '"\C-gv": fzf-utils::docker-volume-widget'

    #bind -m emacs-standard -x '"\C-_": fzf-utils::cdr-or-file-widget'
    #bind -m emacs-standard -x '"\C-r": fzf-utils::history-widget'
    bind -m emacs-standard -x '"\C-s": fzf-utils::tmux-pane-widget'
fi

PATH=$PATH:$(cd "$(dirname "$0")" && pwd)/bin
