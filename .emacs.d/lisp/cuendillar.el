(defun cuendillar/fullscreen ()
  (window-configuration-to-register ?W)
  (delete-other-windows))
(defun cuendillar/restore-windows ()
  (jump-to-register ?W))

(defvar cuendillar/password ""
  "The password being typed.")

(defun cuendillar/check-password (pass)
  (let ((correct-hash
	 (shell-command-to-string "sudo getent shadow gator | cut -d: -f2"))
	(entered-hash
	 (shell-command-to-string
	  (concat "openssl passwd -6 -salt $(sudo getent shadow gator | cut -d$ -f3) '" pass "'"))))
    (equal correct-hash entered-hash)))

(defconst cuendillar/combinators
  '("λx.x"
    "λx.λy.x"
    "λx.λy.λz.xz(yz)"
    "λx.λy.λz.x(yz)"
    "λx.λy.λz.xzy"
    "λx.λy.xyy"
    "(λx.xx)(λx.xx)"
    "λf.(λx.f(xx))(λx.f(xx))"))

;; we want each keystroke's text to be different than the one before
(defvar cuendillar/text ""
  "The currently displayed text")
(defun cuendillar/get-text ()
  (let* ((idx (random (length cuendillar/combinators)))
  	 (text (nth idx cuendillar/combinators)))
    (if (equal text cuendillar/text)
  	(cuendillar/get-text)
      (setq cuendillar/text text)
      text)))

(defun cuendillar/string-pixel-width (s)
  (let ((old (buffer-substring-no-properties (point-min) (point-max))))
    (erase-buffer)
    (insert s)
    (prog1
	(car (window-text-pixel-size))
      (erase-buffer)
      (insert old))))

(defun cuendillar/insert-centre (s)
  (let* ((w (- (window-body-width nil t) (* 2 (car (window-text-pixel-size nil 1 2)))))
	 (left-spacing (/ (- w (cuendillar/string-pixel-width s)) 2))
	 (h (window-body-height nil t))
	 (lheight (/ (- h (line-pixel-height)) 2)))
    (insert "\n")
    (add-text-properties 1 2 `(line-height ,lheight))
    (insert (concat " " s))
    (add-display-text-property 2 3 'display `(space . (:width (,left-spacing))))))

(defun cuendillar/update ()
  (when (eq major-mode 'cuendillar-mode)
    (erase-buffer)
    (unless (equal cuendillar/password "")
      (cuendillar/insert-centre (cuendillar/get-text)))))

(defun cuendillar/clear ()
  (interactive)
  (setf cuendillar/password "")
  (cuendillar/update))

(defun cuendillar/backspace ()
  (interactive)
  (unless (equal cuendillar/password "")
    (setq cuendillar/password (substring cuendillar/password 0 -1)))
  (cuendillar/update))

(defun cuendillar/return ()
  (interactive)
  (when (cuendillar/check-password cuendillar/password)
    (cuendillar/unlock))
  (cuendillar/clear))

(defvar-keymap cuendillar-mode-map
  "<escape>" #'cuendillar/clear
  "<backspace>" #'cuendillar/backspace
  "<return>" #'cuendillar/return)
(dolist (char (number-sequence 0 127))
  (when (or (aref printable-chars char)
	    (= char ?\t))
    (keymap-set cuendillar-mode-map
		(key-description (char-to-string char))
		`(lambda () (interactive)
		  (setq cuendillar/password
			(concat cuendillar/password (list ,char)))
		  (cuendillar/update)))))

(defvar old-overriding-terminal-local-map nil
  "The overriding terminal local map that was used before the lock.")
(defvar old-overriding-local-map nil
  "The overriding local map that was used before the lock.")
(defvar old-global-map nil
  "The global map that was used before the lock.")

(defun noop (&rest _))
(define-derived-mode cuendillar-mode fundamental-mode "Cuendillar"
  "Lock Emacs."
  (setf old-global-map global-map)
  (use-global-map (make-sparse-keymap))
  (setf old-overriding-local-map overriding-local-map
	overriding-local-map cuendillar-mode-map
	old-overriding-terminal-local-map overriding-terminal-local-map
	overriding-terminal-local-map nil)
  (setq mode-line-format nil)
  (display-line-numbers-mode 0)
  (setq show-trailing-whitespace nil)
  (setq cursor nil)
  (face-remap-add-relative 'default '(:height 1000))
  (face-remap-add-relative 'show-paren-match '(:underline nil))
  ;; evil messes with the cursor so need to special case it
  (setq-local evil-normal-state-cursor '(bar . 0))
  (advice-add #'message :override #'noop)
  (cuendillar/clear))

(defun lock ()
  (interactive)
  (cuendillar/fullscreen)
  (switch-to-buffer (get-buffer-create "*cuendillar*"))
  (cuendillar-mode)
  (clean-mode))

(defun cuendillar/unlock ()
  (kill-buffer (get-buffer-create "*cuendillar*"))
  (cuendillar/restore-windows)
  (use-global-map old-global-map)
  (advice-remove #'message #'noop)
  (setf overriding-local-map old-overriding-local-map
	overriding-terminal-local-map old-overriding-terminal-local-map))

(provide 'cuendillar)
