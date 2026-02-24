(defvar-local presentation/old-mode-line nil
  "The mode line before the presentation started")

(defun presentation/fullscreen ()
  (unbar)
  (window-configuration-to-register ?P)
  (delete-other-windows))
(defun presentation/restore-windows ()
  (jump-to-register ?P)
  (bar))

(defun start-presentation ()
  (setq presenting t)
  (set-sleep-minutes 20)
  (when (eq major-mode 'org-mode)
    (display-line-numbers-mode 0)
    (org-tree-slide-mode 1))
  (adjust-frame-transparency 83 5)

  (set-window-margins nil 5 5)
  (set-frame-font "Liberation Mono 20" nil t) ; font that supports slanting italics
  (presentation/fullscreen)
  (when (eq major-mode 'org-mode)
    (setq presentation/old-mode-line mode-line-format)
    (setq mode-line-format nil)
    ; wrap words on line breaks
    (setq-local word-wrap t)))

(defun end-presentation ()
  (setq presenting nil)
  (set-sleep-minutes 2)
  (set-window-margins nil 2 2)
  (when org-tree-slide-mode
    (org-tree-slide-mode 0)
    (setq-local word-wrap nil)
    (setq mode-line-format presentation/old-mode-line))
  (display-line-numbers-mode 1)
  (adjust-frame-transparency 0)

  (set-frame-font "Agave 10" nil t)
  ;; also restores margins
  (presentation/restore-windows))

(defvar presenting nil)
(use-package org-tree-slide
  :config
  (evil-define-key 'normal 'global (kbd "<f8>")
    (lambda () (interactive) (if presenting (end-presentation) (start-presentation))))

  ;; remap C-j and C-k (they are already bound by org-mode, so we need to do it differently)
  (define-key org-tree-slide-mode-map [remap outline-forward-same-level] 'org-tree-slide-move-next-tree)
  (define-key org-tree-slide-mode-map [remap outline-backward-same-level] 'org-tree-slide-move-previous-tree)

  (evil-define-key nil org-tree-slide-mode-map (kbd "C-;") 'org-tree-slide-content)
  (add-hook 'org-tree-slide-mode-hook
  	    (lambda ()
  	      (set-command
	       (execute-kbd-macro (read-kbd-macro "C-c C-n <tab> g g")))))

  ;; skip non-top-level headings
  (setq org-tree-slide-skip-outline-level 2)

  (setq org-tree-slide-slide-in-effect nil)
  (setq org-tree-slide-activate-message "")
  (setq org-tree-slide-deactivate-message "")
  (setq org-tree-slide-content-margin-top 1)
  (setq org-tree-slide-indicator '(:next "" :previous "" :content "")))

(provide 'presentation)
