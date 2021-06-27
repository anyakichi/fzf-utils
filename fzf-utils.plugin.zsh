# shellcheck shell=bash

fzf-utils::_cdr()
{
    cdr -l | sed 's/^[[:digit:]]*[[:space:]]*//' \
        | fzf --no-multi \
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

fzf-utils::_file()
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

fzf-utils::_history()
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

fzf-utils::cdr-widget()
{
    setopt localoptions pipefail
    local dir

    dir=$(fzf-utils::_cdr)
    local ret=$?
    if [ -n "${dir}" ]; then
        BUFFER="cd ${dir}"
        zle reset-prompt
        zle accept-line
    else
        zle reset-prompt
    fi
    return $ret
}
zle -N fzf-utils::cdr-widget

fzf-utils::cdr-or-file-widget()
{
    if [[ -n "${BUFFER}" ]]; then
        fzf-utils::file-widget
    else
        fzf-utils::cdr-widget
    fi
}
zle -N fzf-utils::cdr-or-file-widget

fzf-utils::file-widget()
{
    setopt localoptions extended_glob pipefail
    local args key res ret

    while true; do
        args=("${(z)LBUFFER}")
        if [[ ${LBUFFER} =~ [^\\][[:space:]]$ ]]; then
            args+=("")
        fi

        if [[ ${args[1]} == cd ]]; then
            res=("${(@f)"$(fzf-utils::_file "${args[-1]}" d)"}")
        else
            res=("${(@f)"$(fzf-utils::_file "${args[-1]}")"}")
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
zle -N fzf-utils::file-widget

fzf-utils::history-widget()
{
    setopt localoptions pipefail
    local key res ret

    res=("${(@f)"$(fzf-utils::_history "${LBUFFER}")"}")
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
zle -N fzf-utils::history-widget

fzf-utils::tmux-pane-widget() {
    local result
    result=$(fzf-tmux-pane run --border)
    zle reset-prompt
    tmux switch-client -t "${result}"
}
zle -N fzf-utils::tmux-pane-widget

fzf-utils::join-lines() {
    local item
    while read -r item; do
        printf '%q ' "$item"
    done
}

fzf-utils::create-widget() {
    local x
    for x in "$@"; do
        eval "fzf-utils::$x-widget() { local result=\$(fzf-utils::_$x | fzf-utils::join-lines); zle reset-prompt; LBUFFER+=\$result }"
        eval "zle -N fzf-utils::$x-widget"
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
    bindkey '^g^b' fzf-utils::git-branch-widget
    bindkey '^gb' fzf-utils::git-branch-widget

    bindkey '^g^c' fzf-utils::docker-container-widget
    bindkey '^gc' fzf-utils::docker-container-widget

    bindkey '^g^f' fzf-utils::git-file-widget
    bindkey '^gf' fzf-utils::git-file-widget

    bindkey '^g^g' fzf-utils::rg-widget
    bindkey '^gg' fzf-utils::rg-widget

    bindkey '^g^h' fzf-utils::git-hash-widget
    bindkey '^gh' fzf-utils::git-hash-widget

    bindkey '^g^i' fzf-utils::docker-image-widget
    bindkey '^gi' fzf-utils::docker-image-widget

    bindkey '^g^p' fzf-utils::ps-widget
    bindkey '^gp' fzf-utils::ps-widget

    bindkey '^g^r' fzf-utils::git-remote-widget
    bindkey '^gr' fzf-utils::git-remote-widget

    bindkey '^g^s' fzf-utils::git-stash-widget
    bindkey '^gs' fzf-utils::git-stash-widget

    bindkey '^g^t' fzf-utils::git-tag-widget
    bindkey '^gt' fzf-utils::git-tag-widget

    bindkey '^g^v' fzf-utils::docker-volume-widget
    bindkey '^gv' fzf-utils::docker-volume-widget

    bindkey '^s' fzf-utils::tmux-pane-widget
fi

PATH=$PATH:$(cd "$(dirname "$0")" && pwd)/bin
