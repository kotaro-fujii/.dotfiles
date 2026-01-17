# Repository Guidelines

## Project Structure & Module Organization
- Root contains top-level configs and bootstrap scripts (e.g., `initialize.sh`, `tmux.conf`, `gitconfig`).
- Tool-specific configs live in directories named after the tool: `zsh/`, `bash/`, `nvim/`, `vim/`, `emacs.d/`, `wezterm/`, `alacritty/`.
- Utility scripts live in `bin/`.
- Language/runtime installers and vendored tools live in `miniforge3/`, `node/`, and `stack/` (when present).

## Build, Test, and Development Commands
- `zsh initialize.sh` (or `./initialize.sh`): create symlinks into `$HOME` and set up platform-specific configs (WSL/Windows paths included).
- `./initialize.sh` also defines install helpers; invoke them in a shell if needed (e.g., `install_neovim`, `install_fzf`).
- There is no single “build” step; this repo is primarily configuration and setup scripts.

## Coding Style & Naming Conventions
- Follow existing file style; in `initialize.sh`, use 2-space indentation and `snake_case` for functions and variables.
- Keep shell scripts POSIX-ish where possible, but this repo targets `zsh` (shebangs should reflect that).
- Prefer descriptive, lowercase file and directory names that match the tool (e.g., `wezterm/wezterm_linux.lua`).

## Testing Guidelines
- No formal automated tests are tracked.
- Validate changes by running `zsh initialize.sh` in a disposable environment and confirming symlinks/configs are correct.
- For shell changes, consider running `shellcheck` if available.

## Commit & Pull Request Guidelines
- Recent history favors short, imperative messages like “Add …” or “Disable …”. Keep commits scoped and readable.
- PRs should include: a brief summary, affected tools/directories, and any OS/terminal context (e.g., WSL vs Linux).
- If changing interactive configs (shell, editor, terminal), include before/after notes or screenshots where relevant.

## Security & Configuration Tips
- Review scripts before executing; several helpers download or install external tools.
- Keep user-specific secrets out of tracked files; prefer local overrides (e.g., `~/.config/jj/conf.d/user.toml`).
