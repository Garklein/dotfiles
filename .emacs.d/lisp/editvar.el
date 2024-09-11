(defun edit-var (sym)
  (interactive "vVariable to edit: ")
  (let ((window (select-window (split-window-below)))
	(buffer (switch-to-buffer (generate-new-buffer (concat "*`" (symbol-name sym) "' editing*")))))
    (insert (format "%s" (symbol-value sym)))
    (fit-window-to-buffer)
    (set-window-dedicated-p window t)
    (defun save-var ()
      (when (equal (current-buffer) buffer)
	(with-current-buffer buffer
	  (let ((new-val
		 (->
		  (buffer-substring-no-properties (point-min) (point-max))
		  read-from-string car eval)))
	    (set sym new-val)
	    ; remove advice
	    ; kill window
	    (kill-buffer)))))
    ; add advice
    ))

(defvar test)
(setq test '(1 2 3))
(provide 'editvar)
