# fzf-utils

fzf utilities for zsh and bash.

## Installation

### Zsh

You can add the plugin by plugin managers. If you use zinit, add `zinit
light anyakichi/fzf-utils` to your `.zshrc`.

### Bash (Partial Support)

Source the bash script in your `.bashrc`:

```bash
source /path/to/fzf-utils/fzf-utils.bash
```

Note: The bash implementation provides basic functionality. Some features may be limited compared to the zsh version.

## Helper commands

These helper commands are added to your PATH.

| Command       | Description                              |
| ------------- | ---------------------------------------- |
| fzf-docker    | fzf for docker command                   |
| fzf-file      | fzf for files (with find or fd)          |
| fzf-git       | fzf for git command                      |
| fzf-glab      | fzf for glab command                     |
| fzf-grep      | fzf with ripgrep/grep                    |
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
| fzf-utils::file-widget             | fzf for files               |
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

| Key                       | Widget                             |
| ------------------------- | ---------------------------------- |
| Ctrl-/                    | fzf-utils::cdr-or-file-widget      |
| Ctrl-g Ctrl-b / Ctrl-g b  | fzf-utils::git-branch-widget       |
| Ctrl-g Ctrl-c / Ctrl-g c  | fzf-utils::docker-container-widget |
| Ctrl-g Ctrl-f / Ctrl-g f  | fzf-utils::git-file-widget         |
| Ctrl-g Ctrl-g / Ctrl-g g  | fzf-utils::rg-widget               |
| Ctrl-g Ctrl-h / Ctrl-g h  | fzf-utils::git-hash-widget         |
| Ctrl-g Ctrl-i / Ctrl-g i  | fzf-utils::docker-image-widget     |
| Ctrl-g Ctrl-p / Ctrl-g p  | fzf-utils::ps-widget               |
| Ctrl-g Ctrl-r / Ctrl-g r  | fzf-utils::git-remote-widget       |
| Ctrl-g Ctrl-s / Ctrl-g s  | fzf-utils::git-stash-widget        |
| Ctrl-g Ctrl-t / Ctrl-g t  | fzf-utils::git-tag-widget          |
| Ctrl-g Ctrl-v / Ctrl-g v  | fzf-utils::docker-volume-widget    |
| Ctrl-r                    | fzf-utils::history-widget          |
| Ctrl-s                    | fzf-utils::tmux-pane-widget        |

If you dislike this default, set FZF_UTILS_NO_MAPPINGS before loading
fzf-utils to stop setting default values.

Ctrl-s is used for terminal flow control by default, so the tmux pane
widget only works after disabling it with `stty -ixon`.

## Configuration

### Environment Variables

- `FZF_UTILS_NO_MAPPINGS`: Set this to disable default key bindings
- `FZF_GIT_DEFAULT_DIR`: Default directory for git operations when not in a repository
- `FZF_GIT_OPTS`: Extra fzf options for `fzf-git` commands (default: `--height 50%`)

## Features

### Interactive Controls

Within fzf interfaces, these keys provide additional functionality:

- `Ctrl-r`: Reload data or toggle primary option
- `Ctrl-t`: Open selection in a new tmux window
- `Ctrl-s`: Secondary toggle or navigation
- `Ctrl-x`: Cycle through different modes

### Command Structure

Most commands support subcommands. For example:
- `fzf-git` supports: branch, file, hash, remote, stash, tag
- `fzf-docker` supports: container, image, volume

### State Management

The `_fzf-state` helper maintains state between fzf sessions, allowing persistent selections and options across invocations.

### Tool Fallbacks

Commands gracefully degrade when optional tools aren't available:
- `fd` → `find` for file operations
- `bat` → `less` for file previews
- `eza` → `exa` → `ls` for directory listings
