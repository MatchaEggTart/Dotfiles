---
name: flan-legion-env
description: Use for work on this user's Arch Linux workstation — shell commands, package installs, language runtimes, or anything desktop-related (Wayland / KDE Plasma / kitty). Load it instead of assuming macOS, Ubuntu, or X11.
---

# Machine Environment / 机器环境

This user runs Arch Linux with KDE Plasma on Wayland and the kitty terminal.
Read `reference/ENVIRONMENT.md` before choosing commands, installers, or tools,
so you don't reach for apt, X11-only utilities, or tools that aren't installed.

这个用户使用 Arch Linux，桌面是 Wayland 上的 KDE Plasma，终端是 kitty。
在决定用什么命令、怎么安装、用哪个工具之前，先读 `reference/ENVIRONMENT.md`，
避免用错 apt、只支持 X11 的工具，或根本没装的工具。

## Load this when / 加载时机

- Running shell commands or installing software / 执行 shell 命令或安装软件
- Setting up a project toolchain or dev environment / 配置项目工具链或开发环境
- Anything that depends on the desktop, terminal, or display server / 任何依赖桌面、终端或显示服务器的事

## Web search / 联网搜索

Prefer the local SearXNG MCP tools over the built-in websearch providers:

- `searxng_web_search` — main search (meta-search: Google, Brave, DuckDuckGo, …)
- `web_url_read` — read a page's content as markdown (HTML and PDF)
- `searxng_search_suggestions`, `searxng_instance_info` — refine a query / inspect the instance

联网搜索优先用本地 SearXNG 的 MCP 工具：搜索用 `searxng_web_search`，读网页用 `web_url_read`。
不要改用内置的 Exa/Tavily 之类。

If the MCP tools are unavailable (service down, or tools not connected), fall back to the
JSON endpoint — this does not depend on any client config:

```bash
curl -sG 'http://127.0.0.1:8080/search' --data-urlencode 'q=QUERY' --data-urlencode 'format=json'
```

A non-empty `unresponsive_engines` is normal (one engine failing); 0 results with every
engine timing out means the proxy is down. / 结果里 `unresponsive_engines` 非空属正常；
结果为 0 且引擎全是 timeout 说明代理挂了。
