;;; init-keybindings.el --- customize key -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; y 和 n 取代 yes 和 no
;; (defalias 'yes-or-no-p 'y-or-n-p)
(fset 'yes-or-no-p 'y-or-n-p)

;; 查询三按键
;; (global-set-key (kbd "C-h C-f") 'view-emacs-FAQ)
;; 查找函数
(global-set-key (kbd "C-h C-f") 'find-function)
;; 查找变量
(global-set-key (kbd "C-h C-v") 'find-variable)
;; 查找按键
(global-set-key (kbd "C-h C-k") 'find-function-on-key)

;; 查找项目文件快捷键
(global-set-key (kbd "C-x p f") 'project-find-file)

;; 调整窗口
;; = C-x ^
(global-set-key (kbd "C-c C-<up>") 'enlarge-window)
;; = C-x {
(global-set-key (kbd "C-c C-<left>") 'shrink-window-horizontally)
;; = C-x }
(global-set-key (kbd "C-c C-<right>") 'enlarge-window-horizontally)

;; facemenu-keymap M-o

;; (define-key map )
;; (setq facemenu-keymap nil)
;; (defvar facemenu-keymap nil)
;; (define-key [C-c o] 'facemenu-keymap)
;; (global-set-key (kbd "C-c o") 'facemenu-keymap)

;; 打开 init.el 文件
(defun open-init-file()
  (interactive)
  (find-file (concat user-emacs-directory "init.el"))
  )

(global-set-key (kbd "<f6>") 'open-init-file)

;; 打开配置文件
(defun open-config-folder()
  (interactive)
  (dired "~/.config/emacs/lisp/")
  )

(global-set-key (kbd "<f7>") 'open-config-folder)

;; 打开最近文件
;; 显示最近编辑过的文件
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-item 10)

(global-set-key (kbd "<f8>") 'recentf-open-files)

;; 打开 Worpspace
(defun open-workspace()
  (interactive)
  (dired "$HOME/Workspace/")
  )

(global-set-key (kbd "<f9>") 'open-workspace)


(provide 'init-keybindings)

;;; init-keybindings.el ends here
