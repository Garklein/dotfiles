;;;###theme-autoload
(deftheme quiet
  "Minimal highlighting"
  :background-mode 'dark
  :kind 'color-scheme)

(let* ((class '((class color) (min-colors 89)))
       (default `((,class (:background "#242424" :foreground "#f6f3e8"))))
       (highlight `((,class (:background "#595959"))))
       (string `((,class (:foreground "#ffbf99"))))
       (comment `((,class (:foreground "#799cfc")))))
  (custom-theme-set-faces
   'quiet
   `(default ,default)
   `(cursor ((,class (:background "#b7b7b7"))))

   ;; Highlighting faces
   `(fringe ,default)
   `(highlight ,highlight)
   `(region ,highlight)
   `(secondary-selection ,highlight)
   `(isearch ,highlight)
   `(lazy-highlight ,highlight)

   ;; Mode line faces
   `(mode-line ((,class (:foreground "#f6f3e8" :overline t))))
   `(mode-line-inactive ((,class (:foreground "#857b6f"))))
   `(header-line ,default)
   `(fringe ,default)
   `(window-divider ((,class (:foreground "#242424"))))
   `(window-divider-first-pixel ((,class (:foreground "#242424"))))
   `(window-divider-last-pixel ((,class (:foreground "#242424"))))

   ;; Escape and prompt faces
   `(minibuffer-prompt ,default)
   `(escape-glyph ,default)
   `(homoglyph ,default)

   ;; Font lock faces
   `(font-lock-builtin-face ,default)
   `(font-lock-comment-face ,comment)
   `(font-lock-constant-face ,default)
   `(font-lock-function-name-face ,default)
   `(font-lock-keyword-face ,default)
   `(font-lock-string-face ,string)
   `(font-lock-type-face ,default)
   `(font-lock-variable-name-face ,default)
   `(font-lock-warning-face ,default)
   `(font-lock-doc-face ,default)
   `(elisp-shorthand-font-lock-face ,default)
   `(web-mode-html-tab-face ,default)
   `(org-block ,default)

   ;; other misc faces
   `(help-key-binding ,default)
   `(link ((,class (:foreground "#8ac6f2" :underline t))))
   `(link-visited ((,class (:foreground "#e5786d" :underline t))))
   `(button ((,class (:background "#333333" :foreground "#f6f3e8"))))
   `(calendar-weekend-header ,default)
   `(dired-directory ((,class (:underline t))))
   `(dired-flagged ,default)
   `(flymake-note ((,class (:underline (:style wave)))))
   `(flymake-error ((,class (:underline (:style wave)))))
   `(eshell-prompt ((,class (:weight ultra-bold))))
   `(magit-section-heading ((,class (:weight ultra-bold :height 1.1))))
   `(magit-section-heading-selection ,default)
   ))

(provide-theme 'quiet)
