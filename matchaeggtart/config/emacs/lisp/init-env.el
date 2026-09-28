;;; init-env.el --- the configurations for completion -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; 寻找路径的工具
;; Settings for exec-path-from-shell
;; fix the PATH environment variable issue

(defun my-exec-path-from-shell-initialize ()
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize))
  )

(use-package exec-path-from-shell
  :ensure t
  ;; :if (memq window-system '(mac ns))
  :demand t

  :init
  ;; (setq exec-path-from-shell-variables '("PATH" "MANPATH" "GOPATH"))

  :config
  (setq exec-path-from-shell-warn-duration-millis 2000)
  (add-hook 'after-init-hook 'my-exec-path-from-shell-initialize)

  ;; (exec-path-from-shell-initialize)
  ;; (with-eval-after-load 'exec-path-from-shell
  ;; (dolist (var '("PATH" "SSH_AUTH_SOCK" "SSH_AGENT_PID" "GPG_AGENT_INFO" "LANG" "LC_CTYPE" "NIX_SSL_CERT_FILE" "NIX_PATH"))
  ;; (add-to-list 'exec-path-from-shell-variables var)))
  ;; (setq exec-path-from-shell-arguments '("-l"))
  ;; (setq exec-path-from-shell-check-startup-files nil)
  ;; (setq exec-path-from-shell-debug t)
  ;; :init
  ;; (add-hook 'after-init-hook 'my-exec-path-from-shell-initialize)
  ;; (setq exec-path-from-shell-check-startup-files nil)
  )

(provide 'init-env)
;;; init-env.el ends here
