;;;###theme-autoload
(deftheme quiet
  "Minimal highlighting"
  :background-mode 'dark
  :kind 'color-scheme)

(let* ((class '((class color) (min-colors 89)))
       (default `((,class (:background "#242424" :foreground "#f6f3e8"))))
       (highlight `((,class (:background "#595959"))))
       (string `((,class (:foreground "#f9c8ac"))))
       (comment `((,class (:foreground "#799cfc")))))
  (custom-theme-set-faces
   'quiet

   ;; Highlighting faces
   `(cursor ((,class (:background "#b7b7b7"))))
   `(highlight ,highlight)
   `(region ,highlight)
   `(secondary-selection ,highlight)
   `(isearch ,highlight)
   `(lazy-highlight ,highlight)

   ;; Mode line faces
   `(mode-line ((,class (:foreground "#f6f3e8" :overline t))))
   `(mode-line-inactive ((,class (:foreground "#857b6f"))))
   `(header-line ,default)
   `(window-divider ((,class (:foreground "#242424"))))
   `(window-divider-first-pixel ((,class (:foreground "#242424"))))
   `(window-divider-last-pixel ((,class (:foreground "#242424"))))

   ;; Font lock faces
   `(font-lock-comment-face ,comment)
   `(font-lock-comment-delimiter-face ,comment)
   `(font-lock-string-face ,string)
   `(font-lock-warning-face ,string)
   `(font-lock-doc-face ,string)
   `(line-number ((,class (:foreground "grey60"))))
   `(line-number-current-line ((,class (:foreground "grey60"))))

   `(help-key-binding ((,class (:box nil))))

   ;; other misc faces
   `(link ((,class (:foreground "#8ac6f2" :underline t))))
   `(link-visited ((,class (:foreground "#e5786d" :underline t))))
   `(button ((,class (:background "#333333" :foreground "#f6f3e8"))))
   `(dired-directory ((,class (:underline t))))
   `(eshell-ls-directory ((,class (:underline t))))
   `(eshell-prompt ((,class (:weight ultra-bold))))
   `(magit-section-heading ((,class (:weight ultra-bold :height 1.1))))

   `(show-paren-match ((,class
			(:foreground unspecified
			 :background unspecified
			 :underline t))))))

(defvar ok-faces
  (append
   (mapcar #'cadr (get 'quiet 'theme-settings))
   '(magit-diff-added-highlight magit-diff-removed-highlight)))

(defun quiet (face)
  (unless (member face ok-faces)
    (set-face-attribute face nil :background "#242424" :foreground "#f6f3e8")
    (let ((underline (face-attribute face :underline)))
      (when (plist-get underline :color)
	(set-face-attribute face nil :underline (plist-put underline :color 'foreground-color))))))

(dolist (face (face-list))
  (quiet face))

(advice-add #'custom-declare-face :after
	    (lambda (face spec doc &rest _)
	      (quiet face)))

(provide-theme 'quiet)
