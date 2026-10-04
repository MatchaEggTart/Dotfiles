;;; init-develop.el --- the configurations for devloper -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; 自动补全(新)
;; (use-package company
;;  :hook (after-init . global-company-mode)
;;  :config
;;  (setq
;;   company-minimum-prefix-length 1
;;   ;; 补全时间等待
;;   company-idle-delay 0
;;   company-show-quick-access t)
;;  :bind (:map company-active-map
;;              ("C-n" . 'company-select-next)
;; 	      ("C-p" . 'company-select-previous))
;;  )

;; 新的补全
(use-package corfu
  :hook (after-init . global-corfu-mode)
  ;; :init
  :config
  (progn
    (setq corfu-auto t)
    (setq corfu-cycle t)
    (setq corfu-quit-at-boundary t)
    (setq corfu-quit-no-match t)
    (setq corfu-preview-current nil)
    ;; (setq corfu-min-width 80)
    ;; (setq corfu-max-width 100)
    (setq corfu-auto-delay 0.1)
    (setq corfu-auto-prefix 1)
    (setq corfu-on-exact-match nil)
    (setq text-mode-ispell-word-completion nil)
    ;; sh-mode 文件补全时末尾不要自动加空格 (comint 后端的行为)
    ;; 补全路径后可直接输入 / 进子目录; 想加空格做参数分隔时按 SPC
    ;; (setq comint-completion-addsuffix nil)
    )
  )

;; 输入补充
(use-package yasnippet
  :hook ((prog-mode . yas-minor-mode)
	        (org-mode . yas-minor-mode))
  :init
  :config
  (progn
    (setq hippie-expand-try-functions-list
	    '(yas/hippie-try-expand
	       try-complete-file-name-partially
	       try-expand-all-abbrevs
	       try-expand-dabbrev
	       try-expand-dabbrev-all-buffers
	       try-expand-dabbrev-from-kill
	       try-complete-lisp-symbol-partially
	       try-complete-lisp-symbol)))
  )

(use-package yasnippet-snippets
  :after yasnippet
  )

;; 自带的查错神器喔
;; flymake
(use-package flymake
  :config
  ;; (require 'flymake-jslint)
  ;; (add-hook 'js-mode-hook 'flymake-jslint-load)
  ;; :hook (prog-mode . flymake-mode)
  :bind (("M-n" . #'flymake-goto-next-error)
 	        ("M-p" . #'flymake-goto-prev-error))
  )

;; 快速运行代码
(use-package quickrun
  :commands (quickrun)
  :init
  (quickrun-add-command "c++/c1z"
    '((:command . "g++")
       (:exec . ("%c -std=c++1z %o -o %e %s"
		              "%e %a"))
       (:remove . ("%e")))
    :default "c++")
  ;; You can override existing command
  (quickrun-add-command "c/gcc"
    '((:exec . ("%c -std=c++1z %o -o %e %s"
		             "%e %a")))
    :override t)
  :config
  (global-set-key (kbd "<f5>") 'quickrun)

  ;; 让 quickrun 的输出固定出现在底部一条 side window, 不再"看心情"乱跳。
  ;; quickrun 内部只调 pop-to-buffer, 窗口由 display-buffer 决定;
  ;; display-buffer-alist 是通用的"把某个 buffer 钉到指定位置"机制。
  (add-to-list 'display-buffer-alist
               '("\\`\\*quickrun\\*\\'"
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (slot . 0)
                 (window-height . 0.30)))

  ;; 跑完不把光标从代码窗口抢走 (想跳过去就删掉这行)
  (setq quickrun-focus-p nil)
  )

;; format-all-the-code
(use-package format-all
  :ensure t
  :commands format-all-mode
  :hook (prog-mode . format-all-mode)
  :config
  (setq-default format-all-formatters
    '(("C"     (astyle "--mode=c"))
       ("Shell" (shfmt "-i" "4" "-ci"))
		   ))
  :bind ("C-c f" . #'format-all-region-or-buffer)
  )

(provide 'init-develop)

;;; init-develop.el ends here
