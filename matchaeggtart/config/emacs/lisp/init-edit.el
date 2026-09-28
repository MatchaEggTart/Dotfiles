;;; init-edit.el --- the configurations for editor -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; 括号补全
(electric-pair-mode t)

;; 是否自动缩进
;; (electric-indent-mode nil)

;; 选中内容可以直接被输入内容取代
(delete-selection-mode t)

;; 折叠代码
;; (add-hook 'prog-mode-hook 'hs-minor-mode)


;;让鼠标滚动更好用
;; (setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
;; (setq mouse-wheel-progressive-speed nil)

;; evil-nerd-commenter
;; 增强注释
;; (use-package evil-nerd-commenter
;;   :bind ("C-c C-/" . evilnc-comment-or-uncomment-lines))

;; hideshow 折叠块
(use-package hideshow
  :ensure nil  ; 内置包不需要安装
  :hook (prog-mode . hs-minor-mode)  ; 在编程模式自动启用

  :config
  ;; 基本设置
  (setq hs-hide-comments-when-hiding-all nil
	  hs-isearch-open t
	  hs-allow-nesting t)

  ;; 按键绑定 (使用 C-c h 前缀)
  (define-key hs-minor-mode-map (kbd "C-c TAB") 'hs-toggle-hiding)
  (define-key hs-minor-mode-map (kbd "C-c <left>") 'hs-hide-all)
  (define-key hs-minor-mode-map (kbd "C-c <right>") 'hs-show-all)

  ;; 自定义折叠显示样式
  (setq hs-set-up-overlay 'my-hs-overlay-display)
  (defun my-hs-overlay-display (ov)
    (when (eq 'code (overlay-get ov 'hs))
      (let* ((start (overlay-start ov))
			        (line (buffer-substring start (line-end-position)))
			        (overlay-put ov 'display (concat " ▶ " (string-trim line) " ..."))))

      ;; 语言特定配置 (Python 示例)
      (add-hook 'python-mode-hook
		    (lambda ()
		      (setq hs-special-modes-alist
			      (cons '(python-mode "\\s-*\\_<\\(class\\|def\\|if\\|for\\|while\\|with\\|try\\)\\_>"
					           nil "#"
					           hs-c-like-adjust-block-beginning)
			        hs-special-modes-alist))))

      ;; 兼容行号显示
      (with-eval-after-load 'linum
		    (add-hook 'hs-minor-mode-hook
		      (lambda () (setq-local linum-disabled t))))

      :bind (:map hs-minor-mode-map
			        ("C-c <left>" . hs-hide-all)
			        ("C-c <right>" . hs-show-all))
	    )
	  )
  )


;; crux
(use-package crux
  :bind(
		     ;; 回到第一个字符
		     ;; ("C-a" . crux-move-beginning-of-line)
		     ;; ("C-^" . crux-top-join-line)
		     ;; ("C-c I" . crux-find-user-init-file)
		     ;; 智能删除键
		     ("C-k" . crux-smart-kill-line)))

;; 删除自动清除空白位置(新)
(use-package hungry-delete
  ;; :init (global-hungry-delete-mode))
  :hook (after-init . global-hungry-delete-mode)
  )

;; 文本编辑之行/区域上下移动(新)
(use-package move-dup
  :hook (after-init . global-move-dup-mode)
  )

;; 快速切换窗格
(use-package ace-window
  ;; :config
  ;; (keymap-global-unset (kbd "M-o M-o"))
  ;; 取消这个按键，避免冲突
  ;; (global-set-key (kbd "M-o M-o") nil)
  ;; 左侧显示窗口编号
  ;; (setq ace-window-display-mode t)
  :bind
  ("M-o" . 'ace-window)
  )

;; iedit - edit same text in one buffer or region
;; (use-package iedit
;;   :bind ("C-;" . iedit-mode)
;; )

;; 块选择器
(use-package multiple-cursors
  :pin melpa
  :init
  ;; 所有命令默认对所有光标执行, 不再询问
  ;; 放 :init 里: multiple-cursors 是延迟加载的, 放 :config 的话
  ;; 在包加载前 mc/always-run-for-all 未定义, M-: 验证会 void-variable
  (setq mc/always-run-for-all t)
  ;; 清空之前误按 n 记入的 run-once 命令
  (setq mc/cmds-to-run-once nil)
  :hook
  (multiple-cursors-mode-enabled . (lambda () (corfu-mode -1)))
  (multiple-cursors-mode-disabled . (lambda () (corfu-mode 1)))
  :config
  (global-unset-key (kbd "M-<down-mouse-1>"))
  :bind
  ("C-S-c C-S-c" . 'mc/edit-lines)
  ("C->"         . 'mc/mark-next-like-this)
  ("C-<"         . 'mc/mark-previous-like-this)
  ("C-M->"       . 'mc/skip-to-next-like-this)
  ("C-M-<"       . 'mc/skip-to-previous-like-this)
  ("C-c C-<"     . 'mc/mark-all-like-this)
  ("M-<mouse-1>" . 'mc/add-cursor-on-click)
  ;; 要关闭 Fcitx5 的 C-; clipboard 快捷键
  ("C-;"         . 'mc/mark-all-symbols-like-this)
  ("C-:"         . 'mc/mark-all-symbols-like-this-in-defun)
  )

;; Increase selected region by semantic units
(use-package expand-region
  :ensure t
  :defer t
  :bind (("C-c e e" . er/expand-region)
		      ("C-c e c" . er/contract-region))
  )


(provide 'init-edit)

;; init-edit.el ends here
