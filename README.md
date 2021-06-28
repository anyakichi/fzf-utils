# fzf-utils

fzf utilities for zsh.

It can be used for bash but an initialization script for bash does not
exist for now.

## Installation

You can add the plugin by plugin managers.  If you use zinit, add `zinit
light anyakichi/fzf-utils` to your `.zshrc`.

## Helper commands

These helper commands are added to your PATH.

| Command       | Description                              |
| ------------- | ---------------------------------------- |
| \_fzf-state   | Share state between fzf sessions         |
| fzf-docker    | fzf for docker command                   |
| fzf-file      | fzf for files (with find or fd)          |
| fzf-git       | fzf for git command                      |
| fzf-glab      | fzf for glab commnad                     |
| fzf-ps        | fzf for ps command                       |
| fzf-tmux-pane | fzf for tmux-pane                        |
| tview         | Open an application in a new tmux window |

## Widgets

fzf-utils provides these widgets.

| Widget                             | Action                      |
| ---------------------------------- | --------------------------- |
| fzf-utils::cdr-or-file-widget      | fzf for cd history or files |
| fzf-utils::cdr-widget              | fzf for cd history          |
| fzf-utils::docker-container-widget | fzf for docker containers   |
| fzf-utils::docker-image-widget     | fzf for docker images       |
| fzf-utils::docker-volume-widget    | fzf for docker volumes      |
| fzf-utils::git-branch-widget       | fzf for git branches        |
| fzf-utils::git-file-widget         | fzf for git files           |
| fzf-utils::git-hash-widget         | fzf for git hashes (logs)   |
| fzf-utils::git-remote-widget       | fzf for git remotes         |
| fzf-utils::git-stash-widget        | fzf for git stashes         |
| fzf-utils::git-tag-widget          | fzf for git tags            |
| fzf-utils::glab-issue-widget       | fzf for gitlab issues       |
| fzf-utils::glab-mr-widget          | fzf for gitlab mrs          |
| fzf-utils::history-widget          | fzf for shell history       |
| fzf-utils::ps-widget               | fzf with ps                 |
| fzf-utils::rg-widget               | fzf with rg                 |
| fzf-utils::tmux-pane-widget        | fzf for tmux panes          |

## Key bindings

These key bindings are defined by default.

| Key                 | Widget                             |
| ------------------- | ---------------------------------- |
| Ctrl-/              | fzf-utils::cdr-or-file-widget      |
| Ctrl-g - Ctrl-b / b | fzf-utils::git-branch-widget       |
| Ctrl-g - Ctrl-c / c | fzf-utils::docker-container-widget |
| Ctrl-g - Ctrl-f / f | fzf-utils::git-file-widget         |
| Ctrl-g - Ctrl-g / g | fzf-utils::rg-widget               |
| Ctrl-g - Ctrl-h / h | fzf-utils::git-hash-widget         |
| Ctrl-g - Ctrl-i / i | fzf-utils::docker-container-widget |
| Ctrl-g - Ctrl-p / p | fzf-utils::ps-widget               |
| Ctrl-g - Ctrl-r / r | fzf-utils::git-remote-widget       |
| Ctrl-g - Ctrl-s / s | fzf-utils::git-stash-widget        |
| Ctrl-g - Ctrl-t / t | fzf-utils::git-tag-widget          |
| Ctrl-g - Ctrl-v / v | fzf-utils::docker-volume-widget    |
| Ctrl-r              | fzf-utils::history-widget          |
| Ctrl-s              | fzf-utils::tmux-pane-widget        |

If you dislike this default, set FZF_UTILS_NO_MAPPINGS before loading
fzf-utils to stop setting default values.
