(message "Updating emacs packages")

(load-file "~/.emacs.d/init.el")

(straight-pull-all)
(straight-check-all)

(message "Done updating emacs packages")
