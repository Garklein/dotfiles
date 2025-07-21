(message "Updating emacs packages")

(load-file "~/.emacs.d/init.el")

(straight-pull-all)
(straight-check-all)

(use-package pdf-tools
  :ensure t)
(pdf-tools-install t) ;; t so that it doesn't ask whether to rebuild and just rebuilds

(message "Done updating emacs packages")
