;;; init-shell.el --- the configurations for shell -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; Settings for exec-path-from-shell
;; fix the PATH environment variable issue
;; (use-package exec-path-from-shell
;;   :defer nil
;;   :when (or (memq window-system '(mac ns x))
;;             (unless (memq system-type '(windows-nt dos))
;;               (daemonp)))
;;   :init (exec-path-from-shell-initialize))


(use-package vterm
  :pin melpa
  ;; 教程 https://www.5axxw.com/wiki/content/aqagqc
  :bind
  ("C-c t" . vterm)
  ;; vterm-copy-mode，默认使用 C-c C-t
  :config

  )

;; :confit (display-line-numbers-mode nil))
;;  )

;; .zshrc or .bashrc
;; vterm_printf() {
;;     if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ]); then
;;         # Tell tmux to pass the escape sequences through
;;         printf "\ePtmux;\e\e]%s\007\e\\" "$1"
;;     elif [ "${TERM%%-*}" = "screen" ]; then
;;         # GNU screen (screen, screen-256color, screen-256color-bce)
;;         printf "\eP\e]%s\007\e\\" "$1"
;;     else
;;         printf "\e]%s\e\\" "$1"
;;     fi
;; }

(provide 'init-shell)

;;; init-shell.el ends here
