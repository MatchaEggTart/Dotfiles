;;; init-markdown.el --- Markdown 配置 (基于 markdown-ts-mode) -*- lexical-binding: t -*-
;;; Commentary:
;;;   Markdown 主模式: Emacs 31 内置的 markdown-ts-mode (基于 tree-sitter)。
;;;
;;;   背景与注意事项:
;;;   1. markdown-ts-mode 是 Emacs 31 内置的 "实验性" 模式, 官方默认不启用,
;;;      所以 auto-mode-alist 里没有 .md 后缀。这里用 `major-mode-remap-alist'
;;;      把 "要打开 markdown-mode" 的请求全部改派给 markdown-ts-mode (见文末)。
;;;   2. 它需要两个语法库: markdown + markdown-inline。Arch 上安装
;;;      `tree-sitter-markdown' 即可 (本机已装), 不需要自己编译。
;;;   3. 它是独立主模式, 不继承 markdown-mode 的 hook 和 keymap,
;;;      因此所有 hook/快捷键都改挂到 markdown-ts-* 上。
;;;   4. 内置版的 markdown-ts-mode 没有 autoload cookie, 必须显式 require,
;;;      否则连 M-x markdown-ts-mode 都是 void-function。
;;;
;;; ---------------------------------------------------------------------------
;;; 快捷键总览
;;; ---------------------------------------------------------------------------
;;;
;;; [结构导航] (markdown-ts-mode 内置)
;;;   TAB / S-TAB            折叠/展开当前标题 / 整篇文档
;;;   C-c C-n / C-c C-p      下一个 / 上一个标题
;;;   C-c C-u                跳到上一级标题
;;;   C-c C-f / C-c C-b      跳到同级的下一个 / 上一个标题
;;;   M-<left> / M-<right>   当前标题降 / 升一级
;;;   M-<up> / M-<down>      上下移动当前子树
;;;
;;; [编辑] (markdown-ts-mode 内置)
;;;   M-RET                  插入列表项
;;;   C-c C-,                插入块结构, 按提示选择:
;;;                            ` 反引号代码块 | ~ 波浪号代码块 | q 引用
;;;                            d 分隔线       | t 表格
;;;   C-c C-r                重排有序列表编号
;;;   C-c C-c                切换任务列表复选框 ( [ ] <-> [x] )
;;;   C-c C-x C-f            强调 (交互式选 b/i/c/...)
;;;   C-c C-x C-m            显示 / 隐藏 markup (hide-markup)
;;;   C-c C-x C-v            显示 / 隐藏内联图片
;;;
;;; [本配置新增]
;;;   C-c C-s b / i / c      加粗 / 斜体 / 行内代码
;;;                          (对选中区域生效; 无选区则作用于光标所在词)
;;;   C-c C-e                预览开关: 按一次转 HTML 并在右侧用 eww 打开,
;;;                          再按一次关掉窗口; 不会自动刷新
;;;   C-c C-t                生成 / 刷新目录 (TOC)
;;;
;;; [排版] (visual-fill-column, 自定义 C-c C-w 前缀: w = width + wrap)
;;;   C-c C-w c              居中 <-> 左对齐
;;;   C-c C-w w              折行排版整体开 / 关 (折行 + 居中)
;;;   C-c C-w + / -          列宽 +5 / -5 (下限 40)
;;;
;;; [导出 / 其他命令]
;;;   M-x markdown-ts-convert              交互式导出 (可选输出文件与格式)
;;;   M-x markdown-ts-toc-insert-template  插入 TOC 模板 (首次生成目录前用)
;;;   M-x markdown-ts-browse-gfm-spec      打开 GFM 语法说明
;;;
;;; Code:

;; ============================================================================
;; 核心: markdown-ts-mode
;; ============================================================================
(use-package markdown-ts-mode
  ;; Emacs 31 内置, 不属于任何 ELPA 源, 所以必须 :ensure nil,
  ;; 否则 use-package-always-ensure 会尝试从网上安装它。
  :ensure nil
  ;; 内置版没有 autoload cookie, 必须立即加载 (理由见文件头注释第 4 条)。
  :demand t

  :config
  ;; 附带的扩展: HTML 转换 (converter) + 目录 (TOC) + 语法说明浏览
  (require 'markdown-ts-mode-x)

  ;; ---- 转换器: 把系统里已有的 md2html (md4c) 注册成 HTML 转换器 ----
  ;; 为什么不用内置的 (html . markdown) 条目:
  ;;   Arch 的 /usr/bin/markdown 是 discount, 它不接受内置条目拼接的
  ;;   "--" / "--html4tags" 参数, 会直接报 "illegal option"。
  ;; md2html 来自 md4c (qt5-base/qt6-base 的依赖, 本机已有), 支持 GFM:
  ;;   --github       GitHub 风格 (表格 / 任务列表 / 删除线 / 自动链接)
  ;;   --flatex-math  识别 $...$ / $$...$$ 数学
  ;;   -f             输出完整 HTML 文档 (含 <head>), 交给 eww 更合适
  (let ((html (alist-get 'html markdown-ts-converters)))
    (unless (assq 'md2html html)
      (setcdr (assq 'html markdown-ts-converters)
              (cons (cons 'md2html
                          (list :command "md2html"
                                :input '(file stdin)
                                :output '(stdout)
                                :arguments-function
                                (lambda (input-file _output-file)
                                  (append (list "--github" "--flatex-math" "-f")
                                          (when input-file (list input-file))))))
                    (cdr (assq 'html markdown-ts-converters))))))

  ;; 默认用 md2html 转 HTML (显示方式在下面的 "预览" 一节里配置)
  (setq markdown-ts-default-converter '(html . md2html))

  ;; ---- markdown-ts 自身的选项 (以下都是默认值, 写出来表明是有意保留) ----
  ;; 不隐藏 ** / # / []() 等标记 (想看 "所见即所得" 可用 C-c C-x C-m 临时切换)
  (setq markdown-ts-hide-markup nil)
  ;; 代码块按对应语言原生高亮 (如 ```python 按 python 高亮)
  (setq markdown-ts-fontify-code-blocks-natively t)
  ;; 说明: markdown-mode 的 markdown-header-scaling (标题缩放) 没有等价物,
  ;;       markdown-ts-mode 的标题只有 face 高亮、不再放大字号。

  ;; ---- 预览: 当前缓冲区 -> 临时 HTML -> eww (C-c C-e 开关) ----
  (defvar my-md-ts-preview-file
    (expand-file-name "emacs-md-ts-preview.html" temporary-file-directory)
    "C-c C-e 预览时生成的临时 HTML 文件 (固定路径, 每次覆盖)。")

  (defun my-md-ts-preview--url ()
    "预览文件的 file:// URL, 用来识别 eww 里显示的到底是不是这次预览。"
    (concat "file://" (expand-file-name my-md-ts-preview-file)))

  (defun my-md-ts-preview--display (file)
    "用 eww 渲染 FILE, 固定放在右侧 side window。"
    (let ((display-buffer-overriding-action
           '((display-buffer-in-side-window)
             (side . right)
             (slot . 0)
             (window-width . 0.5))))
      (eww-open-file file)))

  ;; 转完 HTML 后用上面这个函数显示 (而不是默认的 eww-open-file)
  (setq markdown-ts-convert-display-function #'my-md-ts-preview--display)

  (defun my-md-ts-preview--window ()
    "如果当前有个窗口正显示本次预览, 返回那个窗口, 否则返回 nil。"
    (let ((buf (get-buffer "*eww*")))
      (when buf
        (when-let* ((win (get-buffer-window buf t))
                    (url (plist-get (buffer-local-value 'eww-data buf) :url)))
          (when (equal url (my-md-ts-preview--url))
            win)))))

  (defun my-md-ts-preview ()
    "开关当前缓冲区的 HTML 预览。
按一次: 转成 HTML, 在右侧窗口用 eww 打开;
再按一次: 关掉预览窗口 (保留 *eww* buffer);
第三次按: 重新转换并打开 (所以内容一定是最新的)。
注意: 不会随保存或编辑自动刷新, 想看新版就再按一次开关。"
    (interactive)
    (unless (derived-mode-p 'markdown-ts-mode)
      (user-error "C-c C-e 只在 markdown-ts-mode 中可用"))
    (if-let* ((win (my-md-ts-preview--window)))
        ;; 预览开着 -> 关掉窗口, 保留 *eww* buffer
        (progn (delete-window win)
               (message "预览已关闭"))
      ;; 预览没开 -> 转换 + 显示
      (unless (executable-find "md2html")
        (user-error "找不到 md2html, 请先安装 md4c 包"))
      (let ((orig (selected-window)))
        (unwind-protect
            ;; (markdown-ts-convert INPUT OUTPUT FORMAT DISPLAY OVERWRITE QUIET)
            ;; INPUT nil = 用当前缓冲区; DISPLAY t = 转完调用显示函数
            (markdown-ts-convert nil my-md-ts-preview-file '(html . md2html) t t t)
          ;; 把光标交还给 Markdown 窗口, 方便接着按 C-c C-e 关掉
          (when (window-live-p orig) (select-window orig))))))

  ;; ---- 补回 markdown-mode 的 C-c C-s b/i/c ----
  ;; markdown-ts-emphasize 原生支持 b(粗体)/i(斜体)/c(行内代码) 等标记,
  ;; 这里只是给它套上 markdown-mode 风格的三个单键命令。
  (defun my-md-ts-bold ()   (interactive) (markdown-ts-emphasize ?b))
  (defun my-md-ts-italic () (interactive) (markdown-ts-emphasize ?i))
  (defun my-md-ts-code ()   (interactive) (markdown-ts-emphasize ?c))

  ;; ---- 新增快捷键 ----
  (define-key markdown-ts-mode-map (kbd "C-c C-s b") #'my-md-ts-bold)
  (define-key markdown-ts-mode-map (kbd "C-c C-s i") #'my-md-ts-italic)
  (define-key markdown-ts-mode-map (kbd "C-c C-s c") #'my-md-ts-code)
  (define-key markdown-ts-mode-map (kbd "C-c C-e")   #'my-md-ts-preview)
  (define-key markdown-ts-mode-map (kbd "C-c C-t")   #'markdown-ts-toc-generate)

  ;; ---- .md -> markdown-ts-mode: 重映射 ----
  ;; markdown-mode 的 autoload 会把 .md 注册进 auto-mode-alist;
  ;; 这里把所有 "请求 markdown-mode" 的场合改派给 markdown-ts-mode,
  ;; 这样连第三方包打开 Markdown 缓冲区也会走 ts 模式。
  (add-to-list 'major-mode-remap-alist '(markdown-mode . markdown-ts-mode))
  )

;; ============================================================================
;; markdown-mode: 不再作为主模式, 仅保留安装
;; ============================================================================
;; 保留它的原因:
;;   1. 它的 autoload 负责把 .md 注册到 auto-mode-alist, 我们再 remap 到
;;      markdown-ts-mode (见上面)。没有它就没人注册 .md, remap 也就无从谈起。
;;   2. 大量第三方包 (aider / copilot-chat / consult-gh / code-review ...)
;;      依赖 markdown-mode, 卸载会连带出问题。
;; 所以这里不写任何 :mode / :hook / :bind, 只是确保它处于已安装状态。
(use-package markdown-mode
  :pin nongnu
  )

;; ============================================================================
;; markdown-toc / markdown-preview-mode: 已弃用
;; ============================================================================
;; 这两个包依赖 markdown-mode 的内部实现, 在 markdown-ts-mode 下不可用:
;;   - 目录 TOC 改用内置的 markdown-ts-toc-generate      (绑定: C-c C-t)
;;   - 预览   改用内置的 markdown-ts-convert + md2html   (绑定: C-c C-e)
;; 包本身可以保留不管, 也可以以后 M-x package-delete 掉。

;; ============================================================================
;; visual-fill-column: 舒适阅读排版
;; ============================================================================
;; 让正文在固定列宽处换行并居中, 配合 visual-line-mode 阅读体验更好。
;; 注意: hook 和 keymap 都挂在 markdown-ts-mode 上 (ts 模式不继承 markdown-mode)。
;;
;; C-c C-w 前缀: w = width(列宽) + wrap(折行)
;;   C-c C-w c      切换居中
;;   C-c C-w w      整体开关折行排版
;;   C-c C-w + / -  列宽加宽/变窄
(use-package visual-fill-column
  ;; 进入 markdown-ts-mode 时自动开启视觉折行 + 定宽居中
  :hook ((markdown-ts-mode . visual-line-mode)
         (markdown-ts-mode . visual-fill-column-mode))

  ;; 自定义排版快捷键
  :bind (:map markdown-ts-mode-map
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
