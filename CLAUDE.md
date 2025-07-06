# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

fzf-utils is a collection of zsh utilities that integrate with fzf (fuzzy finder) to enhance command-line productivity. The project provides widgets and helper commands for file browsing, git operations, docker management, and more.

## Architecture

### Core Structure
- `fzf-utils.plugin.zsh`: Main plugin file defining zsh widgets and key bindings
- `bin/`: Helper commands that implement the actual functionality
  - `_fzf-common`: Shared utility functions for all commands
  - `_fzf-state`: State management between invocations
  - Each command follows the pattern: `fzf-<tool> <subcommand> [options]`
- `fzf-utils.bash`: Partial bash implementation (incomplete)

### Key Design Patterns
1. **State Management**: Uses `_fzf-state` to persist selections and options across fzf sessions
2. **Interactive Controls**: Consistent keybindings across commands (Ctrl-r for reload/toggle, Ctrl-t for tmux, etc.)
3. **Preview Integration**: Most commands include preview functionality using bat/less
4. **Fallback Mechanisms**: Gracefully degrades when optional tools aren't available (fd→find, bat→less)

## Development Commands

Since this is a shell utility collection, there are no traditional build/test commands. However, when developing:

1. **Testing changes**: Source the plugin in your shell
   ```bash
   source fzf-utils.plugin.zsh
   ```

2. **Checking shell syntax**: Use shellcheck on modified scripts
   ```bash
   shellcheck bin/fzf-*
   ```

3. **Manual testing**: Test individual commands directly
   ```bash
   bin/fzf-file
   bin/fzf-git branch
   ```

## Important Implementation Notes

1. **Common utilities**: Use functions from `_fzf-common` instead of duplicating code:
   - `parse_fzf_args`: Parse command line arguments
   - `toggle_boolean`: Toggle state variables
   - `cycle_value`: Cycle through multiple values
   - `setup_pager`: Configure less/pager environment
   - `view_file`: Display files with bat/less fallback
   - `has_command`: Check command availability

2. **Zsh-specific features**: The project heavily uses zsh-specific features like associative arrays and widget system. The bash implementation is incomplete.

3. **State file handling**: When modifying commands that use `_fzf-state`, ensure proper cleanup of temporary files and correct state serialization/deserialization.

4. **Consistent keybindings**: When adding new interactive features, follow the established keybinding patterns:
   - Ctrl-r: Reload or toggle primary option
   - Ctrl-t: Open in tmux window
   - Ctrl-s: Secondary toggle or navigation
   - Ctrl-x: Cycle through modes

5. **Environment preservation**: The `tview` command preserves specific environment variables when opening tmux windows. See `TVIEW_ENV_VARS` in bin/tview.

6. **Git integration**: Supports both regular git repositories and yadm. Uses `$FZF_GIT_DEFAULT_DIR` as fallback when not in a repository.

## Dependencies to Consider

When adding features, check for these optional dependencies:
- fd (preferred over find for file operations)
- bat (for syntax highlighting in previews)
- ripgrep (for grep functionality)
- exa (for enhanced directory listings)
- tmux (for pane/window features)