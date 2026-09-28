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

(provide 'init-basic)

;;; init-basic.el ends here
