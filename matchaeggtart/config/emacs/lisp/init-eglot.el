;;; Init-eglot.el --- the configurations for completion -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; Language Server (eglot - builtin since v29)
(use-package eglot
  :bind ("C-c e f" . eglot-format)
  :init
  ;; 又想虾鸡巴格式化
  ;; (advice-add 'eglot-code-action-organize-imports :before #'eglot-format-buffer)
  ;; (add-hook 'eglot-managed-mode-hook (lambda () (add-hook 'before-save-hook #'eglot-format-buffer)))
  (add-hook 'prog-mode-hook
	  (lambda () (unless (member major-mode '(emacs-lisp-mode))
				         (eglot-ensure)))
	  )
  :config
  (progn

    ;; HTML
    ;; npm i -g vscode-langservers-extracted
    ;; (add-to-list 'eglot-server-programs '((html-mode web-mode) "tailwindcss-language-server" "--stdio"))
    (add-to-list 'eglot-server-programs '((html-mode web-mode) "vscode-html-language-server" "--stdio"))

    (add-to-list 'eglot-server-programs '((sh-mode bash-ts-mode) . ("bash-language-server" "start")))

	  (add-to-list 'eglot-server-programs
      '((typescript-ts-mode tsx-ts-mode)
         . ("typescript-language-server" "--stdio")))
    ;; (add-to-list 'eglot-server-programs '((sql-mode). ("sql-language-server" "up --method stdio")))
    )
  )

(use-package eldoc-box
  :ensure t
  :custom
  ;; remove child frame as soon as cursor moves to another position
  (eldoc-box-cleanup-interval 0)
  )

(provide 'init-eglot)
;;; init-eglot.el ends here
