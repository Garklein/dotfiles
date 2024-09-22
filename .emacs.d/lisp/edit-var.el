;; todo: prompt with all variables (see how `describe-variable' does it)

(defvar edit-var-buffers nil
  "Associates buffers with a the symbol being edited.")
(defun save-var (&rest _)
  (when-let ((sym (alist-get (current-buffer) edit-var-buffers)))
     (let ((new-val
	    (->
	     (buffer-substring-no-properties (point-min) (point-max))
	     read-from-string car eval)))
       (set sym new-val)
       (setq edit-var-buffers (assoc-delete-all (current-buffer) edit-var-buffers))
       (kill-buffer)
       t)))
(advice-add #'evil-write :before-until #'save-var)

(defun edit-var (sym)
  (interactive "vVariable to edit: ")
  (let ((window (select-window (split-window-below)))
	(buffer (switch-to-buffer (generate-new-buffer (concat "*`" (symbol-name sym) "' editing*")))))
    (insert (concat "`" (with-output-to-string (prin1 (symbol-value sym)))))
    (fit-window-to-buffer)
    (set-window-dedicated-p window t)
    (push (cons buffer sym) edit-var-buffers)))

(provide 'edit-var)
