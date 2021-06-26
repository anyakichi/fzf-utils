# fzf-utils

fzf utilities for zsh.

It can be used for bash but an initialization script for bash does not
exist for now.

## Installation

You can add the plugin by plugin managers.  If you use zinit, add `zinit
light anyakichi/fzf-utils` to your `.zshrc`.

## Key bindings

These key bindings are defined by default.

| Key                 | Action                    |
| ------------------- | ------------------------- |
| Ctrl-g - Ctrl-b / b | fzf for git branches      |
| Ctrl-g - Ctrl-c / c | fzf for docker containers |
| Ctrl-g - Ctrl-f / f | fzf for git files         |
| Ctrl-g - Ctrl-g / g | fzf with rg               |
| Ctrl-g - Ctrl-h / h | fzf for git hashes (logs) |
| Ctrl-g - Ctrl-i / i | fzf for docker images     |
| Ctrl-g - Ctrl-p / p | fzf with ps               |
| Ctrl-g - Ctrl-r / r | fzf for git remotes       |
| Ctrl-g - Ctrl-s / s | fzf for git stashes       |
| Ctrl-g - Ctrl-t / t | fzf for git tags          |
| Ctrl-g - Ctrl-v / v | fzf for docker volumes    |

If you dislike this default, set FZF_UTILS_NO_MAPPINGS before loading
fzf-utils to stop setting default values.
