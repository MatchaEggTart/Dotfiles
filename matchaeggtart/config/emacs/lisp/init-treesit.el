;;; init-treesit.el --- the configurations for treesit -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; (use-package tree-sitter
;;   :config
;;   ;; (global-tree-sitter-mode)
;;   (tree-sitter-require 'c)
;;   (tree-sitter-require 'typescript)
;;
;;   )
;;
;; (use-package tree-sitter-langs
;;   )


(with-eval-after-load 'treesit
  ;; 1. 修正 treesit-query-capture 的 advice，去掉 message 提示，实现完全静音
  (advice-add 'treesit-query-capture :around
	  (lambda (orig-fun &rest args)
		  (condition-case nil
		    (apply orig-fun args)
		    (treesit-query-error nil))))

  ;; 2. 针对 Emacs 30 内置 C 模式的硬核修理
  ;; 直接从根源上移除 c-ts-mode 中那些会导致错误的定义
  ;;   (advice-add 'treesit-query-compile :around
  ;;     (lambda (orig-fun lang query &optional eager)
  ;;       (let ((clean-query query))
  ;;         (when (and (eq lang 'c) (stringp query))
  ;;           ;; 依次移除报错频率最高的几个坏规则
  ;;           (setq clean-query (replace-regexp-in-string "((declaration type: (macro_type_specifier name: (identifier) @_name) @for-each-tail) (#match \"FOR_EACH_\\\\(?:ALIST_VALUE\\\\|FRAME\\\\|LIVE_BUFFER\\\\|TAIL\\\\(?:_SAFE\\\\)?\\\\)\" @_name))" "" clean-query))
  ;;           (setq clean-query (replace-regexp-in-string "((call_expression (call_expression function: (identifier) @fn) @c-ts-mode--fontify-DEFUN) (#match \"\\\\`DEFUN\\\\'\" @fn))" "" clean-query)))
  ;;         (apply orig-fun lang clean-query eager))))
  )

(use-package treesit-auto
  :demand t
  :init
  (setq treesit-language-source-alist
	  '(
	     (c						. ("https://github.com/tree-sitter/tree-sitter-c"))
	     (cpp        	. ("https://github.com/tree-sitter/tree-sitter-cpp"))
	     (bash       	. ("https://github.com/tree-sitter/tree-sitter-bash"))
	     (elisp      	. ("https://github.com/Wilfred/tree-sitter-elisp"))
	     (html       	. ("https://github.com/tree-sitter/tree-sitter-html"))
	     (css        	. ("https://github.com/tree-sitter/tree-sitter-css"))
	     (javascript 	. ("https://github.com/tree-sitter/tree-sitter-javascript"))
	     (typescript 	. ("https://github.com/tree-sitter/tree-sitter-typescript" nil "typescript/src"))
	     (tsx	      	. ("https://github.com/tree-sitter/tree-sitter-typescript" nil "tsx/src"))
	     (json	      . ("https://github.com/tree-sitter/tree-sitter-json"))
	     (org	      	. ("https://github.com/milisims/tree-sitter-org"))
	     (yaml	      . ("https://github.com/ikatyang/tree-sitter-yaml"))
	     ;; pipx install python-lsp-server
	     (python 			. ("https://github.com/tree-sitter/tree-sitter-python"))
	     (lua         . ("https://github.com/MunifTanjim/tree-sitter-lua"))

	     ;; markdown-ts-mode 需要 markdown + markdown-inline 两个语法库。
	     ;; 平时由系统包 tree-sitter-markdown 提供 (直接装在 /usr/lib),
	     ;; 这里补上配方只是为了 M-x markdown-ts-mode-install-parsers
	     ;; 有东西可编译; 两个 grammar 在同一个仓库的不同 src 目录里。
	     ;; 上游 markdown-ts-mode 钉了具体 commit, 这里沿用本列表其他
	     ;; 条目的写法用默认分支; 哪天 HEAD 不兼容再改成钉版本。
	     (markdown        . ("https://github.com/tree-sitter-grammars/tree-sitter-markdown" nil "tree-sitter-markdown/src"))
	     (markdown-inline . ("https://github.com/tree-sitter-grammars/tree-sitter-markdown" nil "tree-sitter-markdown-inline/src"))
	     ))
  :mode
  (
    ("\\.c\\'"        . c-ts-mode)
    ("\\.go\\'" 			. go-ts-mode)
    ("/go\\.mod\\'" 	. go-mod-ts-mode)
    ("\\.rs\\'" 			. rust-ts-mode)
    ("\\.js\\'" 			. js-ts-mode)
    ("\\.ts\\'" 			. typescript-ts-mode)
    ("\\.json\\'" 		. json-ts-mode)
    ("\\.jsonc\\'" 		. json-ts-mode)
    ;; ("\\.tsx\\'" 	. typescript-ts-mode)
    ("\\.tsx\\'" 			. tsx-ts-mode)
    ("\\.y[a]?ml\\'" 	. yaml-ts-mode)
    ("\\.com\\'" 			. nginx-mode)
    ;; ("\\.html\\'" 	. tsx-ts-mode)
    ;; ("\\.sh\\'" 		. bash-ts-mode)
    ("\\.py\\'" 			. python-ts-mode)
    ("\\.lua\\'"      . lua-ts-mode)
    )

  :config
  (setq treesit-auto-install 'prompt)
  (global-treesit-auto-mode)
  (add-to-list 'treesit-extra-load-path "~/.config/emacs/tree-sitter")

  ;; (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
  ;; 更多高亮
  ;; (setq treesit-font-lock-level 4)
  (setq treesit-font-lock-level 4)

  ;; 缩进
  ;; 使用空格代替 Tab
  ;; (setq-default indent-tabs-mode nil)
  ;; 默认缩进
  (setq-default tab-width 2)
  (setq-default indent-tabs-mode nil) ; Ensures spaces are used for indentation instead of tabs

  ;; lisp
  (setq lisp-indent-offset 2)

  ;; c
  (setq c-ts-mode-indent-offset 4)

  ;; js ts
  ;; (setq js-ts-mode-indent-offset 2)
  (setq js-indent-level 2)
  (setq tsx-ts-mode-indent-offset 2)

  ;; json
  (setq json-ts-mode-indent-offset 2)

  ;; ts
  (setq typescript-ts-mode-indent-offset 2)
  (setq tsx-ts-mode-indent-offset 2)

  ;; python
  (setq python-indent-offset 2)

  ;; nginx
  (with-eval-after-load 'nginx-mode
    (setq nginx-indent-level 4))
  )


(provide 'init-treesit)

;;; init-treesit.el ends here
