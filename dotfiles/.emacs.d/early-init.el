;; make emacs start up faster
(defun restore-gc-cons-threshold ()
  (setq gc-cons-threshold (* 16 1024 1024)
	gc-cons-percentage 0.1))

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)
(add-hook 'emacs-startup-hook #'restore-gc-cons-threshold 105)

;; don't run regexps against filenames on .el and .elc files
(setq default-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(defun reset-file-name-handler-alist ()
  (setq file-name-handler-alist
	(append default-file-name-handler-alist
		file-name-handler-alist))
  (cl-delete-duplicates file-name-handler-alist :test 'equal))
(add-hook 'after-init-hook #'reset-file-name-handler-alist)
