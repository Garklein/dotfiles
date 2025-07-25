;;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ignored-local-variable-values
   '((eval run-term-command "cd ~/repos/mlatu" "make" "./repl")))
 '(safe-local-variable-values
   '((eval progn (electric-indent-local-mode 0)
	   (setq indent-line-function
		 (lambda nil (interactive) (insert "  ")))
	   (set-command (with-file-name "py" "uv run main.py")))
     (eval progn (electric-indent-local-mode 0)
	   (setq indent-line-function
		 (lambda nil (interactive) (insert "  ")))
	   (set-command "uv run main.py"))
     (eval progn (electric-indent-local-mode 0)
	   (setq indent-line-function
		 (lambda nil (interactive) (insert "  "))))
     (eval unless (equal (buffer-name) "COMMIT_EDITMSG")
	   (set-command (compile "cd ~/garklein.github.io && ./build"))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
