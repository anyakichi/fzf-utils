# shellcheck shell=bash

_fzf-docker-container() {
    fzf-docker container "$@"
}

_fzf-docker-image() {
    fzf-docker image "$@"
}

_fzf-docker-volume() {
    fzf-docker volume "$@"
}

_fzf-git-branch() {
    fzf-git branch "$@"
}

_fzf-git-file() {
    fzf-git file "$@"
}

_fzf-git-hash() {
    fzf-git hash "$@"
}

_fzf-git-remote() {
    fzf-git remote "$@"
}

_fzf-git-stash() {
    fzf-git stash "$@"
}

_fzf-git-tag() {
    fzf-git tag "$@"
}

_fzf-glab-issue() {
    fzf-glab issue run
}

_fzf-glab-mr() {
    fzf-glab mr run
}

_fzf-ps() {
    fzf-ps run
}

_fzf-rg() {
    local rg view
    view="bat --plain --color=always --pager='less -KMRc' \
            \$(cut -d ':' -f1 <<< {})"
    rg="rg --column --line-number --no-heading --color=always --smart-case "

    fzf -m --ansi --disabled \
        --bind "change:reload:$rg {q} || true" \
        --bind "ctrl-t:execute:tview $view" \
        --preview "$view | head -500" \
        --preview-window hidden |
        command cut -d ':' -f1
}

fzf-tmux-pane-widget() {
    local result
    result=$(fzf-tmux-pane run --border)
    zle reset-prompt
    tmux switch-client -t "${result}"
}
zle -N fzf-tmux-pane-widget

_fzf-join-lines() {
    local item
    while read -r item; do
        printf '%q ' "$item"
    done
}

create-widget() {
    local x
    for x in "$@"; do
        eval "$x-widget() { local result=\$(_$x | _fzf-join-lines); zle reset-prompt; LBUFFER+=\$result }"
        eval "zle -N $x-widget"
    done
}
create-widget \
    fzf-docker-container \
    fzf-docker-image \
    fzf-docker-volume \
    fzf-git-branch \
    fzf-git-file \
    fzf-git-hash \
    fzf-git-remote \
    fzf-git-stash \
    fzf-git-tag \
    fzf-glab-issue \
    fzf-glab-mr \
    fzf-ps \
    fzf-rg
unset -f create-widget

if [[ -z $FZF_UTILS_NO_MAPPINGS ]]; then
    bindkey '^g^b' fzf-git-branch-widget
    bindkey '^gb' fzf-git-branch-widget

    bindkey '^g^c' fzf-docker-container-widget
    bindkey '^gc' fzf-docker-container-widget

    bindkey '^g^f' fzf-git-file-widget
    bindkey '^gf' fzf-git-file-widget

    bindkey '^g^g' fzf-rg-widget
    bindkey '^gg' fzf-rg-widget

    bindkey '^g^h' fzf-git-hash-widget
    bindkey '^gh' fzf-git-hash-widget

    bindkey '^g^i' fzf-docker-image-widget
    bindkey '^gi' fzf-docker-image-widget

    bindkey '^g^p' fzf-ps-widget
    bindkey '^gp' fzf-ps-widget

    bindkey '^g^r' fzf-git-remote-widget
    bindkey '^gr' fzf-git-remote-widget

    bindkey '^g^s' fzf-git-stash-widget
    bindkey '^gs' fzf-git-stash-widget

    bindkey '^g^t' fzf-git-tag-widget
    bindkey '^gt' fzf-git-tag-widget

    bindkey '^g^v' fzf-docker-volume-widget
    bindkey '^gv' fzf-docker-volume-widget

    bindkey '^s' fzf-tmux-pane-widget
fi

PATH=$PATH:$(cd "$(dirname "$0")" && pwd)/bin
