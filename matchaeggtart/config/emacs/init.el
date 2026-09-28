;;; init.el --- initial of the configurations -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; 先设置加载的目标目录到 load-path 中
(add-to-list 'load-path
	(expand-file-name (concat user-emacs-directory "lisp")))


;; update load-path to make customized lisp codes work
;; (dolist (folder (directory-files (concat user-emacs-directory "lisp") t directory-files-no-dot-files-regexp))
;;   (add-to-list 'load-path folder))

(require 'init-basic)
(require 'init-system)
(require 'init-proxy)
(require 'init-elpa)
(require 'init-env)
(require 'init-keybindings)
(require 'init-dired)
(require 'init-ui)
(require 'init-search)
(require 'init-edit)
(require 'init-develop)
(require 'init-org)
(require 'init-markdown)
(require 'init-web)
(require 'init-eglot)
(require 'init-treesit)
(require 'init-shell)
;; (require 'init-dired)

;; (require 'init-temp)

;;; init.el ends here
(put 'dired-find-alternate-file 'disabled nil)
