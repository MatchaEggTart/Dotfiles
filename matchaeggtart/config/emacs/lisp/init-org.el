;;; init-org.el --- the configurations for org  -*- lexical-binding: t; -*-
;;; Commentary:
;;;   Org Mode 配置详解
;;;
;;;   use-package 语法说明:
;;;   - :diminish 隐藏 mode-line 上的模式名称
;;;   - :hook 在特定 mode 启动时自动运行函数
;;;   - :bind 定义全局快捷键
;;;   - :map 在特定 keymap 中定义快捷键
;;;   - :config 配置在包加载后执行
;;;   - :after 等指定包加载后再加载当前包
;;;   - :pin 指定从哪个源安装（melpa, nongnu, gnu 等）
;;;
;;;   快捷键约定:
;;;   - C-c C-x  是 org-mode 的标准前缀
;;;   - C-c a    是 agenda 的标准前缀
;;;   - C-c n    是 org-roam 的标准前缀
;;;   - C-c      是用户自定义命令的前缀

;;; 创建文件
;;; mkdir -p ~/Workspace/Org/GTD/ ~/Workspace/Org/blog/ ~/Workspace/Org/org-files/

;;; Code:

;; ============================================================================
;; Org Mode 核心配置
;; ============================================================================

(use-package org
  ;; :diminish 隐藏 mode-line 上显示的 "Org" 文字，让状态栏更简洁
  :diminish org-indent-mode

  ;; :hook 当进入 org-mode 时自动启用这些 minor-mode
  ;; - org-indent-mode: 标题缩进显示（显示层级结构）
  ;; - variable-pitch-mode: 可变宽字体模式（标题用大字体，正文用等宽）
  ;; - visual-line-mode: 视觉行模式（单词自动折行）
  :hook (
          (org-mode . org-indent-mode)
          (org-mode . variable-pitch-mode)
          (org-mode . visual-line-mode)
          )

  ;; :bind 定义全局快捷键（在任意地方都能用）
  ;; :map org-mode-map 定义在 org-mode 的 keymap 中
  :bind (
          ;; C-c a 打开日程视图（agenda），查看所有待办事项
          ("C-c a" . org-agenda)
          ;; C-c l 存储当前文件的链接，之后可以 C-c C-l 粘贴
          ("C-c l" . org-store-link)
          ;; C-c c 快速捕获（capture），在任意地方快速记录想法
          ("C-c c" . org-capture)
          :map org-mode-map
          ;; M-n 跳到下一个可见标题（heading）
          ("M-n" . org-next-visible-heading)
          ;; M-p 跳到上一个可见标题
          ("M-p" . org-previous-visible-heading)
          )

  :config
  ;; =========================================================================
  ;; 基础显示设置
  ;; =========================================================================

  ;; 以前的标题
  ;; (require 'org-bars)

  ;; org-hide-leading-stars: t 隐藏标题前的多余星号
  ;;   例如: * 第一章  显示为 第一章 (而不是 * 第一章)
  (setq org-hide-leading-stars t)

  ;; org-hide-emphasis-markers: t 隐藏强调标记
  ;;   例如: *粗体* 显示为 粗体 (而不是 *粗体*)
  (setq org-hide-emphasis-markers t)

  ;; org-startup-indented: t 启用缩进模式，子标题自动缩进
  (setq org-startup-indented t)

  ;; 让缩进 / 对间距敏感的 face 强制走等宽字体。
  ;; 原因: org-indent-mode 的"缩进"是一串不可见的行首字符 (org-indent face),
  ;;       它默认继承 default; 开了 variable-pitch-mode 后 default 变成比例字体,
  ;;       缩进前缀就会变得又窄又乱, 正文/代码块看起来比标题靠左、对不齐。
  ;; 只设 :family (不碰 :inherit/:foreground), 所以主题配色不受影响。
  ;; 注意: org-indent 这个 face 定义在 org-indent.el 里, 得先 require 出来。
  (require 'org-indent)
  (let ((mono (face-attribute 'fixed-pitch :family)))
    (when (stringp mono)
      (dolist (f '(org-indent org-hide
                    org-block org-block-begin-line org-block-end-line
                    org-code org-verbatim org-table org-meta-line))
        (set-face-attribute f nil :family mono))))

  ;; org-startup-with-inline-images: t 启动时自动显示内联图片
  (setq org-startup-with-inline-images t)

  ;; org-pretty-entities: t 美化实体显示
  ;;   例如: \alpha 显示为 α, \rightarrow 显示为 →
  (setq org-pretty-entities t)

  ;; org-ellipsis: 折叠时显示的省略号，▾ 是实心小三角
  (setq org-ellipsis " ▾")

  ;; =========================================================================
  ;; TODO 关键字配置
  ;; =========================================================================
  ;; sequence 表示状态转换链，"|" 左边是未完成状态，右边是完成状态
  ;; 快捷键 C-c C-t 可以快速切换状态
  (setq org-todo-keywords
    '((sequence "TODO(t)" "STARTED(s)" "|" "DONE(d!)")
       ;; 第一行: 待办 -> 进行中 -> 完成
       ;; 第二行: 等待 -> 将来 -> 取消 -> 会议 -> 电话
       (sequence "WAITING(w@/!)" "SOMEDAY(S)" "|" "CANCELLED(c@/!)" "MEETING(m)" "PHONE(p)")))

  ;; =========================================================================
  ;; 记录完成时间
  ;; =========================================================================
  ;; org-log-done: 'time 完成时自动记录时间戳
  ;; org-log-into-drawer: t 把日志写入 LOGBOOK drawer（:LOGBOOK: ... :END:）
  (setq org-log-done 'time
    org-log-into-drawer t
    org-log-state-notes-insert-after-drawers nil)

  ;; =========================================================================
  ;; GTD 日程管理配置
  ;; =========================================================================
  ;; org-agenda-files: 日程文件列表，支持多个文件
  (setq org-agenda-files '("~/Workspace/Notes/Org/GTD/gtd.org"))

  ;; org-agenda-span: 默认显示的时间跨度，'day 是当天
  (setq org-agenda-span 'day)

  ;; org-agenda-start-day: nil 从今天开始显示
  (setq org-agenda-start-day nil)

  ;; org-agenda-start-on-weekday: nil 不强制从周一开始
  (setq org-agenda-start-on-weekday nil)

  ;; org-sticky-priority: t 始终显示优先级（[#A] 这样的）
  (setq org-sticky-priority t)

  ;; org-agenda-window-setup: 'other-window 在其他窗口打开 agenda
  (setq org-agenda-window-setup 'other-window)

  ;; =========================================================================
  ;; 代码块配置
  ;; =========================================================================
  ;; org-src-fontify-natively: t 代码块语法高亮
  ;; org-src-tab-acts-natively: t 代码块中 Tab 正常工作
  ;; org-edit-src-content-indentation: 2 代码块内容缩进空格数
  (setq org-src-fontify-natively t
    org-src-tab-acts-natively t
    org-edit-src-content-indentation 2)

  ;; =========================================================================
  ;; 导出配置
  ;; =========================================================================
  ;; org-export-with-drawers: t 导出时保留 drawer 内容
  ;; org-export-with-beamer: t 支持 beamer 演示文稿导出
  ;; org-html-doctype: "html5" 使用 HTML5
  ;; org-html-html5-fancy: t 使用 HTML5 标签
  (setq org-export-with-drawers t
    org-export-with-beamer t
    org-html-doctype "html5"
    org-html-html5-fancy t)

  ;; =========================================================================
  ;; 表格配置
  ;; =========================================================================
  ;; org-table-default-size: "4 2" 默认创建 4 列 2 行的表格
  ;; org-table-header-font-style: 'bold 表头加粗
  (setq org-table-default-size "4 2"
    org-table-header-font-style 'bold)

  ;; =========================================================================
  ;; 附件配置
  ;; =========================================================================
  ;; org-attach-dir-relative: t 附件路径相对于当前文件
  ;; org-attach-use-inheritance: t 子标题继承父标题的附件目录设置
  (setq org-attach-dir-relative t
    org-attach-use-inheritance t)

  ;; =========================================================================
  ;; Easy Templates（快速插入代码块）
  ;; =========================================================================
  ;; 使用 <s TAB 可以插入代码块模板
  ;; 其他常用模板:
  ;;   <e TAB -> example 块
  ;;   <q TAB -> quote 块
  ;;   <l TAB -> latex 块
  ;;   <r TAB -> raw 块
  ;;   <p TAB -> python 块
  (require 'org-tempo)
  )

;; ============================================================================
;; org-contrib: Org 官方扩展包集合
;; ============================================================================
;; 包含许多官方维护但不在 core 中的功能
(use-package org-contrib
  :pin nongnu
  :after org
  :config
  (require 'org-checklist)
  )

;; ============================================================================
;; org-modern: 现代外观（替代 org-bars）
;; ============================================================================
;; 提供更现代的 org 外观，包括优先级徽章、TODO 标签样式等
(use-package org-modern
  :after org
  :hook (org-mode . org-modern-mode)
  :config
  ;; org-modern-hide-stars: nil 不隐藏星号
  ;; org-modern-table: nil 禁用内置表格美化（由 valign 处理）
  ;; org-modern-block-fringe: nil 禁用代码块边框
  (setq org-modern-hide-stars nil
    org-modern-table nil
    org-modern-block-fringe nil)

  ;; org-modern-priority: t 显示优先级徽章（如 [#A]）
  ;; org-modern-todo: t 美化 TODO 标签
  ;; org-modern-done: nil 不美化 DONE 标签
  (setq org-modern-priority t
    org-modern-todo t
    org-modern-done nil)

  ;; org-modern-table-vertical/horizontal: 表格边框样式
  (setq org-modern-table-vertical 2
    org-modern-table-horizontal 1)
  )

;; ============================================================================
;; org-superstar: 已移除
;; ============================================================================
;; org-modern 官方说明它是 org-superstar 的完整替代品, 两者同时开只会在同一段
;; 文本属性上互相覆盖 (org-modern 用 display, org-superstar 用 composition,
;; display 会赢), 实际显示的始终是 org-modern 的折叠指示符。
;; 所以标题符号统一交给 org-modern 控制 (见上面 org-modern-star 等选项),
;; 这里不再启用 org-superstar。包本身可以留着, 也可以 package-delete 卸掉。

;; ============================================================================
;; valign: 表格对齐
;; ============================================================================
;; 让表格单元格中的文本垂直居中对齐
(use-package valign
  :pin gnu-devel
  :after org
  :hook (org-mode . valign-mode)
  :config
  (setq valign-fraction 0.5)
  )

;; ============================================================================
;; org-appear: 即时显示隐藏的 emphasis 标记
;; ============================================================================
;; 当鼠标悬停在文字上时，自动显示隐藏的强调标记
(use-package org-appear
  :after org
  :hook (org-mode . org-appear-mode)
  :config
  ;; org-appear-autolinks: t 鼠标悬停时显示链接的 URL
  ;; org-appear-autosubmarkers: t 显示下标 _ 和上标 ^
  ;; org-appear-emphasis: t 鼠标悬停时显示 * / + 等强调标记
  (setq org-appear-autolinks t
    org-appear-autosubmarkers t
    org-appear-emphasis t
    org-appear-trigger 'hover      ; 触发方式：hover（鼠标悬停）
    org-appear-delay 0.2)          ; 延迟 0.2 秒后显示
  )

;; ============================================================================
;; org-fragtog: LaTeX 公式即时预览
;; ============================================================================
;; 在 org 文件中编辑 LaTeX 公式时，即时显示预览
(use-package org-fragtog
  :after org
  :hook (org-mode . org-fragtog-mode)
  :config
  ;; org-fragtog-plain-scaling: 1.0 公式内文本缩放比例
  ;; org-fragtog-display-when-after: t 在光标后显示预览
  (setq org-fragtog-plain-scaling 1.0
    org-fragtog-display-when-after t)
  )

;; ============================================================================
;; org-roam: Zettelkasten 双向链接笔记系统
;; ============================================================================
;; 类似于 Roam Research 的笔记系统，支持双向链接、图谱视图等
(use-package org-roam
  :after org

  ;; 定义快捷键（都在 C-c n 前缀下）
  :bind (
          ;; C-c n l 切换 Roam 侧边栏（显示当前笔记的反向链接）
          ("C-c n l" . org-roam-buffer-toggle)
          ;; C-c n f 查找或创建节点（文件）
          ("C-c n f" . org-roam-node-find)
          ;; C-c n g 查看关系图谱
          ("C-c n g" . org-roam-graph)
          ;; C-c n i 插入指向其他节点的链接
          ("C-c n i" . org-roam-node-insert)
          ;; C-c n c 快速捕获到 Roam
          ("C-c n j" . org-roam-dailies-capture-today)
          :map org-mode-map
          ;; 在 org-mode-map 中也可以用这些快捷键
          ("C-c n j" . org-roam-dailies-capture-today))

  :config
  ;; org-roam-directory: 笔记存放的根目录
  (setq org-roam-directory (file-truename "~/Workspace/Notes/Org/org-files/"))

  ;; org-roam-node-display-template: 节点列表中的显示格式
  ;;   ${title:*} 显示标题
  ;;   ${tags:10} 显示标签（宽度 10，右对齐）
  (setq org-roam-node-display-template
    (concat "${title:*} "
      (propertize "${tags:10}" 'face 'org-tag)))

  ;; org-roam-db-autosync-mode: 启用数据库自动同步
  ;;   自动建立索引，加快搜索和链接解析
  (org-roam-db-autosync-mode)

  ;; org-roam-protocol: 支持从外部链接（如浏览器）直接创建笔记
  (require 'org-roam-protocol)
  )

;; ============================================================================
;; org-download: 截图和图片下载
;; ============================================================================
;; 支持截图、拖拽图片、复制图片到 org 文件
(use-package org-download
  :after org

  ;; C-S-y 调用截图命令（Ctrl+Shift+y）
  :bind ("C-S-y" . org-download-screenshot)

  :config
  ;; dired-mode-hook: 在 dired 模式下启用图片拖拽
  (add-hook 'dired-mode-hook 'org-download-enable)

  ;; org-download-screenshot-method: 截图方法
  ;;   Linux KDE 使用 wl-paste 从剪贴板读取图片
  (setq org-download-screenshot-method "wl-paste -t image/png > '%s'")

  ;; org-image-actual-width: nil 使用图片的原始尺寸显示
  (setq org-image-actual-width nil)

  ;; org-download-annotate-default: 下载图片时添加注释的函数
  ;;   这里返回空字符串，表示不添加注释
  (defun org-download-annotate-default (link)
    (make-string 0 ?\s))

  ;; 默认设置
  (setq-default
    ;; org-download-heading-lvl: nil 下载图片时不添加标题
    org-download-heading-lvl nil
    ;; org-download-image-dir: 图片保存的子目录
    org-download-image-dir "./img"
    ;; org-download-screenshot-file: 临时截图文件位置
    org-download-screenshot-file (expand-file-name "screenshot.jpg" temporary-file-directory))
  )

;; ;; ============================================================================
;; ;; ox-hugo: 导出到 Hugo 博客（暂未安装）
;; ;; ============================================================================
;; ;; 将 org 文件导出为 Hugo 博客兼容的 Markdown 格式
;; (use-package ox-hugo
;;   :after org
;;   :config
;;   (setq org-hugo-base-dir "~/Workspace/Org/blog/")
;;   (setq org-hugo-section "posts"))

;; ============================================================================
;; org-babel: 代码块执行
;; ============================================================================
;; 支持在 org 文件中编写和执行代码块
;; 使用 C-c C-c 执行当前代码块
(org-babel-do-load-languages
  'org-babel-load-languages
  '((shell . t)        ; 执行 shell 命令
     (python . t)       ; 执行 Python 代码
     (ruby . t)         ; 执行 Ruby 代码
     (js . t)           ; 执行 JavaScript 代码
     (emacs-lisp . t)   ; 执行 Emacs Lisp 代码
     (sql . t)          ; 执行 SQL 查询
     (gnuplot . t)      ; 绘制图表
     (latex . t)        ; 处理 LaTeX 公式
     (plantuml . t))    ; 绘制 UML 图
  )

(provide 'init-org)

;;; init-org.el ends here
