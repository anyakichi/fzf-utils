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

_fzf-file()
{
    setopt localoptions pipefail
    local base dir raw_dir

    eval "dir=$1"
    if [[ -d "$dir" ]]; then
        base=
        raw_dir="$1"
    else
        base=$(basename "$dir")
        dir=$(dirname "$dir")
        raw_dir=${1%"${(q)base}"}
    fi

    if [[ -n "$raw_dir" ]]; then
        raw_dir="${raw_dir%%/##}/"
    fi

    shift

    (
        local count=0

        cd "${dir:-.}" &&
        fzf-file run -0 --print-query --expect=ctrl-l,ctrl-o,ctrl-q \
            -q "$base" --prompt "${(Q)raw_dir}> " -- "$@" \
            | while read -r line; do
                if (( count < 2 )); then
                    echo "$line"
                else
                    echo "${raw_dir}${(q)line}"
                fi
                (( count++ ))
            done
    )
}

_fzf-history()
{
    setopt localoptions pipefail

    fc -rln 1 \
        | fzf -q "$1" --no-multi -0 --print-query \
            --expect=ctrl-o,ctrl-q,ctrl-y \
            --tiebreak=index \
            --preview "echo {}" \
            --preview-window bottom:3:wrap:hidden \
            --bind 'ctrl-s:toggle-sort' \
            --bind 'ctrl-r:down'
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

fzf-file-widget()
{
    setopt localoptions extended_glob pipefail
    local args key res ret

    while true; do
        args=("${(z)LBUFFER}")
        if [[ ${LBUFFER} =~ [^\\][[:space:]]$ ]]; then
            args+=("")
        fi

        if [[ ${args[1]} == cd ]]; then
            res=("${(@f)"$(_fzf-file "${args[-1]}" d)"}")
        else
            res=("${(@f)"$(_fzf-file "${args[-1]}")"}")
        fi
        ret=$?

        if [[ ${#res} -ge 3 && ${res[2]} != "ctrl-q" ]]; then
            key="${res[2]}"
            shift 2 res

            [[ ${args[-1]} ]] && LBUFFER="${LBUFFER%%${args[-1]}**}"
            LBUFFER+="${res[*]} "
        elif [[ ${#res} -ge 2 ]]; then
            [[ ${args[-1]} ]] && LBUFFER="${LBUFFER%%${args[-1]}**}"
            LBUFFER+=${res[1]}
        fi

        zle reset-prompt

        if [[ "${key}" == "ctrl-l" ]]; then
            LBUFFER="${LBUFFER%%?}"
            key=
            continue
        elif [[ "${key}" == "ctrl-o" ]]; then
            zle accept-line
        fi
        break
    done

    return ${ret}
}
zle -N fzf-file-widget

fzf-history-widget()
{
    setopt localoptions pipefail
    local key res ret

    res=("${(@f)"$(_fzf-history "${LBUFFER}")"}")
    ret=$?

    if [[ ${#res} -ge 3 && ${res[2]} != "ctrl-q" ]]; then
        key="${res[2]}"
        BUFFER="${res[3]}"
        CURSOR=$#BUFFER
    elif [[ ${#res} -ge 2 ]]; then
        key="${res[2]}"
        BUFFER="${res[1]}"
        CURSOR=$#BUFFER
    fi

    zle reset-prompt

    if [[ -z "${key}" ]]; then
        zle accept-line
    fi

    return ${ret}
}
zle -N fzf-history-widget

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
