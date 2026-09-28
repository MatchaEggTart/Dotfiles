;;; init-basic.el --- the configurations neednot packages -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; 编码问题(新)
(prefer-coding-system 'utf-8)
;; (unless *is-windows*
(set-selection-coding-system 'utf-8)

;; Encore UTF-8
;; (set-language-environment "UTF-8")
;; (setq default-buffer-file-coding-system 'UTF-8)
;; (prefer-coding-system 'utf-8)

;; No Backup
(setq make-backup-files nil)
(setq auto-save-default nil)

;; 将 custom 数据放在 custom.el 文件里
;; (message user-emacs-directory)
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'no-error 'no-message)

;; 关闭提示音
(setq ring-bell-function 'ignore)

;; 关闭打开软链接每次询问
(setq vc-follow-symlinks t)   ; 总是 follow，不再询问（推荐）
;; (setq vc-follow-symlinks nil)  ; 从不 follow，保留软链接路径
;; (setq vc-follow-symlinks 'ask) ; 默认，每次都问

(provide 'init-basic)

;;; init-basic.el ends here
