;;; init-dired.el --- the configurations for dired -*- lexical-binding: t -*-

(use-package dired
  :ensure nil
  :bind (("C-x C-j" . dired-jump)
          :map dired-mode-map
          ("<backspace>" . dired-up-directory)
          ("<tab>" . dired-subtree-toggle)
	        )
  :config
  ;; 1. 通过 ls 参数确保对齐
  (setq dired-listing-switches "-lAgho --group-directories-first --time-style=long-iso")

  (setq dired-dwim-target t
	  delete-by-moving-to-trash t)
  ;; 开启 Dired 详情隐藏（默认只看文件名，按 ( 切换）
  ;; (add-hook 'dired-mode-hook 'dired-hide-details-mode)

  ;; 如果是 Linux 用户，解决 ls 参数报错问题
  ;; (when (string= system-type "gnu/linux")
  ;;   (setq dired-use-ls-dired t))

  ;; 解决 dired-subtree 展开时图标不刷新的问题
  (with-eval-after-load 'dired-subtree
    (advice-add 'dired-subtree-insert :after #'nerd-icons-dired-mode))

  )

;; 左侧树状
(use-package dired-sidebar
  :ensure t
  :bind (
          ("C-c d" . dired-sidebar-toggle-sidebar)
          :map dired-sidebar-mode-map
	        ("<backspace>" . dired-sidebar-up-directory)
          )
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
	  (lambda ()
	    (unless (file-remote-p default-directory)
	 	    (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)

  ;; (setq dired-sidebar-subtree-line-prefix "__")
  ;; (setq dired-sidebar-theme 'vscode)
  (setq dired-sidebar-theme 'nerd-icons)
  ;; (setq dired-sidebar-use-term-integration t)
  ;; (setq dired-sidebar-use-custom-font t)
  )

;; 颜色高亮
(use-package diredfl
  :ensure t
  :hook (dired-mode . diredfl-mode)
  )

(use-package nerd-icons-dired
  :pin melpa
  :ensure t
  :hook (dired-mode . nerd-icons-dired-mode)
  )

(provide 'init-dired)
