;;; init-elpa.el --- the configurations for install packages -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; 配置源
;; (message package-archives)
(use-package package
  :config
  (add-to-list 'package-archives '("melpa" 				. "https://melpa.org/packages/"))
  (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
  (add-to-list 'package-archives '("gnu" 					. "https://elpa.gnu.org/packages/")) ;; installed by default
  (add-to-list 'package-archives '("gnu-devel" 		. "https://elpa.gnu.org/devel/"))
  (add-to-list 'package-archives '("nongnu" 			. "https://elpa.nongnu.org/nongnu/")) ;; installed by default from Emacs 28 onwards
  ;; (add-to-list 'package-archives '("nongnu-devel" . "https://elpa.nongnu.org/devel/"))
  ;; (add-to-list 'package-archives '("org" 					. "https://mirrors.ustc.edu.cn/elpa/org/"))

  (unless (bound-and-true-p package--initialized)
    (package-initialize))
  (progn
    ;; 不检查签名，国内镜像如果正在同步，会导致安装签名失败
    (setq package-check-signature nil
      load-prefer-newer t)
    ;; 防止反复调用 package-refresh-contents 会影响加载速度
    (when (not package-archive-contents)
      (package-refresh-contents)))
  )

;; 配置 use-package 默认设置
(require 'use-package-ensure)

(setq use-package-always-ensure t
  use-package-always-defer t
  use-package-always-demand nil
  use-package-expand-minimally t
  use-package-verbose t)

;; 默认使用 melpa-stable
(setq use-package-always-pin "melpa-stable")
;; (setq use-package-always-pin "nongnu")

;; 装完插件的重启工具
(use-package restart-emacs)

(provide 'init-elpa)

  ;;; init-elpa.el ends here
