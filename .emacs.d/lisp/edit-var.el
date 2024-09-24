(require 'help-fns)

(defvar edit-var-buffers nil
  "Associates buffers with a the symbol being edited.")
(defun save-var (&rest _)
  (when-let ((sym (alist-get (current-buffer) edit-var-buffers)))
    (set sym (-> (buffer-string) read-from-string car eval))
    (kill-buffer)
    (setq edit-var-buffers (seq-filter #'buffer-live-p edit-var-buffers)) ; also remove orphaned buffers
    t)) ; don't do the normal evil-write
(advice-add #'evil-write :before-until #'save-var)

;; stolen from `describe-variable'
(defun read-var-from-minibuffer ()
  (let* ((v (variable-at-point))
	 (inputted-var
	  (completing-read
	   (format-prompt "Variable to edit" (and (symbolp v) v))
	   #'help--symbol-completion-table
	   (lambda (sym)
	     (or (get sym 'variable-documentation)
		 (and (not (keywordp sym))
		      (buffer-local-boundp sym (current-buffer)))))
	   t nil nil
	   (if (symbolp v) (symbol-name v)))))
    (intern inputted-var)))

(defun edit-var (sym)
  (interactive (list (read-var-from-minibuffer)))
  (let ((window (select-window (split-window-below)))
	(buffer (switch-to-buffer (generate-new-buffer (format "*`%s' editing" sym)))))
    (emacs-lisp-mode)
    (insert (concat "`" (prin1-to-string (symbol-value sym))))
    (goto-char 2)
    (fit-window-to-buffer)
    (set-window-dedicated-p window t)
    (push (cons buffer sym) edit-var-buffers)))

(provide 'edit-var)
