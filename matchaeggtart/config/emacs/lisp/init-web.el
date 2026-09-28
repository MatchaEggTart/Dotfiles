;;; init-web.el --- the configurations for completion -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; emmet
;; meta:vp ctrl-j
;; (use-package emmet-mode

;;   )

(use-package emmet-mode
  :ensure t
  :hook ((
 		       ;;sgml-mode-hook
 		       html-mode-hook
 		       ;; web-mode-hook
 		       css-mode-hook
 		       tsx-ts-mode-hook
		       ) . emmet-mode)
  :bind (("C-j" . emmet-expand-line))
  :config
  (setq emmet-indent-after-insert nil
    emmet-indentation 2)
  )

;; JSONRPC
;; (use-package jsonrpc
;;   :ensure t)

(use-package web-mode
  :ensure t
  :custom
  (web-mode-enable-current-element-highlight t)
  (web-mode-enable-current-column-highlight t)
  :mode (("\\.html\\'" . web-mode)
          ("\\.html.eex\\'" . web-mode)
          ("\\.html.leex\\'" . web-mode)
          ("\\.hbs\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2)
  )

;; (use-package web-mode
;;   :ensure t
;;   :mode
;;   (
;;    ;; ("\\.phtml\\'" . web-mode)
;;    ;; ("\\.php\\'" . web-mode)
;;    ;; ("\\.tpl\\'" . web-mode)
;;    ;; ("\\.[agj]sp\\'" . web-mode)
;;    ;; ("\\.as[cp]x\\'" . web-mode)
;;    ;; ("\\.erb\\'" . web-mode)
;;    ;; ("\\.mustache\\'" . web-mode)
;;    ;; ("\\.djhtml\\'" . web-mode)
;;    ("\\.html\\'" . web-mode)
;;    )
;;   :config
;;   (setq web-mode-markup-indent-offset 2)
;;   )

;; JSON
;;(use-package json-mode
;;  :ensure t
;;  :mode
;;  (
;;	("\\.json\\'" . json-mode)
;;	("\\.jsonc\\'" . json-mode)
;;	)
;;  :config
;;  (setq js-indent-level 2)
;;  )

;; CONF-MODE
(use-package nginx-mode
  :ensure t
  :mode
  (
	  ("config\\'" . nginx-mode)      ; 匹配以 config 结尾的文件 (如 nginx.config)
	  ("\\.conf\\'" . nginx-mode)     ; 匹配 .conf 结尾的文件
	  )
  :config
  (setq nginx-indent-level 2)
  )

;; Major mode for editing YAML files
(use-package yaml-mode
  :ensure t
  ;; :straight t
  :mode (("\\.\\(yml\\|yaml\\)\\'" . yaml-mode)
          ("Procfile\\'" . yaml-mode))
  )


;; Parser-aided YAML editing features
(use-package yaml-pro
  :ensure t
  ;; :straight t
  ;; :when (+emacs-options-p 'tree-sitter)
  :hook (yaml-mode . yaml-pro-mode)
  :hook (yaml-ts-mode . yaml-pro-ts-mode)
  )

(provide 'init-web)
;;; init-web.el ends here
