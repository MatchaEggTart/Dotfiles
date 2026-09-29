# Environment / 环境

## System / 系统
- Arch Linux, rolling release. / Arch Linux，滚动更新。
- Package managers: pacman (official repos), paru (AUR), flatpak.
- 包管理：pacman（官方仓库）、paru（AUR）、flatpak。
- Do not suggest apt, dnf, brew, or other distros' package managers.
- 不要建议 apt、dnf、brew 或其它发行版的包管理。

## Desktop session / 桌面
- KDE on Wayland; window manager is KWin. / KDE，Wayland 会话，窗口管理器 KWin。
- Prefer Wayland-native tools. X11-only tools may not work.
- 优先用 Wayland 原生工具，只支持 X11 的可能跑不起来。
- Clipboard: wl-clipboard (`wl-copy`, `wl-paste`).

## Terminal and shell / 终端与 shell
- Terminal: kitty. / 终端：kitty。
- Shell: zsh with oh-my-zsh; prompt comes from oh-my-posh.
- Editor: `$EDITOR` is emacs; nvim is also installed.
- 编辑器：`$EDITOR` 为 emacs，也装了 nvim。

## Language runtimes and build tools / 语言运行时与构建工具
- python3, pipx
- node (via nvm), npm, bun
- go, cargo (Rust)
- gcc, clang, make, cmake
- lua

## CLI tools / 命令行工具
- Available: eza, rg, fd, fzf, stow, wl-clipboard.
- Not installed: bat, zoxide, tmux, jq, yq. Use coreutils/sed, or install first.
- 未安装：bat、zoxide、tmux、jq、yq；先用 coreutils/sed，或先装再用。

## Containers / 容器
- Prefer podman. Do not use docker. / 优先 podman，不用 docker。

## Verifying facts / 现查
- This is a rolling release: don't assume software versions.
- 滚动更新，不要假设任何软件的版本。
- Package version: `pacman -Q <pkg>`. AUR: `paru -Q <pkg>`.
- Which package owns a file: `pacman -Qo <path>`.
- Search installed packages: `pacman -Qs <query>`.
