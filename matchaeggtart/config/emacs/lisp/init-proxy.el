;;; init-proxy.el --- proxy on/off settings -*- lexical-binding: t -*-

(defun proxy_on ()
  "开启代理"
  (interactive)
  (setq url-proxy-services
    '(("http" . "127.0.0.1:1080")
       ("https" . "127.0.0.1:1080")
       ("no_proxy" . "^\\(localhost\\|127.0.0.1\\)")))
  (setq socks-server '("Default server" "127.0.0.1" 1080 5))
  (message "代理已开启")
  )

(defun proxy_off ()
  "关闭代理"
  (interactive)
  (setq url-proxy-services nil)
  (setq socks-server nil)
  (message "代理已关闭")
  )

(provide 'init-proxy)
