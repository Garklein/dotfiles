(require 'thingatpt)

(defvar edit-var-buffers nil
  "Associates variable editing buffers with the symbol being edited.")
(defun save-var (&rest _)
  (when-let ((sym (alist-get (current-buffer) edit-var-buffers)))
    (set sym (thread-first (buffer-string) read-from-string car eval))
    (kill-buffer)
    (setq edit-var-buffers (seq-filter #'buffer-live-p edit-var-buffers)) ; also remove any killed variable editing buffers
    t)) ; don't do the normal evil-write
(advice-add #'evil-write :before-until #'save-var)

(defun variablep (symbol)
  (and (symbolp symbol) (boundp symbol) (not (keywordp symbol))))
(defun read-var-from-minibuffer ()
  (let* ((sym (symbol-at-point))
	 (v (if (variablep sym) (symbol-name sym))))
    (intern
     (completing-read
      (format-prompt "Variable to edit" v)
      obarray #'variablep t nil nil v))))

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
