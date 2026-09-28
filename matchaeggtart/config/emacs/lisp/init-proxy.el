;;; init-proxy.el --- proxy on/off settings -*- lexical-binding: t -*-

(defun proxy-on ()
  "开启代理"
  (interactive)
  (setq url-proxy-services
    '(("http" . "127.0.0.1:1080")
       ("https" . "127.0.0.1:1080")
       ("no_proxy" . "^\\(localhost\\|127.0.0.1\\)")))
  (setq socks-server '("Default server" "127.0.0.1" 1080 5))
  (message "PROXY ON ON ON")
  )

(defun proxy-off ()
  "关闭代理"
  (interactive)
  (setq url-proxy-services nil)
  (setq socks-server nil)
  (message "PROXY OFF OFF OFF")
  )

(provide 'init-proxy)
