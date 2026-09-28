;;; init-temp.el --- temporary configurations -*- lexical-binding: t -*-

;; 打开配置文件
(defun open-my-config ()
  (interactive)
  (dired "~/.config/emacs/lisp/"))

(global-set-key (kbd "<f6>") 'open-my-config)

;; 打开最近文件
;; 显示最近编辑过的文件
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-item 10)
(global-set-key (kbd "<f7>") 'recentf-open-files)

;; 打开 Worpspace
(defun open-workspace()
  (interactive)
  (dired "~/Workspace/"))

(global-set-key (kbd "<f8>") 'open-workspace)

;; 查找函数
(global-set-key (kbd "C-h C-f") 'find-function)
;; 查找变量
(global-set-key (kbd "C-h C-v") 'find-variable)
;; 查找按键
(global-set-key (kbd "C-h C-k") 'find-function-on-key)

;; 系统自带的提示功能
;;(setq tab-always-indent 'complete)
;; M-x 有补全
;; (icomplete-mode t)

;; 开启行号
(global-display-line-numbers-mode t)

;; 括号补全
(electric-pair-mode t)

;; 自动最大化
(toggle-frame-maximized)

;; 关闭工具栏，tool-bar-mode 即为一个 Minor Mode
(tool-bar-mode 0)

;; 关闭 menu-bar
(menu-bar-mode 0)

;; 关闭文件滑动控件
(scroll-bar-mode 0)

;; 改变光标模式
;; (setq cursor-type 'box)
(setq-default cursor-type 'bar)

;; 键盘提示
(use-package keycast
  :hook
  (after-init . keycast-mode)
  )

;; 选中内容可以直接被输入内容取代
(delete-selection-mode t)

;; 高亮当前行号
(global-hl-line-mode 1)

;; 主题
;;; For packaged versions which must use `require'.
(use-package modus-themes
  :init
  (require-theme 'modus-themes)
  :config
  ;; Add all your customizations prior to loading the themes
  (setq modus-themes-italic-constructs t
    modus-themes-bold-constructs nil)

  ;; Maybe define some palette overrides, such as by using our presets
  (setq modus-themes-common-palette-overrides
    modus-themes-preset-overrides-intense)

  ;; Load the theme of your choice.
  (load-theme 'modus-operandi-tinted)

  ;; (define-key global-map (kbd "<f5>") #'modus-themes-toggle)
  )

(provide 'init-temp)
