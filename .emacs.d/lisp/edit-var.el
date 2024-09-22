(defun edit-var (sym)
  (interactive "vVariable to edit: ")
  (let ((window (select-window (split-window-below)))
	(buffer (switch-to-buffer (generate-new-buffer (concat "*`" (symbol-name sym) "' editing*")))))
    (insert (format "%s" (symbol-value sym))) ;; todo fix
    (fit-window-to-buffer)
    (set-window-dedicated-p window t)

    (defun save-var (_ &optional _)
      (when (equal (current-buffer) buffer)
	(let ((new-val
	       (->
		(buffer-substring-no-properties (point-min) (point-max))
		read-from-string car eval)))
	  (set sym new-val)
	  (advice-remove #'evil-save #'save-var)
	  (delete-window window)
	  (kill-buffer)
	  t)))
    (advice-add #'evil-save :before-until #'save-var)))

(provide 'edit-var)
