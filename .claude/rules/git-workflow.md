# Git Workflow Convention

## Commit Message Format

```
<type>(<scope>): <subject>

[optional body]

[optional footer(s)]
```

## Types

| Type       | Description                                        |
| ---------- | -------------------------------------------------- |
| `feat`     | New feature or configuration addition              |
| `fix`      | Bug fix or correction                              |
| `refactor` | Code/config restructuring without behavior change  |
| `chore`    | Maintenance tasks, dependency updates              |
| `docs`     | Documentation changes                              |
| `style`    | Formatting, whitespace, cosmetic changes           |
| `perf`     | Performance improvements                           |
| `revert`   | Reverts a previous commit                          |

## Scopes

Use the stow package or tool name, always **lowercase**:

- **Shell**: `fish`, `bash`, `zsh`
- **Editor**: `nvim`, `helix`
- **Terminal**: `tmux`, `ghostty`, `wezterm`, `alacritty`
- **Tools**: `git`, `lazygit`, `starship`, `fzf`, `lf`, `ranger`
- **macOS**: `karabiner`, `skhd`, `yabai`, `aerospace`
- **Packages**: `brew`, `pip`
- **Other**: `bin`, `ssh`, `colors`

Omit scope for broad or cross-cutting changes (e.g., `chore: update stow targets`).

## Subject Rules

- Use imperative mood (`add`, `fix`, `update` — not `added`, `fixes`, `updated`)
- Start with lowercase
- No period at the end
- Maximum 72 characters

## Body (optional)

- Separate from subject with a blank line
- Explain **what** and **why**, not how
- Wrap at 72 characters

## Footer (optional)

- Reference issues: `Closes #123`
- Note breaking changes: `BREAKING CHANGE: removed X alias`

## Examples

```
feat(fish): show at job counts
feat(tmux): bind k -> l
fix(fish): use local pnpm
refactor: formatter & linter
chore(brew): update Brewfile
feat(git): ignore gemini settings
feat(ghostty): support shift + enter
```

## Workflow

After making changes, verify they work before committing:

- **Shell configs**: Open a new shell session or `source` the config
- **Stow packages**: Run `stow --simulate <package>` to check for conflicts
- **Brewfile changes**: Run `brew bundle check` to validate
- **Neovim**: Open nvim and confirm no errors on startup
- **tmux**: Reload config with `prefix + r` or `tmux source-file ~/.tmux.conf`

Once changes are verified, commit them automatically — do not ask for
confirmation first. This applies to all work in this dotfiles repo.

## After Committing

Always rebase onto main and push after completing changes:

```bash
git pull --rebase origin main  # rebase if needed
git push origin main
```

This applies to every commit in this dotfiles repo — do not leave unpushed work.
