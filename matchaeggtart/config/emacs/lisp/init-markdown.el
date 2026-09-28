;;; init-markdown.el --- the configurations for markdown -*- lexical-binding: t -*-
;;; Commentary:
;;;   Markdown 模式配置详解
;;;
;;;   注意: Emacs 默认不自带 markdown 主模式, 打开 .md 文件时
;;;   只会落入 fundamental-mode/text-mode, 没有高亮和折叠。
;;;   这里使用 markdown-mode (NonGNU ELPA 上 GNU 官方维护的包)。
;;;
;;;   use-package 语法说明:
;;;   - :pin   指定从哪个源安装 (melpa, nongnu, gnu 等)
;;;   - :mode  打开指定后缀的文件时自动进入该主模式
;;;   - :hook  在某个 mode 启动时自动运行函数
;;;   - :bind  定义快捷键 (配合 :map 可绑定到指定 keymap)
;;;   - :config 配置在包加载后执行
;;;   - :after  等指定包加载后再加载当前包
;;;
;;;   常用快捷键:
;;;   [标题导航] (markdown-mode 自带)
;;;   - TAB / S-TAB         折叠/展开当前标题 / 整个文档
;;;   - C-c C-n / C-c C-p   下一个 / 上一个标题
;;;   - C-c C-u             跳到上一级标题
;;;
;;;   [插入标记] (markdown-mode 自带)
;;;   - C-c C-t 1~6         插入一~六级标题
;;;   - C-c C-s b/i/c       插入粗体/斜体/行内代码
;;;   - C-c C-a l           插入链接
;;;   - C-c C-i             插入图片
;;;
;;;   [预览]
;;;   - C-c C-c l           live preview: Emacs 内分屏实时预览 (eww 渲染)
;;;   - C-c C-c p           markdown-preview-mode: 浏览器实时预览 (再按一次关闭)
;;;
;;;   [目录]
;;;   - M-x markdown-toc-generate-or-refresh-toc   生成/更新目录
;;;
;;;   [排版] (自定义, C-c C-w 前缀: w = width + wrap)
;;;   - C-c C-w c           居中 ↔ 左对齐
;;;   - C-c C-w w           折行排版整体开/关
;;;   - C-c C-w +           列宽 +5
;;;   - C-c C-w -           列宽 −5 (下限 40)
;;;
;;; Code:

;; ============================================================================
;; markdown-mode: 核心主模式
;; ============================================================================
(use-package markdown-mode
  ;; 该包由 GNU 官方在 NonGNU ELPA 维护, 比 melpa-stable 更新更及时
  :pin nongnu

  ;; 打开以下后缀的文件时自动进入 markdown-mode
  :mode (("\\.md\\'"       . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)
         ("\\.mdown\\'"    . markdown-mode)
         ("\\.mkd\\'"      . markdown-mode))

  ;; 进入 markdown-mode 时开启视觉折行 (长行自动换行, 方便阅读)
  :hook (markdown-mode . visual-line-mode)

  :config
  ;; Markdown 转 HTML 的转换器 (预览/导出用, 需装 pandoc)
  ;; pandoc 功能最全, 支持表格/代码块/GFM 等扩展语法
  (setq markdown-command "pandoc")

  ;; live preview (C-c C-c l) 分屏方向: 'right 右边 / 'below 下方
  (setq markdown-split-window-direction 'right)

  ;; 代码块按对应语言原生高亮 (如 ```python 内的代码会按 python 高亮)
  (setq markdown-fontify-code-blocks-natively t)

  ;; 标题字号按级别缩放 (H1 最大, H6 最小)
  (setq markdown-header-scaling t)

  ;; 支持 LaTeX 数学公式 (pandoc 风格 $...$ / $$...$$)
  (setq markdown-enable-math t)

  ;; 关闭 live preview 时删除预览窗口
  ;; markdown-mode 默认只 kill-buffer 不删 window, 会残留一个空窗口,
  ;; 这里用 advice 在杀 buffer 之前先把显示预览的 window 删掉
  (defun my-md-live-preview-delete-window ()
    "Delete the window showing the live preview buffer."
    (when (and (boundp 'markdown-live-preview-buffer)
               markdown-live-preview-buffer
               (buffer-live-p markdown-live-preview-buffer))
      (let ((win (get-buffer-window markdown-live-preview-buffer)))
        (when (window-live-p win)
          (delete-window win)))))

  (advice-add 'markdown-live-preview-remove :before
              #'my-md-live-preview-delete-window)
  )

;; ============================================================================
;; markdown-toc: 自动生成目录 (TOC)
;; ============================================================================
;; 长文档里生成/更新目录 (插入到光标处):
;;   M-x markdown-toc-generate-or-refresh-toc
(use-package markdown-toc
  :after markdown-mode
  )

;; ============================================================================
;; markdown-preview-mode: 浏览器实时预览 (MELPA)
;; ============================================================================
;; 用本地 web server + websocket 把渲染结果实时推送到浏览器,
;; 编辑时自动刷新, 支持滚动同步。
;; 依赖: markdown-command (pandoc) 以及 web-server / websocket (自动装)。
;;
;; C-c C-c p 启动预览 (自动打开浏览器), 再按一次关闭 (toggle)。
;;
;; 注意: 要绑定 markdown-preview-mode 而不是 markdown-preview-open-browser,
;;       后者只在 mode 已启动后重新打开浏览器, 直接调用会得到 uuid=nil。
(use-package markdown-preview-mode
  :pin melpa
  :after markdown-mode
  :bind (:map markdown-mode-map
              ("C-c C-c p" . markdown-preview-mode))
  :config
  ;; 预览页面的 CSS 主题
  ;; 默认是 solarized-dark 深色背景, 这里换成浅色主题 (白底)
  ;; 若完全不想要任何样式, 改成 (setq markdown-preview-stylesheets nil)
  (setq markdown-preview-stylesheets
        (list "https://thomasf.github.io/solarized-css/solarized-light.min.css"))
  )

;; ============================================================================
;; visual-fill-column: 舒适阅读排版
;; ============================================================================
;; 让正文在固定列宽处换行并居中, 配合 visual-line-mode 阅读体验更好。
;;
;; C-c C-w 前缀: w = width(列宽) + wrap(折行)
;;   C-c C-w c      切换居中
;;   C-c C-w w      整体开关折行排版
;;   C-c C-w + / -  列宽加宽/变窄
(use-package visual-fill-column
  ;; 进入 markdown-mode 时自动开启
  :hook (markdown-mode . visual-fill-column-mode)

  ;; 自定义排版快捷键
  :bind (:map markdown-mode-map
              ("C-c C-w c" . my-md-toggle-center)
              ("C-c C-w w" . my-md-toggle-wrap)
              ("C-c C-w +" . my-md-wider)
              ("C-c C-w -" . my-md-narrower))

  :config
  (setq visual-fill-column-width 80        ; 每行宽度 (列数)
        visual-fill-column-center-text t)  ; 居中显示

  ;; 切换居中: 居中 ↔ 左对齐 (保留折行)
  ;; 改完变量后重新开关一次 mode 让它生效
  (defun my-md-toggle-center ()
    "切换正文是否居中显示"
    (interactive)
    (setq visual-fill-column-center-text (not visual-fill-column-center-text))
    (visual-fill-column-mode -1)
    (visual-fill-column-mode 1))

  ;; 整体开关折行排版 (折行 + 居中一起开/关)
  ;; 关掉后长行不换行, 需要水平滚动
  (defun my-md-toggle-wrap ()
    "整体开关折行排版 (折行 + 居中)"
    (interactive)
    (if visual-fill-column-mode
        (progn (visual-fill-column-mode -1)
               (visual-line-mode -1))
      (visual-line-mode 1)
      (visual-fill-column-mode 1)))

  ;; 列宽增加 5
  (defun my-md-wider ()
    "列宽增加 5"
    (interactive)
    (setq visual-fill-column-width (+ visual-fill-column-width 5))
    (visual-fill-column-mode -1)
    (visual-fill-column-mode 1))

  ;; 列宽减少 5 (下限 40, 避免太窄)
  (defun my-md-narrower ()
    "列宽减少 5 (下限 40)"
    (interactive)
    (setq visual-fill-column-width (max 40 (- visual-fill-column-width 5)))
    (visual-fill-column-mode -1)
    (visual-fill-column-mode 1)))

(provide 'init-markdown)

;;; init-markdown.el ends here
